# OSDev_BareBones_Docker

In continuing experimentations with Docker, I built a  Docker image based on Ubuntu 16.04, that
contains a cross-compiler for i686-elf, built with the [OSDev.org Bare Bones Tutorial](http://wiki.osdev.org/Bare_Bones).
The intended use of this image is so that I can mess with the base OS code on several different computers that I own,
without having to set up the environment on each independently, and to make sure I don't run into any problems that slightly
different environments might cause. And also because Docker is really cool, and I wanted to do something a bit more complex
than [compiling "Hello World" in C](https://github.com/zachbrennan/basicDockerCompilation) with it.

### Building the Image

```
make image
```
will create the image. Be aware, it will take a very long time. Along with installing a bunch of packages, the image needs
to build *gcc* and *binutils* from the source, which can be very time consuming. The created image is just over 3GB,
which is insane. I did this with an Ubuntu base, because I am most familiar with Ubuntu, but I might try to move it 
to an Alpine system, to make it a bit lighter.

### Compiling the OS

```
make build
```
will compile the OS from the files in the *src* folder

### Building an ISO

```
make build
```
will use the compiled files in the *bin* directory to create a bootable *.iso* of your OS.

### Running the ISO

This part doesn't use Docker! Yet! Make sure that you have QEMU installed on the machine you are running this on
, and you should be able to boot the OS in a virtual window with the 
```
make run
```
command. If QEMU is not installed, you should be able to install it with:

* Arch: ```pacman -S qemu```

* Debian/Ubuntu: ```apt-get install qemu```

* Fedora: ```dnf install @virtualization```

* Gentoo: ```emerge --ask app-emulation/qemu```

* RHEL/CentOS: ```yum install qemu-kvm```

* SUSE: ```zypper install qemu```

### Cleanup

```
make clean
```
will delete only the compiled OS files in the *bin* folder, not the *.iso* that you create. This will ask for your *sudo*
password, because the files that come from the Docker container are owned by *root*, so unless you run it as root, you will 
get a *permission denied* error. I'm looking for a way to fix that.
