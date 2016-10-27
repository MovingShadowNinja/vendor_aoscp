![Aoscp for Devs](http://i.imgur.com/A0jUjxO.png)

Downloading the Source
===================

Please read the [AOSP building instructions](http://source.android.com/source/index.html) before proceeding.

Initializing the Repository
-----------------------

Init core trees without any device/kernel/vendor :

    $ repo init -u https://github.com/CypherOS/platform_manifest.git -b n7.0

Sync our repository :

    $ repo sync

***

Building AOSCP
==============

After the sync is finished, please read the [instructions from the Android site](http://s.android.com/source/building.html) on how to build.
To build AOSCP first execute this command:

    . build/envsetup.sh
	
This command will load all of our proprietary makefiles for compiling! After the files are initiated,
Run this command:

    brunch
	
No need to generate your device manually. If we official support your device, or if your device is in our vendor/aoscp.devices list
it will be appear on our brunch menu. Next, all your have to do is pick the number beside your device eg.

    3. aoscp_bullhead-userdebug (Type "3" and press enter)
	
Now sit back and wait for your compilation to complete successfully!
Remember to `make clean` every now and then!
