import strutils, strformat, sequtils, math, tables
import malebolgia

let input = readFile("2.txt").splitLines[0]
  # Get first line of input
  .split(',')
  # Split into ranges
  .mapIt(it.split('-').map(parseInt))
  # Get bounding numbers of ranges
  .mapIt(toSeq(it[0] .. it[1])) # Generate full ranges and convert to strings

func flatten[T](nestedSeq: seq[seq[T]]): seq[T] =
  for nested in nestedSeq:
    for item in nested:
      result.add(item)

func isOneSilly(n: int): bool =
  let nStr = $n
  if nStr.len mod 2 == 0:
    let halfLen = nStr.len div 2
    return nStr[0 ..< halfLen] == nStr[halfLen ..^ 1]
  return false

proc checkRep(
    m: MasterHandle, nStr: string, nStrLen: int, possibleRep: int
) {.gcsafe.} =
  let firstSlice = nStr[0 ..< (nStrLen div possibleRep)]
  if nStr.count(firstSlice) == possibleRep:
    # The number of repetitions of the first slice of this size is the same as the number of slices, meaning they are all the same
    m.cancel()

var twoSillyCache = initTable[int, seq[int]]()

proc isTwoSilly(n: int): bool =
  let nStr = $n
  let nStrLen = nStr.len

  # Get possible repetitions
  var possibleReps: seq[int] = @[]
  if nStrLen notin twoSillyCache:
    for i in 2 .. (n div 2):
      if nStrLen mod i == 0:
        possibleReps.add i
    twoSillyCache[nStrLen] = possibleReps
  else:
    possibleReps = twoSillyCache[nStrLen]

  # Check repetitions
  var m = createMaster() # Create master for threading

  m.awaitAll:
    for possibleRep in possibleReps:
      m.spawn checkRep(m.getHandle, nStr, nStrLen, possibleRep)
  if m.cancelled():
    # If the threading stopped because it was cancelled, that means that a repetition was found
    return true
  return false

let flatInputs = input.flatten
let oneSillyInputs = flatInputs.filter(isOneSilly)
let twoSillyInputs = flatInputs.filter(isTwoSilly)
echo fmt"Solution one: {oneSillyInputs.sum}"
echo fmt"Solution two: {twoSillyInputs.sum}"
