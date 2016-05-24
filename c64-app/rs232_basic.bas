0 rem !to "build/ms.prg"

poke 198,0: wait 198,1

rem (THIS MUST BE AT THE TOP OF THE FILE - `OPEN` CLEARS ALL BASIC VARIABLES)
rem Open RS-232 device at 300 baud, default parity, stop bits, 8 bits per char
open 3, 2, 0, chr$(6)

buf$ = ""
cr = 55296
sid = 54272
hb = 0
pp$ = "Accenture, Deloitte Digital, PwC, Cognizant, SalesForce, Appnovation, "
pp$ = pp$ + "AvenueCode, Capgemini, ModusBox.  "
po% = 0
rem Disable interrupts from serial port (sort-of)
di% = 0

sa% = 0
sx% = 0
sk% = 0 : rem skip loading screen?

poke 53272,23  : rem use lowercase char set
gosub 5000
print "Loading..."
print
print "Opening serial port device..."


rem skip logo screen?
if sk% = 0 then gosub 11000 : rem logo screen
if sk% = 1 then gosub 4000

rem gosub 15000

goto 6500


4000: rem Setup info screen
  gosub 5000
  rem Setup top line
  poke 781,0:poke 782,4:poke 783,0:sys 65520
  print "MuleSoft San Francisco (c) 1985"
  poke 781,1:poke 782,0:poke 783,0:sys 65520
  print chr$(155);
  for x = 0 to 39
    print chr$(163);
  next x

  rem Setup onsite interview section
  poke 781, 3 : poke 782, 0 : poke 783, 0 : sys 65520
  print chr$(30) + "Welcome to Connect"

  rem Setup twitter section
  poke 781, 7 : poke 782, 0 : poke 783, 0 : sys 65520
  print chr$(30) + "Latest from Twitter"
  print chr$(5) + "...Waiting for data..."

  rem Setup weather section
  poke 781, 16 : poke 782, 0 : poke 783, 0 : sys 65520
  print chr$(30) + "Current weather"
  print chr$(5) + "...Waiting for data..."

  rem Setup next session section
  poke 781, 19 : poke 782, 0 : poke 783, 0 : sys 65520
  print chr$(30) + "Next session"
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
  if right$(buf$, 1) = chr$(126) then gosub 7000 : rem tilde char
  rem get inp$
  rem if inp$ = " " then gosub 11000

  gosub 16000 : rem move sprite
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
  if cm$ = "4" then found%=1 : rem gosub 11000
  if cm$ = "5" then found%=1 : gosub 12000
  if cm$ = "6" then found%=1 : gosub 13000
  if cm$ = "7" then found%=1 : gosub 14000
  if cm$ = "8" then found%=1 : gosub 17000
  rem if found% = 0 then print "unknown command", cm$: print buf$
  buf$ = ""
  return

8000: rem twitter
  poke 781, 8 : poke 782, 0 : poke 783, 0 : sys 65520
  nb$ = ""
  for x = 0 to 250
    nb$ = nb$ + " "
  next x
  print chr$(5) + nb$ : rem clear twitter area
  poke 781, 8 : poke 782, 0 : poke 783, 0 : sys 65520
  print buf$
  rem easter egg - tweet PLAY 29,54,23... to play a sound
  rem not sure why but we need to manually specifiy the byte numbers..
  tst$ = "@muleadore64: " + chr$(112) + chr$(108) + chr$(97) + chr$(121)
  if left$(buf$, 18) = tst$ then buf$ = mid$(buf$, 20) : gosub 12500
  return


9000: rem background border
  v = val(buf$)
  poke 53280, v
  return

10000: rem background color
  v = val(buf$)
  poke 53281, v
  return

11000: rem attract screen
  di% = 1
  gosub 5000
  poke 781,7:poke 782,0:poke 783,0:sys 65520

  print "In 1982, the most common thing to"
  print 
  print "connect a Commodore64 to were beige"
  print 
  print "tape drives, joysticks and CRT tvs..."

  poke 198,0: wait 198,1

  print
  print
  print
  print "Today, MuleSoft technology is"
  print
  print "connecting everything, even this"
  print
  print "poor Commodore64"
  poke 198,0: wait 198,1
  gosub 5000

  rem skip over audio + sprite data
  restore
  for x = 0 to 15 + (63 * 8)
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
  print "   ( Powered by " + chr$(154) + "MuleSoft" + chr$(5) + " )"
  gosub 12000
  gosub 15000 : rem setup sprites
  poke 198,0: wait 198,1
  di% = 0
  gosub 4000
  return

12000: rem play sound
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

12500: rem play custom sound
  for l = 54272 to 54296
    poke l,0
  next
  poke 54296,15
  
  b2$ = ""
  dim nt%(20)
  ni% = 1
  for x = 1 to len(buf$)
    c$ = mid$(buf$, x, 1)
    if c$ <> "," then b2$ = b2$ + mid$(buf$, x, 1)
    if c$ = "," then nt%(ni%) = val(b2$) : b2$ = "" : ni% = ni% + 1
  next
  nt%(ni%) = val(b2$)
  for x = 1 to ni%
    poke 54273, nt%(x): poke 54272, nt%(x)
    poke 54277,136
    poke 54278,143
    poke 54276,17
    for n = 1 to 300: next n
    poke 54276,16
  next x
  poke 54296,0
  return

13000: rem heartbeat
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
  poke 781,4:poke 782,0:poke 783,0:sys 65520
  print chr$(5) + mid$(pp$, po%, ln%);
  if ov% > 0 then print left$(pp$, 40 - ln%)
  return

14000: rem weather
  poke 781, 17 : poke 782, 0 : poke 783, 0 : sys 65520
  nb$ = ""
  for x = 0 to 40
    nb$ = nb$ + " "
  next x
  print chr$(5) + nb$ : rem clear area
  poke 781, 17 : poke 782, 0 : poke 783, 0 : sys 65520
  print buf$
  return

15000: rem setup sprite0
  rem skip over audio data
  restore
  for x = 0 to 15
    read a%
  next x

  rem set sprite pointer

  for j = 180 to 187
    for i=0 to 62:read a:poke 64*j+i,a:next i
    print ".";
  next j

  rem color
  poke 53287,1

  rem enabled
  poke 53269,1

  rem position
  poke 53248,60
  poke 53249,230
  rem position extra bits
  poke 53264,0
  poke 2040, 220
  return

16000: rem do sprite moving, animation
  sx% = sx% - 1
  if sx% < 0 then sx% = 320 : poke 53287, int(rnd(1)*15)+1
  if sx% < 255 then poke 53264, 0 : poke 53248,sx%
  if sx% > 255 then poke 53264, 1 : poke 53248,sx% - 255
  sa% = sa% + 1
  if sa% > 7 then sa% = 0
  poke 2040, 180 + sa%
  return

17000: rem next session
  poke 781, 20 : poke 782, 0 : poke 783, 0 : sys 65520
  nb$ = ""
  for x = 0 to 40
    nb$ = nb$ + " "
  next x
  print chr$(5) + nb$ : rem clear area
  poke 781, 20 : poke 782, 0 : poke 783, 0 : sys 65520
  print buf$
  return


rem ====================== DATA AREA ============================


rem audio
data 32,32,40,150,54,54,48,68
data 42,192,36,36,32,29,0,0

rem sprite0-0
data 32,0,0
data 80,0,0
data 60,0,0
data 63,0,0
data 63,128,0
data 63,225,240
data 127,255,248
data 119,255,252
data 35,255,252
data 3,255,252
data 3,255,250
data 1,255,122
data 1,192,58
data 1,192,58
data 1,192,26
data 1,192,31
data 1,128,28
data 1,128,20
data 1,128,18
data 0,192,50
data 0,128,2

rem sprite0-1
data 32,0,0
data 80,0,0
data 60,0,0
data 63,0,0
data 63,128,0
data 63,225,240
data 127,255,248
data 119,255,252
data 35,255,252
data 3,255,252
data 3,255,250
data 1,255,122
data 1,192,58
data 3,192,58
data 3,192,26
data 3,192,31
data 3,128,60
data 1,128,36
data 0,192,34
data 0,128,98
data 0,128,2

rem sprite0-2
data 32,0,0
data 80,0,0
data 60,0,0
data 63,0,0
data 63,192,0
data 63,225,224
data 127,255,248
data 119,255,252
data 35,255,252
data 3,255,252
data 3,255,250
data 1,255,122
data 1,192,58
data 3,192,58
data 3,192,122
data 6,192,127
data 6,128,124
data 3,128,100
data 1,128,66
data 1,128,66
data 0,128,194

rem sprite0-3
data 32,0,0
data 80,0,0
data 60,0,0
data 63,0,0
data 63,192,0
data 63,225,224
data 127,255,248
data 119,255,252
data 35,255,252
data 3,255,252
data 3,255,254
data 3,255,122
data 3,192,58
data 2,192,58
data 6,192,122
data 12,192,127
data 12,128,108
data 6,128,100
data 2,128,66
data 2,128,66
data 0,128,194

rem sprite0-4
data 0,0,0
data 0,0,0
data 80,0,0
data 80,0,0
data 127,192,0
data 63,225,224
data 63,255,248
data 63,255,252
data 63,255,252
data 55,255,252
data 51,255,254
data 3,255,126
data 3,192,58
data 2,192,58
data 6,192,123
data 4,192,125
data 4,128,108
data 4,128,100
data 4,128,68
data 4,128,76
data 4,128,192

rem sprite0-5
data 0,0,0
data 0,0,0
data 80,0,0
data 80,0,0
data 127,192,0
data 63,225,240
data 63,255,248
data 63,255,252
data 63,255,252
data 55,255,252
data 51,255,254
data 3,255,126
data 3,224,58
data 3,96,59
data 3,96,57
data 2,96,61
data 2,64,62
data 2,64,54
data 2,64,36
data 2,64,44
data 2,64,96

rem sprite0-6
data 0,0,0
data 0,0,0
data 80,0,0
data 80,0,0
data 127,192,0
data 63,225,240
data 63,255,248
data 63,255,252
data 63,255,252
data 55,255,252
data 51,255,254
data 3,255,126
data 3,128,58
data 3,192,58
data 3,192,59
data 2,192,60
data 2,192,60
data 2,128,60
data 2,128,28
data 2,192,24
data 2,0,48

rem sprite0-7
data 0,0,0
data 0,0,0
data 80,0,0
data 80,0,0
data 127,192,0
data 63,225,240
data 63,255,248
data 63,255,252
data 63,255,252
data 55,255,252
data 51,255,254
data 3,255,126
data 1,128,58
data 1,128,58
data 1,128,27
data 1,128,24
data 1,128,24
data 1,0,24
data 1,0,24
data 1,128,8
data 1,0,24

rem mulesoft image
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,222,222,222,222,222,222,222
data 222,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,222,222,222,32,32,32,32,32,32
data 222,222,222,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,222,222,32,32,32,32,32,32,32,32
data 32,32,222,222,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,222,222,32,32,32,32,32,32,32,32,32
data 32,32,32,32,222,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,222,222,32,32,222,32,32,32,32,32,32,32
data 32,222,32,32,222,222,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,222,32,32,222,222,222,32,32,32,32,32,32
data 222,222,222,32,32,222,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,222,32,32,222,222,222,222,222,32,32,32,32,222
data 222,222,222,222,32,222,222,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,222,32,32,222,222,222,222,222,222,32,32,222,222
data 222,222,222,222,32,32,222,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,222,32,32,222,222,32,222,222,222,32,32,222,222
data 222,32,222,222,32,32,222,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,222,32,222,222,222,32,32,222,222,222,222,222,222
data 32,32,222,222,222,32,222,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,222,32,32,222,222,32,32,32,222,222,222,222,32
data 32,32,222,222,32,32,222,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,222,32,32,222,222,32,32,32,32,222,222,32,32
data 32,222,222,222,32,32,222,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,222,32,32,222,222,222,32,32,32,32,32,32,32
data 32,222,222,222,32,222,222,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,222,32,32,222,222,222,32,32,32,32,32,32
data 222,222,222,32,32,222,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,222,222,32,32,222,222,32,32,32,32,32,32
data 222,222,32,32,222,222,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,222,222,32,32,222,32,32,32,32,32,32
data 222,32,32,32,222,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,222,222,32,32,32,32,32,32,32,32
data 32,32,222,222,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,222,222,222,32,32,32,32,32,32
data 222,222,222,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,222,222,222,222,222,222,222
data 222,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32