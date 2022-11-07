#20220826 replacement for debdb2pupdb.bac
#read a file which is a debian db, convert to puppy-format.
#pass in: compat-distro, compat-version
# ex: debian bookworm
#the debian db file to convert must be /tmp/debget/debian-pkgs-db
#writes to: /tmp/debget/puppy-pkgs-db, /tmp/debget/debian-pkgs-homepage
#note: has find_cat builtin. this gives 55K binary (after strip):
# nim c --mm:orc -d:useMalloc --passC:-flto --passL:-flto -d:release --opt:size debdb2pupdb.nim

#want commandLineParams(), fileExists()...
import std/os
#need split(), removeSuffix()...
import std/strutils
#CritBitTree for associative array...
import std/critbits
#regular expressions...
import std/re
#reverse()...
#import std/algorithm

var debarray: CritBitTree[string]

#read the commandline...
var args = commandLineParams() #in os module
if args.len() != 2:
 echo "Invalid number of parameters"
 quit(1) #1 is the return number.
var compatdistro = args[0]
var compatversion = args[1]

let ex = fileExists("/tmp/debget/debian-pkgs-db") #in os module
if not ex:
 echo "File /tmp/debget/debian-pkgs-db does not exist"
 quit(2)

#need to know whether running this in woof or puppy|easyos...
var runningpuppy: bool = true
let rx = fileExists("./DISTRO_SPECS")
if rx:
 runningpuppy = false

#after reading a paragraph from /tmp/debget/debian-pkgs-db
proc wipe_para_proc() =
 debarray["Package:"] = ""
 debarray["Version:"] = ""
 debarray["Installed-Size:"] = ""
 debarray["Architecture:"] = ""
 debarray["Depends:"] = ""
 debarray["Description:"] = ""
 debarray["Homepage:"] = ""
 debarray["Filename:"] = ""
 debarray["Section:"] = ""
 debarray["MD5sum:"] = ""

removeFile("/tmp/debget/debian-pkgs-homepage") #os module
removeFile("/tmp/debget/puppy-pkgs-db")
let homepagesfile = open("/tmp/debget/debian-pkgs-homepage", fmWrite) #io module, part of system module.
let debdbfile = open("/tmp/debget/debian-pkgs-db", fmRead)
let pupdbfile = open("/tmp/debget/puppy-pkgs-db", fmWrite)
let catfile = open("/usr/local/petget/categories.dat", fmRead)

#want to read a paragraph at a time...
var
 oneline, pupline, catline: string
 akey, aval: string
 valcut1, valcut2: string
 pupdeps, adep: string
 depcut0, depcut1, depcut2, comp1: string
 cnt1, cnt2, cntdeps, len1: int
 homepage, genericname, basename: string
 xgenericname, xbasename, newcat, asection: string
 catFlg: bool
 prevdep, currdep: string

#20220904 do here, in case first para missing some keys...
wipe_para_proc()

while readLine(debdbfile, oneline):
 if oneline == "":
  #end of paragraph
  #write to puppy-pkgs-db output file...
  #DB_pkgname|DB_nameonly|DB_version|DB_pkgrelease|DB_category|DB_size"K"|DB_path|DB_fullfilename|DB_dependencies|DB_description|compatdistro|compatversion|
  #ex: abiword_3.0.5|abiword|3.0.5||Document;layout|5133K|pool/main/a/abiword|abiword_3.0.5~dfsg-1_amd64.deb|+abiword-common&ge3.0.5,+gsfonts,+libabiword-3.0&ge3.0.5,+libc6&ge2.14,+libdbus-1-3&ge1.9.14,+libdbus-glib-1-2&ge0.78,+libgcc-s1&ge3.0,+libgcrypt20&ge1.8.0,+libglib2.0-0&ge2.16.0,+libgnutls30&ge3.7.0,+libgoffice-0.10-10&ge0.10.2,+libgsf-1-114&ge1.14.9,+libgtk-3-0&ge3.0.0,+libjpeg62-turbo&ge1.3.1,+libloudmouth1-0&ge1.3.3,+libots0&ge0.5.0,+libpng16-16&ge1.6.2-1,+librdf0&ge1.0.17,+libreadline8&ge6.0,+librevenge-0.0-0,+libsoup2.4-1&ge2.4.0,+libstdc++6&ge7,+libtelepathy-glib0&ge0.13.0,+libtidy5deb1&ge5.2.0,+libwmf0.2-7&ge0.2.8.4,+libwpd-0.10-10,+libwpg-0.3-3,+libxml2&ge2.7.4,+zlib1g&ge1.1.4|efficient featureful word processor with collaboration|debian|bookworm|
  
  #filter out some things...
  if endsWith(debarray["Package:"], "-dbg"): #strutils
   wipe_para_proc()
   continue
  
  pupline = ""
  aval = debarray["Version:"]
  valcut1 = replace(aval, re"^[0-9]:", "")
  valcut2 = replace(valcut1, re"[+~.-]*[a-z][a-z][a-z].*", "") #ex: 3.0.5~dfsg-1 reduced to 3.0.5
  removeSuffix(valcut2, '~')
  add(pupline, debarray["Package:"]) #ex: abiword
  add(pupline, "_")
  add(pupline, valcut2)
  add(pupline, "|")
  add(pupline, debarray["Package:"])
  add(pupline, "|")
  add(pupline, valcut2)
  add(pupline, "||") #ex: abiword_3.0.5|abiword|3.0.5||
  
  #why can't we insert category now, instead of calling find_cat later...
  valcut1 = parentDir(debarray["Filename:"]) #os module. ex: pool/main/a/abiword
  genericname = extractFilename(valcut1) #ex: abiword
  basename = replace(debarray["Package:"], re"\-[0-9].*", "") #in case extra stuff ex: abiword-1
  xgenericname = " " & genericname & " "
  xbasename = " " & basename & " "
  setFilePos(catfile, 0, fspSet) #io module. set filepointer to start of file.
  catFlg = false
  while readLine(catfile, catline):
   #ex: PKGCAT_Document_layout=" abiword amaya bibus focuswriter kompozer lyx scribus texmaker webservice-office-zoho-writer "
   if not startsWith(catline, "PKGCAT_"): continue #strutils
   if contains(catline, xgenericname):
    catFlg = true
   elif contains(catline, xbasename):
    catFlg = true
   if catFlg == true:
    valcut1 = replace(catline, re"=.*", "")
    removePrefix(valcut1, "PKGCAT_") #strutils
    removeSuffix(valcut1, "_Sub") #ex: Personal_Sub
    valcut2 = replace(valcut1, "_", ";")
    add(pupline, valcut2)
    break
  newcat = ""
  if catFlg == false:
   asection = debarray["Section:"]
   if asection == "games": newcat = "Fun"
   elif asection == "science": newcat = "Personal;education"
   elif asection == "doc": newcat = "Help"
   elif asection == "admin": newcat = "Setup"
   elif asection == "vcs": newcat = "Utility;development"
   elif asection == "devel": newcat = "Utility;development"
   elif asection == "editors": newcat = "Document;edit"
   elif asection == "math": newcat = "Business"
   elif asection == "web": newcat = "Internet"
   elif asection == "net": newcat = "Network"
   elif asection == "graphics": newcat = "Graphic"
   elif asection == "gnome": newcat = "Business"
   elif asection == "video": newcat = "Multimedia;video"
   elif asection == "sound": newcat = "Multimedia;sound"
   if newcat != "": catFlg = true
   if catFlg == true:
    add(pupline, newcat)
  if catFlg == false:
   add(pupline, "BuildingBlock")
  add(pupline, "|")
  
  add(pupline, debarray["Installed-Size:"])
  add(pupline, "K|")
  #ex: Filename: pool/main/a/abiword/gir1.2-abi-3.0_3.0.5~dfsg-1_amd64.deb
  valcut1 = parentDir(debarray["Filename:"]) #os module
  add(pupline, valcut1) #ex: pool/main/a/abiword
  add(pupline, "|")
  valcut1 = extractFilename(debarray["Filename:"]) #os module
  add(pupline, valcut1) #ex: abiword_3.0.5~dfsg-1_amd64.deb
  add(pupline, "|")
  
  #now for the dependencies...
  #there is one pkg with 208 deps ...ridiculous. set limit of 32
  cntdeps = 0
  pupdeps = ""
  prevdep = ""
  currdep = ""
  for adep0 in split(debarray["Depends:"], ", "):
   #ex: abiword-common (>= 3.0.5~dfsg-1)
   #there may be an or operator:
   #ex: fonts-dejavu-core | ttf-dejavu-core
   adep = adep0 #because adep0 is immutable.
   if contains(adep, " | "):
    #this is a bad hack, chop off the alternative dep...
    adep = replace(adep0, re" \| .*", "")
   cnt1 = 0
   for apart1 in split(adep," ("):
    if cnt1 == 0:
     #ex: abiword-common
     depcut1 = replace(apart1, re":.*", "") #ex: python3:any
     prevdep = currdep
     currdep = depcut1
     if prevdep == currdep:
      #handle chained deps. ex: 0ad-data (>= 0.0.23.1), 0ad-data (<= 0.0.23.1-5),
      # we want: +0ad-data&ge0.0.23.1&le0.0.23.1-5
      prevdep = ""
      currdep = ""
      #pupdeps has "," on the end. need to remove it, as want to append the second version condition...
      if endsWith(pupdeps, ","): removeSuffix(pupdeps, ',')
      cnt1 = 1
      continue
     add(pupdeps, "+")
     add(pupdeps, depcut1)
     cntdeps = cntdeps + 1
     if cntdeps >= 96: break #abandon this pkg, too many deps. unfortunately, nim does not support "continue <number>"
     # ...oh man, had to go up to 96 to keep 'vlc-plugin-base'
    else:
     #ex: >= 3.0.5~dfsg-1)
     cnt2 = 0
     for apart2 in split(apart1, ' '):
      if cnt2 == 0:
       #ex: >=
       if apart2 == ">=": comp1 = "&ge"
       elif apart2 == ">>": comp1 = "&gt"
       elif apart2 == "<=": comp1 = "&le"
       elif apart2 == "<<": comp1 = "&lt"
       elif apart2 == "=": comp1 = "&eq"
       else: continue
       add(pupdeps, comp1)
      else:
       #ex: 3.0.5~dfsg-1)
       depcut0 = replace(apart2, re"\)$", "")
       depcut1 = replace(depcut0, re"^[0-9]:", "")
       depcut2 = replace(depcut1, re"[+~.-]*[a-z][a-z][a-z].*", "")
       removeSuffix(depcut2, '~')
       add(pupdeps, depcut2)
      cnt2 = cnt2 + 1
    cnt1 = cnt1 + 1
   add(pupdeps, ',')
   if cntdeps >= 96: break #abandon this pkg, too many deps. unfortunately, nim does not support "continue <number>"
  if cntdeps >= 96:  #abandon this pkg, too many deps. unfortunately, nim does not support "continue <number>"
   #echo debarray["Package:"] #TEST
   wipe_para_proc()
   continue
  removeSuffix(pupdeps, ',')
  removeSuffix(pupdeps, '+')
  add(pupline, pupdeps)
  add(pupline, "|")
  
  #remove some chars from the description...
  valcut1 = replace(debarray["Description:"], re"[\(\)\|\>\<]", "")
  add(pupline, valcut1) #ex: efficient, featureful word processor with collaboration
  add(pupline, "|")
  add(pupline, compatdistro) #ex: debian
  add(pupline, "|")
  add(pupline, compatversion) #ex: bookworm
  add(pupline, "|")
  
  #sha256...
  add(pupline, debarray["MD5sum:"])
  add(pupline, "||")
  
  ###write to file###
  writeLine(pupdbfile, pupline) #io module
  
  #accumulate homepage urls...
  if debarray["Homepage:"] != "":
   homepage = debarray["Package:"] #ex: abiword
   if not endsWith(homepage, "-dev"): #strutils
    if not endsWith(homepage, "-doc"):
     if not endsWith(homepage, "-libs"):
      if not endsWith(homepage, "-common"):
       add(homepage, " ")
       add(homepage, debarray["Homepage:"])
       writeLine(homepagesfile, homepage) #io module
  
  #wipe paragraph...
  wipe_para_proc()
  continue
  #END OF PROCESSING A PKG
  
 #write each line to the associative-array...
 #ignore line with space first char...
 if continuesWith(oneline, " ", 0): continue #strutils
 akey = replace(oneline, re": .*", ":")
 aval = replace(oneline, re"^[^:]*: ", "")
 debarray[akey] = aval

flushFile(homepagesfile) #io module.
flushFile(pupdbfile)
close(homepagesfile)
close(debdbfile)
close(pupdbfile)
close(catfile)

