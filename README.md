# MalRecon
Basic Malware Reconnaissance Tool
by [Outrider](https://github.com/0utrider)

## Information
This is just a simple tool used to automate some of the more mundane tasks when obtaining malware. The final action is to compress/encrypt all of the files in a 7z for portability and analysis. It is designed to work out-of-the-box with Kali Linux, but should work with most 'nix distros with no problem.

I plan to add more features as I think of them - if you have any ideas, especially for more useful tools and outputs, please let me know!

**Usage:** Performs basic malware/download reconnaissance of URLs (curl, wget, hashing, etc.)

**Syntax:**		`malrecon [URL] [Case Number] [Zip File Password]`

**Example:**	`malrecon http://malwaredomain.org/payload1 IN123456 MalZipP@$$`

## Prerequisites
```
binutils      Strings utility
p7zip-full    7zip file archiver
floss         FireEye Labs Obfuscated String Solver (FLOSS) - https://github.com/fireeye/flare-floss
```

## File Outputs
```
.7z           Compressed & encrypted vault of all other outputs
.curl         Curls the URL provided
.floss        FLOSS output of the .malware file
.header       File header and hex values of the .malware file
.malware      The downloaded file/binary - this is the file that is analyzed by other tools
.md5          MD5sum of the .malware file
.password     Password to .7z file
.properties   Summarized file properties of the .malware file
.sha256       SHA256sum of the .malware file
.strings      Strings output of the .malware file
.wget         wget command log file of output
```

## How To Install
This assumes you are using Kali Linux. Add 'sudo' before commands if you are not logged in as root.

```
apt-get install git -y
mkdir -p [/install/path]
cd [/install/path]
git clone https://github.com/0utrider/malrecon
./install
```

## How to Update
Simply run the *update* script from within the malrecon directory.

```
cd [/install/path]/malrecon
./update
```

## To-Do
- [x] Add 7zip support
- [ ] Add dependency installer script
- [ ] Find additional tools to use for outputs
