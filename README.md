![Aoscp for Devs](http://i.imgur.com/A0jUjxO.png)

Downloading the Source
===================

Please read the [AOSP building instructions](http://source.android.com/source/index.html) before proceeding.

Initializing the Repository
-----------------------

Init core trees without any device/kernel/vendor :

    $ repo init -u https://github.com/CypherOS/platform_manifest.git -b n7.0

sync repo :

    $ repo sync

***

Building AOSCP
--------

After the sync is finished, please read the [instructions from the Android site](http://s.android.com/source/building.html) on how to build.
To build AOSCP first execute this command:

    . build/envsetup.sh
	
This 


You can also build (and see how long it took) for specific devices (eg. hammerhead) like this:

    . build/envsetup.sh
    lunch aoscp_hammerhead-userdebug

Remember to `make clean` every now and then!
