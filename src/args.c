// args.h - declares command line arguments
// Copyright (c) 2023 The TRANS Project, The Cuteloader Project
// for more information see ../LICENSE.txt

// describes a kernel argument
struct __attribute__((packed)) cuteloader_arg {
	char name[128];
	char value[128];
}

