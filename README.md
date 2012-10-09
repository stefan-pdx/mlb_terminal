# MLB Terminal

Access to historical and real-time MLB baseball scores and stats in the terminal.

## Overview

Don't you just wish you could have a little terminal app to stream out real-time stats for a MLB baseball game? Look no further! _Please note, the use of this data is subjected to the terms put forth by the MLB. More information can be found here: [http://gdx.mlb.com/components/copyright.txt](http://gdx.mlb.com/components/copyright.txt). You're okay if you're using this data for individual use!_

Although there are several other gems out there that provide access to MLB Gamday data, `mlb_terminal` provides a one-stop shop for streaming data and piping it to other processes. For the true sports hacker in us all!

## Installation

To install MLB Terminal, please [install Ruby 1.9.3 and RubyGems](http://docs.cloudfoundry.com/frameworks/ruby/installing-ruby.html). Then install MLB Terminal via:

    gem install mlb_terminal

For more information regarding this gem, please visit the RubyGems page for [mlb_terminal](https://rubygems.org/gems/mlb_terminal).

## Syntax

Typical usage starts off by scanning the games for a specific date:

    > mlb games --date yesterday
    
    0  Athletics (0-2) @ Tigers (2-0)     12:00 ET (Final)  4-5
    1  Nationals (1-0) @ Cardinals (0-1)  3:00 ET (Final)   3-2
    2  Yankees (1-0) @ Orioles (0-1)      6:00 ET (Final)   7-2
    3  Reds (2-0) @ Giants (0-2)          9:30 ET (Final)   9-0

If the `--date` flag isn't used, all commands will assume today.

Then you can use the index in the first column to pull out additional data, such as game events, pitches and hits.

    > mlb game --date yesterday --pitches 1 | head | cut -f 1,4-6
    
    2012-10-07 15:08:11 -0400  Adam Wainwright  Jayson Werth    B
    2012-10-07 15:08:29 -0400  Adam Wainwright  Jayson Werth    S
    2012-10-07 15:08:53 -0400  Adam Wainwright  Jayson Werth    B
    2012-10-07 15:09:08 -0400  Adam Wainwright  Jayson Werth    S
    2012-10-07 15:09:53 -0400  Adam Wainwright  Jayson Werth    S
    2012-10-07 15:10:40 -0400  Adam Wainwright  Bryce Harper    X
    2012-10-07 15:10:55 -0400  Adam Wainwright  Ryan Zimmerman  S
    2012-10-07 15:11:13 -0400  Adam Wainwright  Ryan Zimmerman  B
    2012-10-07 15:11:33 -0400  Adam Wainwright  Ryan Zimmerman  S
    2012-10-07 15:12:16 -0400  Adam Wainwright  Ryan Zimmerman  S    

    > mlb game --date yesterday --hits 1 | head
    
    1  Top     Adam Wainwright  Bryce Harper    O  Groundout  140.56  163.65
    1  Bottom  Gio Gonzalez     Carlos Beltran  O  Groundout  140.56  162.65
    1  Bottom  Gio Gonzalez     Allen Craig     O  Flyout     128.51  82.33
    2  Top     Adam Wainwright  Ian Desmond     H  Single     134.54  87.35
    2  Top     Adam Wainwright  Kurt Suzuki     H  Single     87.35   132.53
    2  Top     Adam Wainwright  Jayson Werth    O  Groundout  111.45  164.66
    2  Bottom  Gio Gonzalez     David Freese    O  Flyout     125.5   47.19
    2  Bottom  Gio Gonzalez     Jon Jay         O  Flyout     73.29   108.43
    2  Bottom  Gio Gonzalez     Carlos Beltran  O  Flyout     145.58  71.29
    3  Top     Adam Wainwright  Ryan Zimmerman  H  Single     113.45  98.39
    
    > mlb game --date yesterday --pitches 1 | head
    
    2012-10-07  1  Top     1   2/3/1  Jayson Werth strikes out swinging.
    2012-10-07  1  Top     2   0/0/2  Bryce Harper grounds out, second baseman Daniel Descalso to first baseman Allen Craig.
    2012-10-07  1  Top     3   1/3/3  Ryan Zimmerman strikes out swinging.
    2012-10-07  1  Bottom  4   1/3/1  Jon Jay called out on strikes.
    2012-10-07  1  Bottom  5   2/1/2  Carlos Beltran grounds out, second baseman Danny Espinosa to first baseman Adam LaRoche.
    2012-10-07  1  Bottom  6   4/1/2  Matt Holliday walks.
    2012-10-07  1  Bottom  7   2/2/3  Allen Craig flies out to center fielder Bryce Harper.
    2012-10-07  2  Top     8   4/1/0  Adam LaRoche walks.
    2012-10-07  2  Top     9   0/3/1  Michael Morse strikes out swinging.
    2012-10-07  2  Top     10  0/1/1  Ian Desmond singles on a line drive to center fielder Jon Jay.  Adam LaRoche to 3rd.

### Commands

To find out more about a specific command, use `mlb [command] --help` to view the appropriate documentation.

* `help`: Display global or [command] help documentation.
* `games [options]`: Print out a list of scheduled games for the specified date
* `game [options] [game_number]`: Print out play-by-play events for a specific game. Use `--pitches` to output realtime pitch trajectory data.

### Global options

* -h, --help: Display help documentation

* -v, --version: Display version information

* -t, --trace: Display backtrace when an error occurs

## Data Output Format

Each command outputs data in tab-separated format. When outputting data for a game in progress, the application will continue to pipe in data as it is made available.

### `games` (Game listings)

1. Game index. A numbered value unique to the specified date that is referenced in the `game` command.
2. Opposing teams. A string containing: `<Away Team> (Wins - Losses) @ <Home Team> (Wins - Losses).
3. Starting time and status.
4. Current score.

### `game` (Game events)

1. Event time.
2. Inning.
3. Top or bottom of inning.
4. Event number.
5. Event description.

### `game --pitches` (Pitch events)

1. Pitch time.
2. Inning.
3. Top or bottom of inning.
4. Pitcher name.
5. Batter name.
6. Pitch type. (S-Strike, B-Ball, X-hit)
7. X (x). The horizontal location of the pitch as it crosses the home plate. Units: Old Gameday coordinate system
8. Y (y). The vertical location of the pitch as it crosses the home plate. Units: Old Gameday coordinate system
9. Start speed (start_speed). The initial speed of the pitch. Units: miles per hour
10. End speed (end_speed). The speed measured as it crosses the home plate. Units: miles per hour
11. Top of Strike Zone (sz_top). The distance from the ground to the top of the strike zone. Units: feet
12. Bottom of Strike Zone (sz_bot). The distance from the ground to the bottom of the strike zone. Units: feet
13. Horizontal movement (pfx_x). The horizontal movement of a pitch relative to a theoretical pitch thrown at the same speed with no spin-induced movement. Measured at 40 feet from the home plate. Units: inches
14. Vertical movement (pfx_z). The vertical movement of a pitch relative to a theoretical pitch thrown at the same speed with no spin-induced movement. Measured at 40 feet from the home plate. Units: inches
15. Horizontal pitch location at home plate (px). The horizontal location of the pitch as it crosses home plate from the perspective of the umpire. Units: feet
16. Vertical pitch location at home plate (pz). The height of the pitch as it crosses the front of home plate. Units: feet
17. Initial horizontal measurement for pitch (x0). Initial horizontal measurement of pitch as measured by PITCHf/x. Units: feet
18. Initial depth measurement for pitch (y0). Initial deptch measurement of pitch as measured by PITCHf/x. Note that this is fixed per stadium and typically located around 40-50 feet from home plate. Units: feet
19. Initial height measurement for pitch (z0). Initial height measurement of pitch as measured by PITCHf/x. Units: feet
20. Initial x velocity (vxo). Initial velocity in the horizontal direction at the initial point. Units: feet per second
21. Initial y velocity (vxo). Initial velocity in the depth-wise direction at the initial point. Units: feet per second
22. Initial z velocity (vxo). Initial velocity in the vertical direction at the initial point. Units: feet per second
23. Breaking point (break_y). The distance from the home plate in which the pitch achieved its greatest deviation from the straight line path between the release point and the front of home plate. Units: feet
24. Breaking angle (break_angle). The angle at which the pitch crossed the front of home plate as seen by the umpire. Units: degrees
25. Breaking length (break_length). The greatest distance between the pitch's trajectory and the straight path between release and home plate. Units: inches
26. Pitch type (pitch_type). Pitch type as classified by the PITCHf/x system.
  * FA = Fastball
  * FF = Four-seam fastball
  * FT = Two-seam fastball
  * FC = Fastball (cutter)
  * FS / SI / SF = Fastball (sinker, split-fingered)
  * SL = Slider
  * CH = Changeup
  * CB / CU = Curveball
  * KC = Knuckle-curve
  * KN = Knuckleball
  * EP = Eephus
  * UN / XX = Unidentified
  * PO / FO = Pitch out
27. Pitch type confidence (type_confidence). A rating corresponding to the liklihood of the pitch type classification.
28. Pitch zone (zone).
29. Nasty factor (nasty). A auto-generated factor that describes the difficulty in hitting the pitch.
30. Spin direction (spin_dir).
31. Spin rate (spin_rate).
32. Comments (cc).
33. Unknown (mt).

For more information regarding PITCHf/x tracjectory data, please visit [http://fastballs.wordpress.com/category/pitchfx-glossary/](http://fastballs.wordpress.com/category/pitchfx-glossary/).

### `game --hits` (Hit events)

You also have access to hit locations for each batter. However, the coordinate system that is used relies on a 250-by-250 pixel image where the corresponding scale depends on which stadium the hit was made at. See the examples of how hits can be plotted on a generic baseball field.

1. Inning.
2. Top or bottom of inning.
3. Pitcher.
4. Batter.
5. Hit / Out / Error.
6. Description of hit.
7. X-coordinate.
8. Y-coordinate.

Note that the y-coordinate for the hit is the pixel location from the top of the coordinate frame. See the LaRoche example of how to plot this data.


## Examples

List todays games:

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

How did the Nationals do on 5/30/2012?

    > mlb games --date 2012-05-30 | grep -i nationals | cut -f 2,4
    
    Nationals (29-21) @ Marlins (29-22) 3-5

How did Bryce Harper do tonight?

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

Visualize pitch speed for Gio Gonzalez on his full game on August 8, 2012.

    > mlb games --date 2012-08-08                              \
        | grep Nationals                                       \
        | cut -f 1                                             \
        | xargs mlb game --pitches --date 2012-08-08           \
        | awk 'BEGIN{FS="\t"}{ if ($4=="Gio Gonzalez") print}' \
        | cut -f 1,9,6                                         \
        | Rscript -e "
            library(ggplot2); \
            library(scales); \
            d <- read.csv('stdin', header=F, sep='\\\\t', col.names=c('time', 'type', 'pitch_speed')); \
            png('gio-pitch-speed.png'); \
            ggplot(d, aes(x=as.POSIXlt(time), y=pitch_speed, colour=type, shape=type)) \
              + geom_point() \
              + labs(title='Pitch Speed Over Time for Gio Gonzalez', x='Time', y='Pitch Speed') \
              + scale_x_datetime(breaks=date_breaks('1 hour'), minor_breaks=date_breaks('15 min'), labels=date_format('%H:%M')) \
              + scale_colour_discrete(name = 'Pitch Type') \
              + scale_shape_discrete(name = 'Pitch Type'); \
            dev.off()"
            
            
        
![gio-pitch-speed.png](http://i.imgur.com/WFw3J.png)

Get a breakdown of pitch types for Ross Detwiler in this season up until 9/30/2012.

    > mlb pitchers --date 2012-09-30 11 \
        | grep "Ross Detwiler" \
        | cut -f 2 \
        | xargs mlb pitcher --date 2012-09-30 11 \
        | cut -f 8,9 \
        | awk 'BEGIN{FS="\t"}{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' \
        | sort
    Changeup 172
    Four-seam Fastball 1136
    Sinker 838
    Slider 314

What is Adam LaRoche's last 30-day spray pattern compared to that of 60-90 days ago?

    > for DAY in `seq 1 30; seq 60 90`
      do
        mlb games --date "$DAY days ago"                 \
          | grep Nationals                               \
          | cut -f 1                                     \
          | xargs mlb game --date "$DAY days ago" --hits \
          | grep "Adam LaRoche"                          \
          | cut -f 5-8                                   \
          | awk -v day="$DAY" '
              BEGIN{FS='\t'; OFS='\t'}
              {
                if (day <= 30) printf("Day 1-30");
                else printf("Day 60-90");
                printf("\t%s\n",  $0)}'
      done \
          | Rscript -e " \
              library(ggplot2); \
              library(png); \
              library(gridExtra); \
              field_url <- 'http://i.imgur.com/0phAi.png'; \
              download.file(field_url, '/tmp/baseball-field.png', mode = 'wb'); \
              m <- readPNG('/tmp/baseball-field.png', FALSE); \
              w <- matrix(rgb(m[,,1],m[,,2],m[,,3], m[,,4] * 0.2), nrow=dim(m)[1]); \
              d <- read.csv('stdin', header=F, sep='\\\\t', col.names=c('time', 'type', 'desc', 'x', 'y')); \
              png('laroche-spray-chart.png', width=600, height=1200); \
              ggplot(d, aes(x, 250-y, shape=type, colour=type)) \
                + geom_point() \
                + annotation_custom(xmin=-Inf, ymin=-Inf, xmax=Inf, ymax=Inf, rasterGrob(w)) \
                + labs(title='Hit Locations For Adam LaRoche', x='', y='') \
                + scale_x_continuous(breaks=c(), limits = c(0,250)) \
                + scale_y_continuous(breaks=c(), limits = c(0,250)) \
                + theme(panel.grid.minor = element_blank(), \
                    panel.grid.minor = element_blank(), \
                    panel.background = element_blank(), \
                    axis.ticks = element_blank()) \
                + facet_grid(time ~ .); \
              dev.off();"

![laroach-spray-chart.png](http://i.imgur.com/Oiq9Q.png)