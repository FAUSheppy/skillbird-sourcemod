#/bin/bash

unset LD_PRELOAD

if [ $# -ne 1 ]; then
    echo "Missing Arguments Addons-Dir, see README.md"
    exit 1
fi

sourcemod_addons_dir=$1
plugin_dir=$sourcemod_addons_dir/sourcemod/scripting
ext_dir=$sourcemod_addons_dir/sourcemod/extensions

cp scripting/TrueSkillLoggingMain.sp \
   scripting/TrueSkillQueryMain.sp   \
   scripting/client.sp \
   scripting/utils.sp  \
   scripting/query.sp  \
   $plugin_dir/
   
cp scripting/include/* $plugin_dir/include/

cp extensions/* $ext_dir/

cd $plugin_dir

./compile.sh TrueSkillLoggingMain.sp TrueSkillQueryMain.sp

# mv $sourcemod_addons_dir/sourcemod/scripting/TrueSkill* 
# compiled/insurgency_query.smx compiled/ints_logging.smx ../plugins

# reload
#insurgency_rcon sm plugins reload insurgency_query.smx && insurgency_small_rcon sm plugins reload insurgency_query.smx
