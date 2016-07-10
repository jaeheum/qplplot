\l qplplot.q
-1 "Creating 1B data points takes about 25 seconds,";
-1 "but plotting its histogram 2500ms on Intel(R) Core(TM) i7-6800K CPU @ 3.40GHz";

NPTS:1000*1000*1000 // 1B floats
PI:4*atan 1
delta:2*PI%NPTS
\ts data:sin[delta*til NPTS]
/ 23199 25769804144
pl.sdev`xwin
pl.init[]
pl.col0[pl`red]
\ts pl.hist[count data; data; -1.1; 1.1; 440; 0] // ~500 ms + 1200 bytes
/ 2588 1504
pl.col0[pl`yellow]
pl.lab[`$"#frValue"; `$"#frFrequency"; `$"#frPLplot Example 5 - Probability function of Oscillator"]
pl.end[]
\\
// $Id: x05c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Histogram demo.
//
