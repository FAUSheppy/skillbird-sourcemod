#cp
cd sourcemod/scripting/
cp TrueSkillLoggingMain.sp TrueSkillQueryMain.sp client.sp utils.sp query.sp ~/sourcemod/addons/sourcemod/scripting

# go dir
cd ~/sourcemod/addons/sourcemod/scripting

# compile
./compile.sh TrueSkillLoggingMain.sp TrueSkillQueryMain.sp

# copy to plugins
#cp compiled/insurgency_query.smx compiled/ints_logging.smx ../plugins

# reload
#insurgency_rcon sm plugins reload insurgency_query.smx && insurgency_small_rcon sm plugins reload insurgency_query.smx
