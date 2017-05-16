#!/bin/bash
#
# MalRecon - A Basic Malware Reconnaissance Tool, by Outrider
#
# Usage:	Performs basic malware/download reconnaissance of URLs (curl, wget, hashing, etc.)
# Syntax:	malrecon [URL] [Case No.] [Password]
# Example:	malrecon http://malwaredomain.org/payload1 IN123456 MalZippity!
#
# Get the latest version here: https://github.com/0utrider/malrecon
#
#
#    Copyright 2017 Outrider - https://keybase.io/outrider
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# =================== USER DEFINED VARIABLES ===================

## Default password for 7zip files
reconDefaultPass="MalZippity!"

## The user agent string below is the tool pretending to be Internet Explorer 9 running on Windows 7
### For more user agents:		http://www.useragentstring.com/pages/useragentstring.php
reconAgent="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)"

## Output directory
### Default is the "recon" directory user's home path, i.e.: ~/recon/
reconPath="~/recon"

## File permissions
### Read-write with no execute "660"
### Change to read only "440" if you want this to be more forensically sound
reconPermissions="660"

# ================= END USER DEFINED VARIABLES =================

# Banner
echo ""
echo -e "\033[38;5;0m                                             \033[0m"
echo -e "\033[38;5;196m    (_     __)       \033[38;5;63m  _____                 \033[0m"
echo -e "\033[38;5;196m      /|  /|       /)\033[38;5;63m    /   )               \033[0m"
echo -e "\033[38;5;196m     / | / |  _   // \033[38;5;63m   /__ /  _  _  _____   \033[0m"
echo -e "\033[38;5;196m  ) /  |/  |_(_(_(/_ \033[38;5;63m  /   \__(/_(__(_) / (_ \033[0m"
echo -e "\033[38;5;196m (_/   '             \033[38;5;63m /                      \033[0m"
echo -e "\033[38;5;254m           v1.06               by Outrider   \033[0m"
echo -e "\033[38;5;0m                                             \033[0m"
echo -e "      Basic Malware Reconnaissance Tool      "
echo ""
echo "           https://git.io/0utrider           "
echo ""

# Define the URL to be reconned
if [ -z "$1" ] ## Was the URL provided as an argument?
  then
    read -p 'URL: ' reconURL ## Ask the user for input if not
  else
	reconURL=$1 ## Set the URL if it was provided
	echo "URL: $reconURL"
fi

# Define the case number
if [ -z "$2" ] ## Was the case provided as an argument?
  then
    read -p 'Case No.: ' reconCase ## Ask the user for input if not
  else
	reconCase=$2 # Set the case number if it was provided
	echo "Case No.: $reconCase"
fi

# Define the 7zip password
if [ -z "$3" ] # Was a password provided as an argument?
  then
	read -e -p "Password: " -i "$reconDefaultPass" reconPass
  else
	reconPass=$3 # Set the password if it was provided
	echo "Password set."
fi

# Create directory structure and change working directory
echo -e "Creating directory \033[38;5;254m$reconCase\033[0m ..."
mkdir -p $reconPath/$reconCase
cd $reconPath/$reconCase

# Basic recon functions begin here
## lets curl the URL provided by the user
echo -e "Performing \033[38;5;254mcurl\033[0m ..."
curl -s -o $reconCase.curl -A "$reconAgent" $reconURL

## lets wget the URL provided by the user
echo -e "Performing \033[38;5;254mwget\033[0m ..."
wget -q --user-agent="$reconAgent" -c $reconURL -O $reconCase.malware > $reconCase.wget

## lets run checksums on the wget download
echo -e "Generating \033[38;5;254mhashes\033[0m ..."
md5sum $reconCase.malware | awk '{print $1}' > $reconCase.md5
sha256sum $reconCase.malware | awk '{print $1}' > $reconCase.sha256

## lets run strings against the download
echo -e "Generating \033[38;5;254mstrings\033[0m ..."
strings $reconCase.malware > $reconCase.strings

## lets run FLOSS (https://github.com/fireeye/flare-floss) against the download
echo -e "Generating \033[38;5;254mfloss\033[0m ..."
floss $reconCase.malware > $reconCase.floss


## lets run file data and record it to a properties file
echo "Recording basic file details ..."
echo "=======================================================================" > $reconCase.properties
###  note that we start appending to the .properties file now with >> instead of >
echo "" >> $reconCase.properties
echo "File Information:" >> $reconCase.properties
echo "--------------------" >> $reconCase.properties
file $reconCase.malware >> $reconCase.properties
echo "" >> $reconCase.properties

### sprinkle in the hashes
echo "MD5 & SHA256 Hashes:" >> $reconCase.properties
echo "--------------------" >> $reconCase.properties
cat $reconCase.md5 >> $reconCase.properties
cat $reconCase.sha256 >> $reconCase.properties
echo "" >> $reconCase.properties

### add a few spoonfuls of od (file header)
od -bc $reconCase.malware | head > $reconCase.header
echo "File Header:" >> $reconCase.properties
echo "" >> $reconCase.properties
echo "--------------------" >> $reconCase.properties
cat $reconCase.header >> $reconCase.properties
echo "" >> $reconCase.properties
echo "" >> $reconCase.properties
echo "=======================================================================" >> $reconCase.properties

# Set permissions
echo "Setting permissions ..."
chmod $reconPermissions $reconCase.*

# Zip it! Zip it good!
echo -e "Compressing and encrypting to \033[38;5;254m7z file\033[0m ..."
7z a $reconCase.7z * -mhe -mx9 -p$reconPass

# Create companion password file
echo -e "Writing \033[38;5;254mpassword file\033[0m ..."
echo -e "$reconPass" > $reconCase.password

# That's a wrap!
echo -e "\033[30;48;5;82mDone.\033[0m"
echo ""
echo -e "To see output files, navigate:    \e[38;5;214mcd ~/recon/$reconCase\033[0m\n"
