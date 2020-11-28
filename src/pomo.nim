import strutils, chronos

const minute = 1000
const pause = 5 * minute
const work = 15 * minute

const workMessage: string = "25 minutes of concentrated work\a\a\a\a\a"
const pauseMessage: string = "5 minutes of recreation\a\a\a"

proc race[T](f1: Future[T], f2: Future[T]): Future[T] {. async .} =
    while not(f1.finished() or f2.finished()):
        poll()
    if not(f1.finished):
        let res = f2.read().value
        f1.cancel[T]()
        return f2
    else:
        let res = f1.read().value
        f2.cancel[T]()
        return f1

proc race(f1: Future[void], f2: Future[void]): Future[void] {. async .} =
  while not(f1.finished() or f2.finished()):
    poll()
  if not(f1.finished):
    f1.cancel()
    yield f2
  else:
    f2.cancel()
    yield f1

proc keyboardInterrupt() : Future[void] {. async .} =
    let rl = stdin.readLine()
    echo rl

proc sleepScream(message: string, duration: int) : Future[void] {. async .}=
    echo message
    yield race(sleepAsync(duration.milliseconds), keyboardInterrupt())

proc main(): void =
  while true:
    waitFor sleepScream(workMessage, work)
    waitFor sleepScream(pauseMessage, pause)

main()
