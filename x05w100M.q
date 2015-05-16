\l qplplot.q
-1 "Creating 100M data points takes about 5 seconds,";
-1 "but plotting its histogram 500ms on Sandy Bridge";
NPTS:100*1000*1000 // 100M floats
PI:4*atan 1
delta:2*PI%NPTS
\ts data:sin[delta*til NPTS] // ~5000 ms on i7 2.9GHz, ~3GB (~2G can be GC'ed later)
pl.sdev`xwin
pl.init[]
pl.col0[pl`red]
\ts pl.hist[count data; data; -1.1; 1.1; 440; 0] // ~500 ms + 1200 bytes
pl.col0[pl`yellow]
pl.lab[`$"#frValue"; `$"#frFrequency"; `$"#frPLplot Example 5 - Probability function of Oscillator"]
pl.end[]
\\
// $Id: x05c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Histogram demo.
//
