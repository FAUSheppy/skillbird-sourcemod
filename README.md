This plugin was written to output information on Source-server (primarily Insurgency) that can be interpreted by the [Skillbird-framework](https://github.com/FAUSheppy/skillbird) and in turn be queried as useful information to display back the players or use for team-balancing.

# Setup
## Install Insurgency Server
Install [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD):

    # first add non-free to sources list for Debian or multiverse for Ubuntu #
    sudo dpkg --add-architecture i386
    sudo apt update
    sudo apt install lib32gcc1 steamcmd

Start CMD and install the [Insurgency Server](https://developer.valvesoftware.com/wiki/Insurgency_2014_Dedicated_Server):

    steamcmd
    Steam> login anonymous
    Steam> force_install_dir /path/to/installation
    Steam> app_update 237410

## Compile Plugin
Download and unpack [Sourcemod](http://www.sourcemod.net/downloads.php), after unpacking, there should be two directories, *addons* and *cfg*. Execute *build.sh* with the addons dir as argument.

Download and unpack the extensions [json](https://github.com/FAUSheppy/sm-json) and and move all files into the *scriping/include/* directory.
Download and upack the [system2](https://forums.alliedmods.net/showthread.php?t=146019) and and move all files into the *scriping/include/* and *extensions* directory respectively.

    ./build.sh /path/to/addons/dir/

## Add Sourcemod/Plugins to Insurgency Server
Download [Metamod](http://www.metamodsource.net/downloads.php?branch=stable) and unpack it, copy all contents of the unpacked source and metamod to the *insurgency*-directory in the base path of your installation (*addons* for both metamod and sourcemod and *cfg* for sourcemod only).

    cp -r /path/to/downloaded/unpacked/tar/metamod/addons/   /path/to/installation/insurgency/
    cp -r /path/to/downloaded/unpacked/tar/sourcemod/addons/ /path/to/installation/insurgency/
    cp -r /path/to/downloaded/unpacked/tar/sourcemod/cfg/    /path/to/installation/insurgency/

## Run Insurgency Server
The Insurgency Server has some path-related problems, therefore you need to explicitly add the paths to the installation. Also if you are using LD\_PRELOAD, you should unset it, VAC doesn't like that.

    unset LD_PRELOAD
    export LD_LIBRARY_PATH=/path/to/installation/:/path/to/installation/bin/
    /path/to/installation/srcds_linux

## Install/Activate the skillbird-plugin
Finally copy the compiled plugin to sourcemod plugin addon directory within the Insurgency installation and reload.

    cp gitdirectory/extensions/* /path/to/installation/insurgency/addons/sourcemod/extensions/
    cp gitdirectory/*.smx /path/to/installation/insurgency/addons/sourcemod/scripting/compiled/

In the Server console (or via rcon). It is normal for the console to be laggy.
    
    sm plugins refresh
    sm plugins unload_all
    sm plugins load Skillbird

# Why include system2 as binaries?
Because I'm a lazy cheat. It's not against the GPL as long as I tell you the source-code is [here](https://github.com/dordnung/System2). Building sourcemod extensions can be complicated for the uninitiated.

# Why do you have the json dependency in your repro
Because I'm a lazy cheat and there is no dependency manager for sourcemod, please leave [this guy](https://github.com/clugg/sm-json/) a star.
