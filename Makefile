# Makefile - build system for the project
# Copyright (c) 2023 K. Y. Cemal Öztürk

# Compiler and flags
AS = as
LD = ld

# Output file names
OUTPUT_DIR = bin
OUTPUT_FILE = bootloader.bin

# Source file and object file names
SRC_DIR = src
SRC_FILE = $(SRC_DIR)/boot.s
OBJ_FILE = $(OUTPUT_DIR)/boot.o

# Create the output directory if it doesn't exist
$(shell mkdir -p $(OUTPUT_DIR))

# Rules for assembling the source file
$(OBJ_FILE): $(SRC_FILE)
	$(AS) -o $@ $<

# Linking the object file to create the final binary
$(OUTPUT_DIR)/$(OUTPUT_FILE): $(OBJ_FILE)
	$(LD) --oformat=binary -o $@ $<

# Default target
all: $(OUTPUT_DIR)/$(OUTPUT_FILE)

# Clean up the generated files
clean:
	rm -rf $(OUTPUT_DIR)

# Prepare the specified disk for cuteloader installation
DEVICE_NAME ?= /dev/sdc

ldimg:
	@echo "Creating sfdisk script for device: $(DEVICE_NAME)"
	@./cuteloader-sfd.awk -v device_name="$(DEVICE_NAME)" > build/cuteloader.sfd
	@echo ""
	@echo "Partition script created. To apply the partitions, run:"
	@echo "sudo sfdisk $(DEVICE_NAME) < build/cuteloader.sfd"

