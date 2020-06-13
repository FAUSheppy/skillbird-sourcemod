This plugin was written to output information on Source-server (primarily Insurgency) that can be interpreted by the [Skillbird-framework](https://gitlab.com/Sheppy_/skillbird) and in turn be queried as useful information to display back the players or use for team-balancing.

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
Download and upack the [system2](https://forums.alliedmods.net/showthread.php?t=146019), follow the instructions there to install it.

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
    sm plugins load TrueSkillLoggingMain
    sm plugins load TrueSkillQueryMain

## Data Output for skillbird
The output must be written to a file from which the skillbird-framework can read it. As a simple solution you can just write it to a file using a pipe:

    ./start_server.sh > output.log

Or if you still want to see the output as it is printed:

    ./start_server.sh | tee output.log

What I am personally doing is starting Insurgency with systemd and then:

    journalctl -fu insurgency.service > output.log

Set sv\_logflush to 1 in the server.cfg to write out the information in shorter intervals, the performance impact is negligible.

# Why include sm-socket as binaries?
Because building Sourcemod extensions is annoying to do for the average user. I know it's not a perfect solution, but it's the best I could come up with. In compliance with the terms of the GPL (the license of Sourcemod), you may find the source code of those binaries [here](https://github.com/nefarius/sm-ext-socket).
