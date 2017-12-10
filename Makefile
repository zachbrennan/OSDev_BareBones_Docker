#Basic Docker build command
BUILDER := sudo docker build

#Name of image to be created
IMAGE := ubuntu:baseOS

#Basic Docker run command
RUNNER := sudo docker run --rm

#Binds the PWD to one referenced in Docker image
DIRBIND := $(PWD):/build

#Compiler of choice
CC := gcc

#Flags for the compilation command
FLAGS := -static

#Files to be compiled
INPUT := hello.c

#Output name
OUTPUT := myos

#Output location
OUTLOC := bin

#Location mounted in image
MOUNT := /build

#Source for OS files
SRC := src

#---------------------------------------------------------------

run:
#	@./bin/hello

image:
	$(BUILDER) -t $(IMAGE) .

build:
	mkdir -p bin
	$(RUNNER) -v $(DIRBIND) -it $(IMAGE) /bin/sh -c \
	' \
	cd /build ;\
	pwd ;\
	i686-elf-as $(SRC)/boot.s -o $(OUTLOC)/boot.o ;\
	i686-elf-gcc -c $(SRC)/kernel.c -o $(OUTLOC)/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra ;\
	i686-elf-gcc -T $(SRC)/linker.ld -o $(OUTLOC)/myos.bin -ffreestanding -O2 -nostdlib $(OUTLOC)/boot.o $(OUTLOC)/kernel.o -lgcc ;\
	ls \
	'
buildISO:
	$(RUNNER) -v $(DIRBIND) -it $(IMAGE) /bin/sh -c \
	' \
	apt-get install -y grub-common grub-pc-bin xorriso ;\
	cd /build ;\
	mkdir -p isodir/boot/grub ;\
	cp $(OUTLOC)/myos.bin isodir/boot/myos.bin ;\
	cp grub.cfg isodir/boot/grub/grub.cfg ;\
	grub-mkrescue -o myos.iso isodir ;\
	'

clean:
	#This is probably bad practice. Need to find why they can't be removed without "sudo"
	sudo rm -rf ./bin
