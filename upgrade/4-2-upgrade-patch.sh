#!/bin/bash

utilitiesPath="/boldbi/utilities"
workDir="/boldbi/bi/dataservice"

apt-get install wget
apt-get install unzip

wget https://www.syncfusion.com/downloads/support/directtrac/general/ze/4-2-upgrader-patch-1448030332.zip
unzip 4-2-upgrader-patch-1448030332.zip

[ ! -d "$utilitiesPath" ] && mkdir -p "$utilitiesPath"
cp -a 4-2-upgrader-patch/customwidgetupgrader "$utilitiesPath"

dotnet 4-2-upgrader-patch/4-2-upgrade/4-2-upgrader.dll
if [ -d "/boldbi/app_data/bi/dataservice/CustomWidgets" ]; then
    cd "$utilitiesPath/customwidgetupgrader"
    dotnet "CustomWidgetUpgrader.dll" true
fi

rm -rf "$workDir/4-2-upgrade-patch.sh"
rm -rf "$workDir/4-2-upgrader-patch"
rm -rf "$workDir/4-2-upgrader-patch-1448030332.zip"