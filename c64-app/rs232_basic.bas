0 rem !to "build/hello_world.prg"

buf$ = ""
cr = 55296
sid = 54272

data 31, 32, 32, 35, 35, 35, 35, 13
data 154, 32, 32, 32, 35, 35, 35, 13
data 31, 32, 32, 35, 32, 35, 35, 13
data 154, 32, 32, 35, 35, 32, 35, 13
data 31, 32, 32, 35, 35, 35, 35, 13

gosub 5000
print chr$(19) + "<CONNECTING TO ANYPOINT...>"

poke 53272,23  : rem lowercase
open 3, 2, 0, chr$(6)

print chr$(19) + "<CONNECTED TO ANYPOINT>    "

goto 6500


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
  rem print "buf <<" + buf$ + ">>"
  cm$ = mid$(buf$, 1, 1)
  buf$ = mid$(buf$, 2, len(buf$)-2)
  found% = 0
  if cm$ = "1" then found%=1 : gosub 8000
  if cm$ = "2" then found%=1 : gosub 9000
  if cm$ = "3" then found%=1 : gosub 10000
  if cm$ = "4" then found%=1 : gosub 11000
  if cm$ = "5" then found%=1 : gosub 12000
  if found% = 0 then print "unknown command", cm$
  buf$ = ""
  return

8000: rem twitter
  li %= 3
  poke 781, 6 : poke 782, 0 : poke 783, 0 : sys 65520
  print "Latest tweet to @muleadore64:"
  print 
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
  gosub 5000
  poke 781,10:poke 782,0:poke 783,0:sys 65520

  print "In 1982, the most common thing a"
  print "Commodore64 was connected to were beige keyboards and CRT tvs..."
  poke 198,0: wait 198,1

  print
  print
  print
  print "In 2016, Mulesoft technology is connecting everything, including this poor Commodore64"
  poke 198,0: wait 198,1
  gosub 5000

  print chr$(154) : rem switch to light blue
  for x = 0 to 39
    read a%
    print chr$(a%);
  next x
  print chr$(5)
  print 
  print "C64, welcome to 2016 with Mulesoft!"
  poke 198,0: wait 198,1
  return

12000: rem play beep
  for i = 0 to 28 : poke sid + i, 0 : next
  poke sid + 24, 15
  poke sid + 1, 20
  poke sid + 5, 0*16+0
  poke sid + 6, 15*16+9
  poke sid + 4, 1 + 16
  poke sid + 4, 16
  return

