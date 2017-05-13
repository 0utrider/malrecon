#!/bin/bash
#
# MalRecon - A Basic Malware Reconnaissance Tool, by Outrider
#
# Usage:	Performs basic malware/download reconnaissance of URLs (curl, wget, hashing, etc.)
# Syntax:	malrecon [URL] [Case No.]
# Example:	malrecon http://malwaredomain.org/payload1 IN123456
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

# Banner
echo ""
echo -e "\033[1;35m   (_     __)       \033[1;96m  _____\033[0m"
echo -e "\033[1;35m     /|  /|       /)\033[1;96m    /   )\033[0m"
echo -e "\033[1;35m    / | / |  _   // \033[1;96m   /__ /  _  _  _____\033[0m"
echo -e "\033[1;35m ) /  |/  |_(_(_(/_ \033[1;96m) /   \__(/_(__(_) / (_\033[0m"
echo -e "\033[1;35m(_/   '            \033[1;96m _/\033[0m"
echo -e "          v1.05               by \033[0;97mOutrider\033[0m"
echo ""
echo -e "\033[2;0mBasic Malware Reconnaissance Tool\033[0m"
echo ""
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
	reconCase=$2 ## Set the case number if it was provided
	echo "Case No.: $reconCase"
fi

# Define the case number
if [ -z "$3" ] ## Was a password provided as an argument?
  then
    read -p 'Password: ' reconPasswd ## Ask the user for input if not
  else
	reconPasswd=$3 ## Set the case number if it was provided
	echo "Password set."
fi

# Create directory structure and change working directory
echo -e "Creating directory \033[0;97m$reconCase\033[0m ..."
mkdir -p ~/recon/$reconCase
cd ~/recon/$reconCase

# Basic recon functions begin here
## lets curl the URL provided by the user
## The user agent string (-A) is us pretending to be Internet Explorer 9 running on Windows 7
## For more user agents:		http://www.useragentstring.com/pages/useragentstring.php
echo -e "Performing\033[1;37m curl \033[0m..."
curl -s -o $reconCase.curl -A "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0" $reconURL

## lets wget the URL provided by the user
echo -e "Performing\033[1;37m wget \033[0m..."
wget -q --user-agent="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0" -c $reconURL -O $reconCase.malware > $reconCase.wget

## lets run checksums on the wget download
echo -e "Generating\033[1;37m hashes \033[0m..."
md5sum $reconCase.malware | awk '{print $1}' > $reconCase.md5
sha256sum $reconCase.malware | awk '{print $1}' > $reconCase.sha256

## lets run strings against the download
echo -e "Generating\033[1;37m strings \033[0m..."
strings $reconCase.malware > $reconCase.strings

## lets run FLOSS (https://github.com/fireeye/flare-floss) against the download
echo -e "Generating\033[1;37m floss \033[0m..."
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
## Change the value to 440 if you want this to be more forensically sound
chmod 660 $reconCase.*

# Zip it! Zip it good!
echo -e "Compressing and encrypting to \033[1;37m 7z \033[0mfile ..."
7z a $reconCase.7z * -p$reconPasswd

# That's a wrap!
echo -e "\033[0;97mDone.\033[0m"
echo ""
echo -e "To see output files, navigate:    \e[38;5;214mcd ~/recon/$reconCase\033[0m\n"
