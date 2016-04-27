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

  #filePrefix = 'Tight-logo'
  filePrefix = 'tight-clean-logo'

  r=png.Reader(filename='./' + filePrefix + '.png')
  imageTuple = r.read()
  print(imageTuple)
  l = list(imageTuple[2])
  #print(l[100])

  outFile = open("./" + filePrefix + ".txt", "a")

  colorCount = {}
  for lineArray in l:
    print(lineArray)
    counter = 0
    #lineString = ""
    lineString = "data "
    pixelPos = 0
    while pixelPos < len(lineArray):
    #for pixel in lineArray:
      ele1 = lineArray[pixelPos]
      ele2 = lineArray[pixelPos + 1]
      ele3 = lineArray[pixelPos + 2]
      ele4 = lineArray[pixelPos + 3]
      pixel = ele1 + ele2 + ele3 + ele4
      pixelPos = pixelPos + 4
      counter = counter + 1
      if pixel == 765:
        lineString = lineString + "32"
        #lineString = lineString + "  "
      else:
        lineString = lineString + "35"
        #lineString = lineString + "1"
      #print(type(pixel))
      if pixel in colorCount:
        colorCount[pixel] = colorCount[pixel] + 1
      else:
        colorCount[pixel] = 1

      if len(lineString) > 70:
        finishLine()
      elif pixelPos < len(lineArray):
        lineString = lineString + ","

    #outFile.write(lineString + "13\n")
    outFile.write(lineString + "\n")
    print("pixels: %d" %counter)
    #outFile.write(lineString + "\n")


  print(colorCount)


  outFile.close()
  
