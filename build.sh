#/bin/bash

unset LD_PRELOAD

if [ $# -ne 1 ]; then
    echo "Missing Arguments Addons-Dir, see README.md"
    exit 1
fi

sourcemod_addons_dir=$1
plugin_dir=$sourcemod_addons_dir/sourcemod/scripting
ext_dir=$sourcemod_addons_dir/sourcemod/extensions

cp scripting/*.sp $plugin_dir/
cp -r scripting/include/* $plugin_dir/include/
cp extensions/* $ext_dir/

originDir=$(pwd)
cd $plugin_dir
./compile.exe Skillbird.sp
#cp compiled/TrueSkill* $originDir/
