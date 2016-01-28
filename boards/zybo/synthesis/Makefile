BIN_DIR   := ../../../bin
UBOOT_DIR := ../../../u-boot
LINUX_DIR := ../../../linux
SDMNT_DIR := /mnt/sd_card
SDDEV_DIR := /dev/sdb1

all: hw toolkit

toolkit: u-boot linux dtb u-boot.bin

hw: sdk

project:
	vivado -mode batch  -source create_project.tcl

synth: project
	vivado -mode batch -source synth.tcl

u-boot: 
	printf "\n\nNow u-boot Buildig\n\n" 
	cd ${UBOOT_DIR} ;\
	make CROSS_COMPILE=arm-xilinx-linux-gnueabi- zynq_zybo_config  ;\
	make CROSS_COMPILE=arm-xilinx-linux-gnueabi- 
	@if [ ! -d ${BIN_DIR} ]; then \
		mkdir ${BIN_DIR} ;\
	fi
	cp ${UBOOT_DIR}/u-boot ${BIN_DIR}/u-boot.elf ;\

linux:
	printf "\n\nNow u-boot Buildig\n\n" 
	cd ${LINUX_DIR} ;\
	make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- xilinx_zynq_defconfig ;\
	make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- ;\
	make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- UIMAGE_LOADADDR=0x8000 uImage 

u-boot.bin: ../../../bin/fsbl.elf runs/sample_project.runs/impl_1/system_wrapper.bit
	bootgen -arch zynq -image ../data/boot.bif -o ${BIN_DIR}/BOOT.bin  

dtb:
	cp ../data/ramdisk8M.image.gz ${LINUX_DIR}/
	cd ${LINUX_DIR} ;\
	mkimage -A arm -T ramdisk -c gzip -d ./ramdisk8M.image.gz uramdisk.image.gz ;\
	./scripts/dtc/dtc -I dts -O dtb -o ../devicetree.dtb arch/arm/boot/dts/zynq-zybo.dts

export: synth
	vivado -mode batch -source export_hardware.tcl

sdk: export
	xsct build_fsbl.tcl 
	if [ ! -d ${BIN_DIR} ]; then \
		mkdir ${BIN_DIR} ;\
	fi
	cp runs/sample_project.sdk/fsbl/Debug/fsbl.elf ${BIN_DIR}/

fetch:
	@if [ ! -d ${UBOOT_DIR} ]; then \
		git clone -b master-next https://github.com/DigilentInc/u-boot-Digilent-Dev.git ${UBOOT_DIR} ;\
	fi
	@if [ ! -d ${LINUX_DIR} ]; then \
		git clone -b master-next https://github.com/DigilentInc/Linux-Digilent-Dev.git ${LINUX_DIR} ;\
	fi

sd-card:
	sudo mkdir ${SDMNT_DIR}
	sudo mount ${SDDEV_DIR} ${SDMNT_DIR}
	cp ${LINUX_DIR}/arch/arm/boot/uImage ${SDMNT_DIR}
	cp ../../../devicetree.dtb ${SDMNT_DIR}
	cp ${LINUX_DIR}/uramdisk.image.gz ${SDMNT_DIR}
	cp ${BIN_DIR}/BOOT.bin ${SDMNT_DIR}
	sudo umount ${SDMNT_DIR}
	sudo rmdir ${SDMNT_DIR}


clean:
	rm -fr runs vivado*jou vivado*log ${BIN_DIR}

dist-clean:
	rm -rf ${UBOOT_DIR} ${LINUX_DIR}

sdk-clean:
	rm -rf runs/sample_project.sdk ${BIN_DIR}/fsbl.elf


.PHONY: clean dist-clean sdk-clean sd-card fetch sdk export  synth linux project u-boot
