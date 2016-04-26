0 rem !to "build/hello_world.prg"

1 print chr$(147)
2 for n=0 to 24
3 print "These lines scroll...", n;
4 if n<24 then print
5 next n
6 for n=7 to 0 step -1
7 poke 53265,(peek(53265) and 240) or n
8 next n
9 goto 6