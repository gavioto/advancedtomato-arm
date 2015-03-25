# Prequesites to build AdvancedTomato ARM on Debian Wheezy 7.7 X64

- 1.) Enable i386 support, write via terminal: 
```
#!bash

sudo dpkg --add-architecture i386
```


- 2.) Download & install following packages:

```
#!bash

sudo apt-get install build-essential autoconf libncurses5 libncurses5-dev m4 bison flex libstdc++6-4.4-dev g++-4.4 g++ libtool sqlite gcc g++ binutils patch bzip2 flex bison make gettext unzip zlib1g-dev libc6 gperf sudo automake automake1.9 git-core lib32stdc++6 libncurses5 libncurses5-dev m4 bison gawk flex libstdc++6-4.4-dev g++-4.4-multilib g++ git gitk zlib1g-dev autopoint libtool shtool autogen mtd-utils gcc-multilib gconf-editor lib32z1-dev pkg-config gperf libssl-dev libxml2-dev libelf1:i386 make intltool libglib2.0-dev libstdc++5 texinfo dos2unix xsltproc libnfnetlink0 libcurl4-openssl-dev libxml2-dev libgtk2.0-dev libnotify-dev libevent-dev mc
```


- 3.) For transmission you will need automake 1.13.2 which u can get from here:

```
#!bash

wget http://tomato.groov.pl/download/K26RT-N/testing/automake_1.13.2-1ubuntu1_all.deb
dpkg -i automake_1.13.2-1ubuntu1_all.deb
```


- 4.) Clone repository to your hard drive

```
#!bash

git clone git@bitbucket.org:jackysi/advancedtomato-arm.git advancedtomato-arm
```


- 5.) Now you need to link toolchains to the git repo you downloaded

```
#!bash

sudo ln -s $HOME/advancedtomato-arm/release/src-rt-6.x.4708/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3
```


- 6.) Add toolchains to your $PATH

```
#!bash

echo "export PATH=$PATH:/opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3/bin:/sbin/" >> ~/.profile && source ~/.profile
```


- 7.) READY! Too see the options for builds (routers and packages) do:

```
#!bash

cd advancedtomato-arm/release/src-rt-6.x.4708 && make help     # For Tomato ARM builds (not many devices listed yet, but if u see source there is many more options)
```


- 8.) To compile specific firmware (E.g. RT-AC66U) run this:

```
#!bash

cd advancedtomato-arm/release/src-rt-6.x.4708/make r7000z V1=AT-ARM V2=2.6-127
```


After the compile process is done, you will find your router image inside "$HOME/advancedtomato-arm/release/src-rt-6.x.470/image"

Thats it!