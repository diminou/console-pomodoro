import strutils, chronos, threadpool

type EventType {. pure .} = enum Time, Interruption

const minute = 1000
const pause = 5 * minute
const work = 15 * minute

const workMessage: string = "25 minutes of concentrated work\a\a\a\a\a"
const pauseMessage: string = "5 minutes of recreation\a\a\a"

proc iterationLogic(): Future[void] {. async .} =
  var pomodoros = 0
  while true:
    echo workMessage, (work/1000)
    yield sleepAsync(work.milliseconds)
    echo pauseMessage, (pause/1000)
    yield sleepAsync(pause.milliseconds)

proc sidecarThread() : void {. thread .} =
  waitFor iterationLogic()

proc kinter(): Future[void] {. async .} =
  echo stdin.readLine()

proc main(): void =
  waitFor(wait(kinter(), 3000.milliseconds))

main()
