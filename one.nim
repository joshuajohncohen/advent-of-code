import strformat, sequtils, strutils

var input = readFile("1.txt").splitLines.filterIt(it.len > 0)
  # because of the blank line at the end of the file

var password_part1 = 0
var password_part2 = 0

var dial = 50

for line in input:
  var direction = if line[0] == 'L': 1 else: -1
  var number = line[1 .. ^1].parseInt

  for _ in 1 .. number:
    # this is scuffed but i'm just turning the dial one by one to check when it's 0
    dial += direction

    dial = dial mod 100

    if dial == 0:
      password_part2 += 1 # is the dial passing 0 ever?

  if dial == 0:
    password_part1 += 1 # is the dial passing 0 after each turn?

echo fmt"Part 1: {password_part1}"
echo fmt"Part 2: {password_part2}"
