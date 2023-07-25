#!/usr/bin/awk -f

BEGIN {
    printf("label: dos\nunit: sectors\n\n")
    printf("%s1 : start=2048, size=1469440, type=0C   # FAT32\n", device_name)
    printf("%s2 : start=1471488, size=1469440, type=83   # Linux\n", device_name)
}
