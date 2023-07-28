# partable.m4 - Partitioning table for Cuteloader

# the device name which Cuteloader will be installed
define(`device_name', `/dev/sdb')dnl

# the record label for the disk
define(`reclabel_type', `mbr')dnl

# the stage1 bootloader partition
define(`STAGE1_START', `2048')dnl
define(`STAGE1_SIZE', `1469440')dnl
define(`STAGE1_TYPE', `0C')dnl

# the stage2 bootloader (and ramdisk images) partition
define(`STAGE2_START', `1471488')dnl
define(`STAGE2_SIZE', `1469440')dnl
define(`STAGE2_TYPE', `0C')dnl

# Run fdisk to get the device size and capture the output
define(`FDISK_OUTPUT', `esyscmd(`fdisk -l `device_name)')dnl

# Extract the line containing the device size information using grep
define(`SIZE_LINE', `regexp(FDISK_OUTPUT, `^Disk `device_name)': ')dnl

# Extract the total device size in sectors using awk
define(`DEVICE_SIZE', `regexp(SIZE_LINE, ` ([0-9]+) sectors', ` \1')')dnl

# Calculate the start and size of the third partition
define(`PART3_START', `STAGE2_START + STAGE2_SIZE')dnl
define(`PART3_SIZE', `DEVICE_SIZE - PART3_START')dnl

# the third partition (freely available space)
define(`PART3_TYPE', `0C')dnl
