all: runs/top.runs/impl_1/top.bit 

project:
	vivado -mode batch  -source create_project.tcl

synth:
	vivado -mode batch -source synth.tcl

fetch:
	git clone -b master-next https://github.com/DigilentInc/u-boot-Digilent-Dev.git ../../../u-boot 
	git clone -b master-next https://github.com/DigilentInc/Linux-Digilent-Dev.git ../../../tools
	

u-boot:
	cd ../../../u-boot/ &&\
	make CROSS_COMPILE=arm-xilinx-linux-gnueabi- zynq_zybo_config  &&\
	make CROSS_COMPILE=arm-xilinx-linux-gnueabi- &&\
	mkdir ../bin/  &&\
	cp u-boot ../bin/u-boot.elf 

u-boot-tools:
	cd ../../../tools &&\
	make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- xilinx_zynq_defconfig &&\
	make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- &&\
	make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- UIMAGE_LOADADDR=0x8000 uImage 

u-boot.bin: ../../../bin/fsbl.elf runs/sample_project.runs/impl_1/system_wrapper.bit
	bootgen -arch zynq -image ../data/boot.bif -o ../../../bin/BOOT.bin  

dtb:
	cp ../data/ramdisk8M.image.gz ../../../tools/
	cd ../../../tools &&\
	mkimage -A arm -T ramdisk -c gzip -d ./ramdisk8M.image.gz uramdisk.image.gz &&\
	./scripts/dtc/dtc -I dts -O dtb -o ../devicetree.dtb arch/arm/boot/dts/zynq-zybo.dts

export: runs/sample_project.runs/impl_1/system_wrapper.bit
	vivado -mode batch -source export_hardware.tcl

sdk: runs/sample_project.sdk/system_wrapper.hdf 
	xsct build_fsbl.tcl &&\
	cp runs/sample_project.sdk/fsbl/Debug/fsbl.elf ../../../bin/

sd-card:
	sudo mkdir /mnt/sd_card
	sudo mount /dev/sdb1 /mnt/sd_card
	cp ../../../tools/arch/arm/boot/uImage /mnt/sd_card/
	cp ../../../devicetree.dtb /mnt/sd_card/
	cp ../../../tools/uramdisk.image.gz /mnt/sd_card/
	cp ../../../bin/BOOT.bin /mnt/sd_card/
	sudo umount /mnt/sd_card

load: runs/top.runs/impl_1/top.bit 
	./xprog.sh load

flash: runs/top.runs/impl_1/top.mcs 
	./xprog.sh flash

runs/top.runs/impl_1/top.bit:
	vivado -mode batch -source  zybo_batch.tcl 

runs/top.runs/impl_1/top.mcs: runs/top.runs/impl_1/top.bit
	./xprog.sh mcs

clean:
	rm -fr runs vivado*jou vivado*log ../../../bin/*

dist-clean:
	rm -rf ../../../u-boot

sdk-clean:
	rm -rf runs/sample_project.sdk ../../../bin/fsbl.elf


.PHONY: clean gui load flash
