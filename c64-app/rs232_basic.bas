0 rem !to "build/hello_world.prg"

rem (THIS MUST BE AT THE TOP OF THE FILE - `OPEN` CLEARS ALL BASIC VARIABLES)
rem Open RS-232 device at 300 baud, default parity, stop bits, 8 bits per char
open 3, 2, 0, chr$(6)

buf$ = ""
cr = 55296
sid = 54272
hb = 0
pp$ = "Jeff, Steven, James, James2, Arvi, Someone, David, Greg, James.     "
po% = 0
rem Disable interrupts from serial port (sort-of)
di% = 0

rem audio
data 32,32,40,150,54,54,48,68
data 42,192,36,36,32,29,0,0
rem mulesoft image
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,35,35,35,35,35,35,35
data 35,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,35,35,35,32,32,32,32,32,32
data 35,35,35,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,35,35,32,32,32,32,32,32,32,32
data 32,32,35,35,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,35,35,32,32,32,32,32,32,32,32,32
data 32,32,32,32,35,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,35,35,32,32,35,32,32,32,32,32,32,32
data 32,35,32,32,35,35,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,35,32,32,35,35,35,32,32,32,32,32,32
data 35,35,35,32,32,35,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,35,32,32,35,35,35,35,35,32,32,32,32,35
data 35,35,35,35,32,35,35,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,35,32,32,35,35,35,35,35,35,32,32,35,35
data 35,35,35,35,32,32,35,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,35,32,32,35,35,32,35,35,35,32,32,35,35
data 35,32,35,35,32,32,35,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,35,32,35,35,35,32,32,35,35,35,35,35,35
data 32,32,35,35,35,32,35,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,35,32,32,35,35,32,32,32,35,35,35,35,32
data 32,32,35,35,32,32,35,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,35,32,32,35,35,32,32,32,32,35,35,32,32
data 32,35,35,35,32,32,35,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,35,32,32,35,35,35,32,32,32,32,32,32,32
data 32,35,35,35,32,35,35,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,35,32,32,35,35,35,32,32,32,32,32,32
data 35,35,35,32,32,35,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,35,35,32,32,35,35,32,32,32,32,32,32
data 35,35,32,32,35,35,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,35,35,32,32,35,32,32,32,32,32,32
data 35,32,32,32,35,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,35,35,32,32,32,32,32,32,32,32
data 32,32,35,35,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,35,35,35,32,32,32,32,32,32
data 35,35,35,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,35,35,35,35,35,35,35
data 35,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32

poke 53272,23  : rem use lowercase char set
gosub 5000
gosub 11000: rem logo screen
gosub 5000
gosub 4000
goto 6500


4000: rem Setup info screen
  rem Setup top line
  poke 781,0:poke 782,0:poke 783,0:sys 65520
  print "WELCOME TO " + chr$(154) + "MULESOFT!"
  poke 781,0:poke 782,30:poke 783,0:sys 65520
  print chr$(5) + "Anypoint"

  rem Setup onsite interview section
  poke 781, 4 : poke 782, 0 : poke 783, 0 : sys 65520
  print chr$(30) + "Welcome to our guests today"

  rem Setup twitter section
  poke 781, 9 : poke 782, 0 : poke 783, 0 : sys 65520
  print chr$(30) + "Latest from Twitter"
  print chr$(5) + "...Waiting for tweet data..."

  rem Setup weather section
  poke 781, 18 : poke 782, 0 : poke 783, 0 : sys 65520
  print chr$(30) + "Weather in SF"
  print chr$(5) + "...Waiting for data..."
  return

5000 : rem clear screen
  poke 53280, 0
  poke 53281, 0
  print chr$(147)
  print chr$(5)
  return

6500 : rem read from serial
  get# 3, inp$
  if st = 0 then buf$ = buf$ + inp$
  if right$(buf$, 1) = "z" then gosub 7000
  goto 6500
  close 3

7000: rem pick the command type
  rem print chr$(19) + "buf <<" + buf$ + ">>"
  if len(buf$) < 2 then buf$ = "" : return
  cm$ = mid$(buf$, 1, 1)
  if di% = 1 then cm$ = "disabled"
  buf$ = mid$(buf$, 2, len(buf$)-2)
  rem print "buf <<" + buf$ + ">>"
  found% = 0
  if cm$ = "1" then found%=1 : gosub 8000
  if cm$ = "2" then found%=1 : gosub 9000
  if cm$ = "3" then found%=1 : gosub 10000
  if cm$ = "4" then found%=1 : gosub 11000
  if cm$ = "5" then found%=1 : gosub 12000
  if cm$ = "6" then found%=1 : gosub 13000
  if cm$ = "7" then found%=1 : gosub 14000
  if found% = 0 then print "unknown command", cm$
  buf$ = ""
  return

8000: rem twitter
  poke 781, 10 : poke 782, 0 : poke 783, 0 : sys 65520
  nb$ = ""
  for x = 0 to 250
    nb$ = nb$ + " "
  next x
  print chr$(5) + nb$ : rem clear twitter area
  poke 781, 10 : poke 782, 0 : poke 783, 0 : sys 65520
  print buf$
  return


9000: rem background border
  rem print "b:" + buf$ + ":"
  v = val(buf$)
  poke 53280, v
  return

10000: rem background color
  rem print "b:" + buf$ + ":"
  v = val(buf$)
  poke 53281, v
  return

11000: rem attract screen
  di% = 1
  gosub 5000
  poke 781,10:poke 782,0:poke 783,0:sys 65520

  print "In 1982, the most common thing a"
  print "Commodore64 was connected to were beige keyboards and CRT tvs..."
  poke 198,0: wait 198,1

  print
  print
  print
  print "Today, Mulesoft technology is"
  print "connecting everything, including"
  print "this humble Commodore64"
  poke 198,0: wait 198,1
  gosub 5000

  rem skip over audio data
  restore
  for x = 0 to 15
    read a%
  next x

  poke 781,24:poke 782,0:poke 783,0:sys 65520
  print chr$(154) : rem switch to light blue
  ln$ = ""
  i% = 0
  for x = 0 to 800
    read a%
    i% = i% + 1
    ln$ = ln$ + chr$(a%)
    if i% = 40 then print ln$; : ln$ = "" : i% = 0
  next x
  print
  print
  print chr$(5)
  
  poke 781,23:poke 782,10:poke 783,0:sys 65520
  print "C64, welcome to 2016!";
  poke 781,24:poke 782,6:poke 783,0:sys 65520
  print "   ( Powered by " + chr$(154) + "Mulesoft" + chr$(5) + " )"
  gosub 12000
  poke 198,0: wait 198,1
  di% = 0
  return

12000: rem play beep
  restore
  for l = 54272 to 54296
    poke l,0
  next
  poke 54296,15
  read a,b
  if a=0 then for l = 54272 to 54296 : poke l,0 : return
  poke 54273, a: poke 54272, b
  poke 54277,136
  poke 54278,143
  poke 54276,17
  for n = 1 to 300: next n
  poke 54276,16
  goto 12012
  return

13000: rem 
  poke 781,0:poke 782,39:poke 783,0:sys 65520
  hb = not(hb)
  if hb = 0 then print " "
  if hb <> 0 then print chr$(153) + chr$(186)
  gosub 13500
  return

13500: rem scroll people
  po% = po% + 1
  if po% > len(pp$) then po% = 1
  ln% = len(pp$) - po%
  ov% = 0
  if ln% < 40 then ov% = 40 - ln%
  if ln% > 40 then ln% = 40
  poke 781,5:poke 782,0:poke 783,0:sys 65520
  print chr$(5) + mid$(pp$, po%, ln%);
  if ov% > 0 then print left$(pp$, 40 - ln%)
  return

14000: rem weather
  return



