use x86_64::instructions::Port;

/// Represents a Globally Unique Identifier (GUID)
#[repr(transparent)]
struct GUID([u8; 16]);

impl GUID {
    pub const fn from_str(const s: &str) -> Self {
        todo!()
        // i am actually tired af i don't want to faint again :(
    }
}

/// Represents a GUID Partition Table entry.
#[derive(Debug)]
struct Partition {
    part_type: GUID,
    part_id: GUID,
    prot_mbr: ProtectiveMBRHeader,
    // TODO: Actually implement this piece of penguin,
    //       I actually have implemented this on my
    //       notebook, but I didn't have my notebook
    //       with me at the time of writing this,
    //       I hope I don't faint when I return home.
}
