import os


proc main(x: void): void =
    const minute: int = 1000
    const pause: int = 5 * minute
    const work: int = 25 * minute
    const workMessage: string = "25 minutes of concentrated work"
    const pauseMessage: string = "5 minutes of recreation"
    var pomodoros: int = 0
    while true:
        echo workMessage, '\007'
        sleep(work)
        pomodoros = pomodoros + 1
        echo "pomodoros: ", pomodoros
        echo pauseMessage, '\007'
        sleep(pause)

main()
