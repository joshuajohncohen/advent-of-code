import strutils, strformat, sequtils, math
import times

const batteryBanks =
  readFile("3.txt").splitLines.filterIt(it.len > 0).mapIt(it.toSeq.mapIt(parseInt($it)))
  # Read file, remove empty lines, and make each line a seq[int]

proc joltage(bank: openArray[int], numBatts: int = 2): int =
  ## Calculates Joltage

  var indexes = newSeq[(int, int)](numBatts)

  for n in 0 ..< numBatts:
    let indexN =
      bank[(if n == 0: 0 else: indexes[n - 1][0] + 1) .. ^(numBatts - n)].maxIndex +
      (if n == 0: 0 else: indexes[n - 1][0] + 1)
    indexes[n] = (indexN, bank[indexN])
  return parseInt(indexes.mapIt($it[1]).join(""))

let solutionOne = batteryBanks.mapIt(it.joltage(2)).sum
let solutionTwo = batteryBanks.mapIt(it.joltage(12)).sum
echo fmt"Part One: {solutionOne}"
echo fmt"Part Two: {solutionTwo}"

block timing: # Timing how fast it is
  var runTimes = newSeq[float](100_000)
  for i in 0 ..< 100_000:
    let time = cpuTime()
    let solutionOne = batteryBanks.mapIt(it.joltage(2)).sum
    let solutionTwo = batteryBanks.mapIt(it.joltage(12)).sum
    runTimes[i] = cpuTime() - time

  echo fmt"Average Time: {runTimes.sum / 100_000 * 1_000_000}µs"
