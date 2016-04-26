#!/usr/bin/python

import sys

import png


# 35 non transparent
# 32 is transparent

def finishLine():
  global lineString
  global outFile
  
  outFile.write(lineString + "\n")
  lineString = "data "

if __name__ == "__main__":

  r=png.Reader(filename='./Mooshy-logo.png')
  imageTuple = r.read()
  print(imageTuple)
  l = list(imageTuple[2])
  #print(l[100])

  outFile = open("./Mooshy-logo.txt", "a")

  colorCount = {}
  for lineArray in l:
    lineString = "data "
    for pixel in lineArray:
      if pixel == 0:
        lineString = lineString + "32"
      else:
        lineString = lineString + "35"
      #print(type(pixel))
      if pixel in colorCount:
        colorCount[pixel] = colorCount[pixel] + 1
      else:
        colorCount[pixel] = 1

      if len(lineString) > 70:
        finishLine()
      else:
        lineString = lineString + ","

    outFile.write(lineString + "13\n")


  print(colorCount)


  outFile.close()
  
