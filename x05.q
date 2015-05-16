\l qplplot.q
NPTS:2047
PI:4*atan 1
delta:2*PI%NPTS
/pl.sdev`xwin
pl.init[]
data:sin[delta*til NPTS]
pl.col0[pl`red]
pl.hist[count data; data; -1.1; 1.1; 440; 0]
pl.col0[pl`yellow]
pl.lab[`$"#frValue"; `$"#frFrequency"; `$"#frPLplot Example 5 - Probability function of Oscillator"]
pl.end[]
\\
// $Id: x05c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Histogram demo.
//
