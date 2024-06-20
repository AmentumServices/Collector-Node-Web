#!/bin/bash
SRC=$(basename "$PWD")
REPO="JacobsFederal/$SRC"
DEST="$HOME/Downloads/$SRC"

echo -e "\nWorking with github repo $REPO"
echo -e "Listing releases\n"
gh release list -R $REPO
echo -e "\nDownloading Latest to $DEST\n"
gh release download -p "*" -D $DEST -R $REPO
ls -Alht $DEST 
if [ $? ];then
  echo -e "\nDownload Complete!"
else
  echo "ERROR!"
fi