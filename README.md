This plugin was written to output information on Source-server (primarily Insurgency) that can be interpreted by the [Skillbird-framework](https://gitlab.com/Sheppy_/skillbird) and in turn be queried as useful information to display back the players or use for team-balancing.

## Setup
You may install this plugin like any other Sourcemod plugin. Please refer to [sourcemod.net](https://www.sourcemod.net/) for information about that and the relevant Sourcemod-binaries.

## Usage
The output must be written to a file from which the skillbird-framework can read it. As a simple solution you can just write it to a file using a pipe:

    ./start_server.sh > output.log

Or if you still want to see the output as it is printed:

    ./start_server.sh | tee output.log

What I am personally doing is starting Insurgency with systemd and then:

    journalctl -fu insurgency.service > output.log

## Why do you include sm-socket as binaries?
Because building Sourcemod extensions is annoying to do for the average user, I know it's not a perfect solution, but it's the best I could come up with. In compliance with the terms of the GPL (the license of Sourcemod), you may find the source code of those binaries [here](https://github.com/nefarius/sm-ext-socket).
