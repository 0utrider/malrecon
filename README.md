# MalRecon
Basic Malware Reconnaissance Tool
by [Outrider](https://github.com/0utrider)

## Information
This is just a simple tool used to automate some of the more mundane tasks when obtaining malware for analysis. The final action is to compress/encrypt all of the files in a 7z for portability and analysis.

I plan to add more features as I think of them - if you have any ideas, especially for more useful tools and outputs, please let me know!

**Usage:** Performs basic malware/download reconnaissance of URLs (curl, wget, hashing, etc.)

**Syntax:**		`malrecon [URL] [Case Number] [Zip File Password]`

**Example:**	`malrecon http://malwaredomain.org/payload1 IN123456 MalZipP@$$`




## File Outputs
```
.7z           Compressed & encrypted vault of all other outputs
.curl         Curls the URL provided
.floss        FireEye Labs Obfuscated String Solver (FLOSS) out of the .malware file
.header       File header and hex values of the .malware file
.malware      The downloaded file/binary - this is the file that is analyzed by other tools
.md5          MD5sum of the .malware file
.properties   Summarized file properties of the .malware file
.sha256       SHA256sum of the .malware file
.strings      Strings output of the .malware file
.wget         wget command log file of output
```

## To-Do
- [x] Add 7zip support
- [ ] Add dependency installer script
- [ ] Find additional tools to use for outputs
