#!/bin/bash

apt-get install wget
apt-get install unzip

wget https://www.syncfusion.com/downloads/support/directtrac/general/ze/4-2-upgrader-patch1266244206.zip
unzip 4-2-upgrader-patch1266244206.zip

dotnet 4-2-upgrader-patch/4-2-upgrade/4-2-upgrader.dll
if [ -d "/boldbi/app_data/bi/dataservice/CustomWidgets" ]; then
    dotnet 4-2-upgrader-patch/customwidgetupgrader/CustomWidgetUpgrader.dll true
fi
