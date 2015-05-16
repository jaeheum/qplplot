/ often used utils
PI:M_PI:4*atan[1]   / π:4*atan[1] someday?
bor:{0b sv (0b vs x) | (0b vs y)}

/ namespace for qplplot: pl.*
pl:(`qplplot 2:(`plplot;1))`

/ pl.col0 input colors mentioned in plcol0(1) page, not #DEFINE'd in plplot.h nor set in plopts.q
pl:pl,(`black`red`yellow`green`aquamarine`pink`wheat`grey`brown`blue`BlueViolet`cyan`turquoise`magenta`salmon`white)!`int$(til 16)
/ #DEFINE'd in plplot.h, mentioned in man pages
\l plopts.q
