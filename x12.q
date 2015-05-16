// $Id: x12c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Bar chart demo.
//

//--------------------------------------------------------------------------
// main
//
// Does a simple bar chart, using color fill.  If color fill is
// unavailable, pattern fill is used instead (automatic).
//--------------------------------------------------------------------------

\l qplplot.q
//pl.sdev`xwin

pos:0.0 0.25 0.5 0.75 1.0;
red:0.0 0.25 0.5 1.0 1.0;
green:1.0 0.5 0.5 0.5 1.0;
blue:1.0 1.0 0.5 0.25 0.0;

fbox:{[x0;y0]
    x:(x0; x0; x0+1.; x0+1.);
    y:(0.; y0; y0; 0.);
    pl.fill[4; x; y];
    pl.col0[pl`red];
    pl.lsty[1];
    pl.line[4; x; y];}

pl.init[];

pl.adv[0];
pl.vsta[];
pl.wind[1980.0; 1990.0; 0.0; 35.0];
pl.box[`$"bc"; 1.0; 0; `$"bcnv"; 10.0; 0i];
pl.col0[pl`yellow];
pl.lab[`$"Year"; `$"Widget Sales (millions)"; `$"#frPLplot Example 12"];

y0:5 15 12 24 28 30 20 8 12 3.;

pl.scmap1l[1b; 5; pos; red; green; blue; 0 0 0 0 0i];

i:0; do[10;
    /pl.col0[i + 1];
    pl.col1[i % 9.0];
    pl.psty[0];
    fbox[1980. + i; y0[i]];
    pl.ptex[1980. + i + .5; y0[i] + 1.; 1.0; 0.0; .5; `$string y0[i]];
    pl.mtex[`$"b";1.0; ((i + 1) * .1) - .05; 0.5; `$string 1980+i];
    i+:1];

// Don't forget to call pl.end() to finish off!

pl.end[];
\\
// $Id: x12c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Bar chart demo.
//
