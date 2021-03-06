ASM?= avra

.SUFFIXES: .inc .hex

ALL_TARGETS = afro_nfet.hex bs_nfet.hex tp_nfet.hex

all: $(ALL_TARGETS)

$(ALL_TARGETS): brushed_tgy.asm

.inc.hex: brushed_tgy.asm
	#	@test -e $*.asm || ln -s tgy_brushed.asm $*.asm
	$(ASM) -fI -o $@ -D $*_esc -e $*.eeprom -d $*.obj brushed_tgy.asm
	@test -L $*.asm && rm -f $*.asm || true

test: all

clean:
	-rm -f $(ALL_TARGETS) *.cof *.obj *.eep.hex *.eeprom


#brushed_tgy.hex: brushed_tgy.asm
#	avra -fI -o brushed_tgy.hex -e brushed_tgy.eeprom -d brushed_tgy.obj brushed_tgy.asm

upload_afro: afro_nfet.hex
	avrdude -c stk500v2 -b 19200 -P /dev/ttyUSB* -v -u -p m8 -U flash:w:afro_nfet.hex:i

upload_bs: bs_nfet.hex
	avrdude -c stk500v2 -b 19200 -P /dev/ttyAMA* -v -u -p m8 -U flash:w:bs_nfet.hex:i

upload_tp: tp_nfet.hex
	avrdude -c stk500v2 -b 19200 -P /dev/ttyAMA* -v -u -p m8 -U flash:w:tp_nfet.hex:i


prog_tp: tp_nfet.hex
	avrdude -c avrisp -b 19200 -P /dev/ttyUSB0 -u -p m8 -U flash:w:tp_nfet.hex:i
	avrdude -c avrisp -b 19200 -P /dev/ttyUSB0 -u -p m8 -U lock:w:0x03:m


download:
	avrdude -c stk500v2 -b 19200 -P /dev/ttyUSB* -v -u -p m8 -U flash:r:test.hex:i
