# PIC32 Makefile
# #####################################
#
# Part of the uCtools project
# uctools.github.com
#
#######################################
# user configuration:
#######################################
# TARGET: name of the output file
TARGET = main
# MCU: part number to build for
MCU = 32MX210F016B
# SOURCES: list of input source sources
SOURCES = main.c usb/usb_descriptors.c usb/usb_device.c
# OUTDIR: directory to use for output
OUTDIR = build
# define flags
CFLAGS = -g -O1 -Wall -Wunused -mprocessor=$(MCU) -x c
ASFLAGS = -x assembler-with-cpp -Wa,-gstabs
LDFLAGS = -Wl,-Map=$(OUTDIR)/$(TARGET).map -mprocessor=$(MCU)
#######################################
# end of user configuration
#######################################
#
#######################################
# binaries
#######################################
CC      = xc32-gcc
LD      = xc32-ld
AR      = xc32-ar
AS      = xc32-as
NM      = xc32-nm
OBJCOPY = xc32-objcopy
RM      = rm -f
MKDIR	= mkdir -p
#######################################

# file that includes all dependancies
DEPEND = $(SOURCES:.c=.d)

# list all object files
OBJECTS = $(addprefix $(OUTDIR)/,$(notdir $(SOURCES:.c=.o)))

# default: build all
all: $(OUTDIR)/$(TARGET).elf $(OUTDIR)/$(TARGET).hex $(OUTDIR)/$(TARGET).srec

$(OUTDIR)/%.srec: $(OUTDIR)/%.elf
	$(OBJCOPY) -j .text -j .data -O srec $< $@

$(OUTDIR)/%.elf: $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) $(LIBS) -o $@

$(OUTDIR)/%.hex: $(OUTDIR)/%.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(OUTDIR)/%.o: src/%.c | $(OUTDIR)
	$(CC) -c $(CFLAGS) -o $(addprefix $(OUTDIR)/,$(notdir $@)) $<

%.lst: %.c
	$(CC) -c $(ASFLAGS) -Wa,-anlhd $< > $@

# create the output directory
$(OUTDIR):
	$(MKDIR) $(OUTDIR)

clean:
	-$(RM) $(OUTDIR)/*
