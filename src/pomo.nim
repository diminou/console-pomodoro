import strutils, chronos, threadpool
import times, std/monotimes, strformat, os

type PeriodType {. pure .} = enum WorkPer, PausePer

const minute = 1000
const pause = 5 * minute
const work = 15 * minute

const workMessage: string = "25 minutes of concentrated work\a\a\a\a\a"
const pauseMessage: string = "5 minutes of recreation\a\a\a"

proc baseTime(pert : PeriodType): int =
  case pert
  of WorkPer:
    return 25 * minute
  of PausePer:
    return 5 * minute

proc flip(pt: PeriodType): PeriodType =
  case pt
  of WorkPer :
    return PausePer
  of PausePer:
    return WorkPer

proc main(): void =
  var pomodoros = 0
  var period = WorkPer
  let startPer = getMonoTime()
  var finishPer = startPer + initDuration(milliseconds = baseTime(period))
  while true:
    stdout.write(fmt "\r{pomodoros} pomos, {period}")
    
    sleep(1000)

    let mt = getMonoTime()
    if finishPer < mt:
      if period == WorkPer:
        inc(pomodoros)
      period = flip(period)
      finishPer = mt + initDuration(milliseconds = baseTime(period))

main()
