# MLB Terminal

Access to MLB baseball scores in the terminal.

## Overview

Don't you just wish you could have a little terminal app to stream out real-time stats for a MLB baseball game? Look no further!

### Syntax

#### Commands
        
* help: Display global or [command] help documentation.                
* list: Print out a list of scheduled games for the specified date   

#### Global options
        
* -h, --help: Display help documentation
        
* -v, --version: Display version information
        
* -t, --trace: Display backtrace when an error occurs

### Examples

    > # List todays games
    > mlb list
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

    # How did the Nationals do on May 30th of this year?
    > mlb list --date 2012-05-30 | grep -i nationals | cut -f 2,4
    Nationals (29-21) @ Marlins (29-22)     3-5
