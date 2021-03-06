import strutils, threadpool
import times, std/monotimes, strformat, os

type PeriodType {. pure .} = enum WorkPer, PausePer

const minute = 1000 * 60
const pause = 5 
const work = 25 

const workBeep = "\a\a\a\a\a"
const pauseBeep = "\a\a"

const workMessage: string = fmt"{work} minutes of focused work{workBeep}"
const pauseMessage: string = fmt"{pause} minutes of recreation{pauseBeep}"

const wipe = "\r                                                                \r"

proc baseTime(pert : PeriodType): int =
  case pert
  of WorkPer:
    return work * minute
  of PausePer:
    return pause * minute

proc flip(pt: PeriodType): PeriodType =
  case pt
  of WorkPer :
    return PausePer
  of PausePer:
    return WorkPer

proc message(pt: PeriodType): string =
  case pt
  of WorkPer :
    return workMessage
  of PausePer:
    return pauseMessage

proc pomoInc(pt: PeriodType): int =
  case pt
  of WorkPer:
    return 1
  of PausePer:
    return 0

proc messageLine(pomos: int, remaining: int, msg: string): string =
  return fmt"pomos: {pomos}; {msg}; remaining: {remaining} s"

proc loop() : void {.thread.} =
  var perType = PausePer
  var endTime = getMonoTime()
  var pomodoros = 0
  while true:
    let nw = getMonoTime()
    let remaining = int((endTime.ticks - nw.ticks) div (int64 1_000_000_000)) 
    if nw >= endTime:
      pomodoros = pomoInc(perType) + pomodoros
      perType = flip(perType)
      endTime = nw + initDuration(milliseconds = baseTime perType)
    let msg = message perType
    stdout.write(wipe)
    stdout.write(messageLine(pomodoros, remaining, msg))
    stdout.flushFile()
    sleep(100)

proc main() : void =
  spawn loop()
  discard stdin.readLine()

main()
