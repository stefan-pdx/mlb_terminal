# MLB Terminal

Access to MLB baseball scores in the terminal.

## Overview

Don't you just wish you could have a little terminal app to stream out real-time stats for a MLB baseball game? Look no further!

### Syntax

#### Commands

* help: Display global or [command] help documentation.
* games: Print out a list of scheduled games for the specified date
* game: Print out play-by-play events for a specific game. Use `--pitches` to output realtime pitch trajectory data.

#### Global options

* -h, --help: Display help documentation

* -v, --version: Display version information

* -t, --trace: Display backtrace when an error occurs

### Examples

    > # List todays games
    > mlb games
    0   Red Sox (69-88) @ Orioles (90-67)      7:05 ET (F)   1-9
    1   Reds (95-62) @ Pirates (76-81)         7:05 ET (F)   1-0
    2   Royals (70-87) @ Indians (66-91)       7:05 ET (F)   5-8
    3   Yankees (91-66) @ Blue Jays (69-88)    7:07 ET (F)   11-4
    4   Phillies (78-79) @ Marlins (67-90)     7:10 ET (F)   1-2
    5   Mets (73-84) @ Braves (91-66)          7:35 ET (F)   3-1
    6   Angels (87-70) @ Rangers (92-65)       8:05 ET (F)   7-4
    7   Tigers (84-73) @ Twins (66-91)         8:10 ET (F)   2-4
    8   Astros (52-105) @ Brewers (80-77)      8:10 ET (F)   7-6
    9   Rays (86-71) @ White Sox (83-74)       8:10 ET (F)   1-3
    10  Nationals (95-62) @ Cardinals (85-72)  8:15 ET (F)   2-12
    11  Cubs (59-98) @ D-backs (79-78)         9:40 ET (F)   3-8
    12  Mariners (73-84) @ Athletics (89-68)   10:05 ET (F)  2-8
    13  Giants (92-65) @ Padres (74-83)        10:05 ET (F)  3-1
    14  Rockies (62-95) @ Dodgers (82-75)      10:10 ET (F)  0-8

    # How did the Nationals do on 5/30/2012?
    > mlb games --date 2012-05-30 | grep -i nationals | cut -f 2,4
    Nationals (29-21) @ Marlins (29-22) 3-5

    > # How did Bryce Harper do tonight?
    > mlb games | grep Nationals | cut -f 1 | xargs mlb game | grep Harper
    2012-09-29 19:18:00  1  2   1/2/1  Bryce Harper singles on a soft line drive to center fielder Jon Jay.
    2012-09-29 19:20:11  1  3   1/2/1  Ryan Zimmerman doubles (36) on a fly ball to left fielder Matt Holliday.   Bryce Harper to 3rd.
    2012-09-29 19:26:56  1  5   0/0/1  Play reviewed and overturned: Michael Morse hits a grand slam (17) to right field.   Bryce Harper scores.    Ryan Zimmerman scores.    Adam LaRoche scores.
    2012-09-29 19:48:35  2  14  3/2/3  Bryce Harper grounds out, second baseman Skip Schumaker to first baseman Allen Craig.
    2012-09-29 19:56:08  2  17  3/2/2  Carlos Beltran lines out to center fielder Bryce Harper.
    2012-09-29 20:09:19  3  23  3/2/1  Pete Kozma flies out to center fielder Bryce Harper.
    2012-09-29 20:38:38  5  36  3/3/1  Bryce Harper called out on strikes.
    2012-09-29 21:15:16  7  51  2/2/1  Bryce Harper singles on a line drive to left fielder Matt Holliday.
    2012-09-29 21:19:08  7  53  1/1/2  Adam LaRoche singles on a sharp line drive to first baseman Allen Craig.   Bryce Harper to 3rd.
    2012-09-29 21:24:34  7  55  0/1/1  Yadier Molina flies out to center fielder Bryce Harper.
    2012-09-29 21:37:46  7  61  1/2/2  Matt Carpenter flies out to center fielder Bryce Harper.
    2012-09-29 22:10:49  9  71  1/0/2  Bryce Harper doubles (25) on a line drive to left fielder Matt Holliday.
    2012-09-29 22:21:20  9  76  0/0/2  Jon Jay out on a sacrifice fly to center fielder Bryce Harper.   Pete Kozma scores.

    > # Visualize pitch speed for Gio Gonzalez on his full game on August 8, 2012.
    > mlb games --date 2012-08-08                              \
        | grep Nationals                                       \
        | cut -f 1                                             \
        | xargs mlb game --pitches --date 2012-08-08           \
        | awk 'BEGIN{FS="\t"}{ if ($4=="Gio Gonzalez") print}' \
        | cut -f 1,9,6                                         \
        | Rscript -e 'library(ggplot2); library(scales); d <- read.csv("stdin", header=F, sep="\\t", col.names=c("time", "type", "pitch_speed")); png("gio-pitch-speed.png"); ggplot(d, aes(x=as.POSIXct(time), y=pitch_speed, colour=type, shape=type)) + geom_point() + opts(title="Pitch Speed Over Time for Gio Gonzalez") + scale_x_datetime(breaks=date_breaks("1 hour"), minor_breaks=date_breaks("15 min"), labels=date_format("%H:%M")) + scale_colour_discrete(name = "Pitch Type") + scale_shape_discrete(name = "Pitch Type") + xlab("Time") + ylab("Pitch Speed"); dev.off()'
    > open gio-pitch-speed.png
![gio-pitch-speed.png](http://i.imgur.com/WFw3J.png)
