use x86_64::instructions::port::Port;

#[derive(Debug)]
struct PartitionEntry {
    bootable: u8,
    start_chs: [u8; 3],
    partition_type: u8,
    end_chs: [u8; 3],
    start_lba: u32,
    size_sectors: u32,
}

impl PartitionEntry {
    fn new(buffer: &[u8]) -> Self {
        Self {
            bootable: buffer[0],
            start_chs: [buffer[1], buffer[2], buffer[3]],
            partition_type: buffer[4],
            end_chs: [buffer[5], buffer[6], buffer[7]],
            start_lba: u32::from_le_bytes([
                buffer[8],
                buffer[9],
                buffer[10],
                buffer[11],
            ]),
            size_sectors: u32::from_le_bytes([
                buffer[12],
                buffer[13],
                buffer[14],
                buffer[15],
            ]),
        }
    }
}

fn read_disk_sector(buffer: &mut [u8], sector: u32) {
    let ah = 0x02; // AH = 2 (Read sector)
    let al = buffer.len() as u8;
    let ch = (sector >> 8) as u8;
    let cl = (sector & 0xFF) as u8;
    let dh = 0; // DH = 0 (Head number)
    let dl = 0x80; // DL = 0x80 (Drive number: 0x80 for first hard disk)

    unsafe {
        asm!(
            "int 0x13",
            in("ah") ah,
            in("al") al,
            in("ch") ch,
            in("cl") cl,
            in("dh") dh,
            in("dl") dl,
            inout("rcx") buffer.len() => _,
            inout("rdi") buffer.as_mut_ptr() => _,
        );
    }
}

fn fetch_bootable_partitions(sector: u32) {
    let mut mbr_buffer: [u8; 512] = [0; 512];
    read_disk_sector(&mut mbr_buffer, sector);

    let mut partition_entries: Vec<PartitionEntry> = Vec::new();
    let mut bootable_parts: Vec<PartitionEntry> = Vec::new();
    for i in 0..4 {
        let offset = 446 + i * 16;
        let entry_buffer = &mbr_buffer[offset..offset + 16];
        let partition_entry = PartitionEntry::new(entry_buffer);
        partition_entries.push(partition_entry);
    }

    for (i, entry) in partition_entries.iter().enumerate() {
        if entry.bootable == 0x80 {
		bootable_parts.push(entry)
	}
    }

    bootable_parts
}
