\l qplplot.q
/pl.sdev`xwin
M_PI:4*atan[1]

plot1:{
    xi:xoff+xscale*(1+til 60)%60;
    yi:yoff+yscale*xi*xi;
    xmin:min xi; xmax: max xi;
    ymin:min yi; ymax: max yi;
    xs:xi[3+10*til 6];
    ys:yi[3+10*til 6];
    // Set up the viewport and window using PLENV. The range in X is
    // 0.0 to 6.0, and the range in Y is 0.0 to 30.0. The axes are
    // scaled separately (just = 0), and we just draw a labelled
    // box (axis = 0).
    pl.col0[pl`red];
    pl.env[xmin; xmax; ymin; ymax; 0; 0];
    pl.col0[6];
    pl.lab[`$"(x)"; `$"(y)"; `$"#frPLplot Example 1 - y=x#u2"];
    // Plot the data points
    pl.col0[9];
    pl.poin[6; xs; ys; 9];
    // Draw the line through the data
    pl.col0[pl`aquamarine];
    pl.line[60; xi; yi];
    pl.flush[]}

plot2:{
    pl.col0[pl`red];
    // Set up the viewport and window using PLENV. The range in X is -2.0 to
    //     10.0, and the range in Y is -0.4 to 2.0. The axes are scaled separately
    //     (just = 0), and we draw a box with axes (axis = 1).
    pl.env[-2.0; 10.0; -0.4; 1.2; 0; 1];
    pl.col0[pl`yellow];
    pl.lab[`$"(x)"; `$"sin(x)%x"; `$"#frPLpl.ot Exampl.e 1 - Sinc Function"];
    // Fill up the arrays
    xi:((til 100)-19.)%6.0;
    yi:1.^sin[xi]%xi;
    // Draw the line
    pl.col0[pl`green];
    pl.line[100; xi; yi];
    pl.flush[]}

plot3:{
    // For the final graph we wish to override the default tick intervals, and
    //     so do not use PLENV
    pl.adv[0];
    // Use standard viewport, and define X range from 0 to 360 degrees, Y range
    //     from -1.2 to 1.2.
    pl.vsta[];
    pl.wind[0.0; 360.0; -1.2; 1.2];
    // Draw a box with ticks spaced 60 degrees apart in X, and 0.2 in Y.
    pl.col0[pl`red];
    pl.box[`$"bcnst"; 60.0; 2; `$"bcnstv"; 0.2; 2];
    // Superimpose a dashed line grid, with 1.5 mm marks and spaces. plstyl
    // expects a pointer!!
    pl.styl[1; enlist mark1; enlist space1];
    pl.col0[pl`yellow];
    pl.box[`$"g"; 30.0; 0; `$"g"; 0.2; 0];
    pl.styl[0; enlist mark0; enlist space0];
    pl.col0[pl`green];
    pl.lab[`$"Angle (degrees)"; `$"sine"; `$"#frPLpl.ot Exampl.e 1 - Sine function"];
    xi:3.6*til 101;
    yi:sin[xi*M_PI%180.0];
    pl.col0[pl`aquamarine];
    pl.line[101; xi; yi];
    pl.flush[]}

plot4:{
    dtr:M_PI % 180.0;
    x0:cos[dtr * 1+til 360];
    y0:sin[dtr * 1+til 360];
    // Set up viewport and window, but do not draw box
    pl.env[-1.3; 1.3; -1.3; 1.3; 1; -2];
    i:0; do[10;
        x1:0.1 * i * x0;
        y1:0.1 * i * y0;
        // Draw circles for polar grid
        pl.line[361; x1; y1];
        i+:1;];
    pl.col0[pl`yellow];
    i:0; do[12;
        theta:30.0 * i;
        dx:cos[dtr * theta];
        dy:sin[dtr * theta];
        pl.join[0.0; 0.0; dx; dy];
        text:`$string "j"$theta;
        $[dx >= -0.00001;
            pl.ptex[dx; dy; dx; dy; -0.15; text];
            pl.ptex[dx; dy; neg dx; neg dy; 1.15; text]];
        i+:1;]
    // Draw the graph
    r:sin[dtr*5*(1+til 360)];
    x1:x0 * r;
    y1:y0 * r;
    pl.col0[pl`green];
    pl.line[361; x1; y1];
    pl.col0[pl`aquamarine];
    pl.mtex[`$"t"; 2.0; 0.5; 0.5; `$"#frPLpl.ot Exampl.e 3 - r(#gh)=sin 5#gh"];
    pl.flush[]}

XPTS:35i;
YPTS:46i;
XSPA:2.%(XPTS-1);
YSPA:2.%(YPTS-1);
tr:(XSPA; 0.0; -1.0; 0.0; YSPA; -1.0);
mypltr:{[x; y; z] z:0N; tx:(tr[0]*x)+(tr[1]*y)+tr[2]; ty:(tr[3]*x)+(tr[4]*y)+tr[5]; (tx;ty)}

clevel:(-1.; -.8; -.6; -.4; -.2; 0.0; .2; .4; .6; .8; 1.);

plot5:{mark:1500; space:1500;
    xi:((til XPTS) - (XPTS div 2))%(XPTS div 2);
    yi:(((til YPTS)-(YPTS div 2))%(YPTS div 2)) - 1.0;
    zm:(flip enlist XPTS#0f)$(enlist YPTS#0f);
    wm:zm;
    i:0; do[XPTS; xx:(i-(XPTS div 2))%(XPTS div 2); /xi[i];
            j:0; do[YPTS; yy:((j-(YPTS div 2))%(YPTS div 2)) - 1.0f; / yi[j];
                    zm:.[zm; (i;j); :; (xx*xx)-(yy*yy)];
                    wm:.[wm; (i;j); :; 2*xx*yy];
                    j+:1]; i+:1];
    pl.env[-1.0; 1.0; -1.0; 1.0; 0; 0];
    pl.col0[pl`yellow];
    pl.cont[zm; (1i; XPTS); (1i; YPTS); clevel; mypltr; 0N];
    pl.styl[1; enlist mark; enlist space];
    pl.col0[pl`green];
    pl.cont[wm; (1i; XPTS); (1i; YPTS); clevel; mypltr; 0N];
    pl.col0[pl`red];
    pl.lab[`$"X Coordinate"; `$"Y Coordinate"; `$"Streamlines of flow"];
    pl.flush[]}


//--------------------------------------------------------------------------
// main
//
// Plots several simple functions from other example programs.
//
// This version sends the output of the first 4 plots (one page) to two
// independent streams.
//--------------------------------------------------------------------------
space0:0; mark0:0; space1:1500; mark1:1500;
geometry_master:`$"500x410+100+200";
geometry_slave:`$"500x410+650+200";
/driver:`;
//(void) pl.parseopts[&argc; argv; PL_PARSE_FULL];
page:pl.gpage[];
xp0:page`xp;
yp0:page`yp;
xleng0:page`xleng;
yleng0:page`yleng;
xoff0:page`xoff;
yoff0:page`yoff;
valid_geometry:(xleng0 > 0) and yleng0 > 0;
// Set up first stream
$[valid_geometry;
    pl.spage[xp0; yp0; xleng0; yleng0; xoff0; yoff0];
    pl.setopt[`$"geometry"; geometry_master]];
pl.ssub[2; 2];
pl.init[];
driver:pl.gdev[];
fnb:pl.gfam[];
fam:fnb`fam;
num:fnb`num;
bmax:fnb`bmax;
/printf[`$"Demo of multipl.e output streams via the %s driver.\n"; driver];
/printf[`$"Running with the second stream as slave to the first.\n"];
/printf[`$"\n"];
// Start next stream
pl.sstrm[1];
$[valid_geometry;
    pl.spage[xp0; yp0; xleng0; yleng0; xoff0; yoff0];
    pl.setopt[`$"geometry"; geometry_slave]];
// Turn off pause to make this a slave (must follow master)
pl.spause[0];
/pl.sdev[driver];
pl.sfam[fam; num; bmax];
// Currently number of digits in format number can only be
// set via the command line option
pl.setopt[`$"fflen"; `$"2"];
pl.init[];
// Set up the data & plot
// Original case
pl.sstrm[0];
xscale:6.;
yscale:1.;
xoff:0.;
yoff:0.;
plot1[];
// Set up the data & plot
xscale:1.;
yscale:1.e+6;
plot1[];
// Set up the data & plot
xscale:1.;
yscale:1.e-6;
digmax:2;
pl.syax[digmax; 0];
plot1[];
// Set up the data & plot
xscale:1.;
yscale:0.0014;
yoff:0.0185;
digmax:5;
pl.syax[digmax; 0];
plot1[];
/ To slave
// The pleop() ensures the eop indicator gets lit.
pl.sstrm[1];
plot4[];
pl.eop[];
// Back to master
pl.sstrm[0];
plot2[];
plot3[];
// To slave
pl.sstrm[1];
plot5[];
pl.eop[];
// Back to master to wait for user to advance
pl.sstrm[0];
pl.eop[];
// Call plend to finish off.
pl.end[];
\\
// $Id: x14c.c 11680 2011-03-27 17:57:51Z airwin $
//
//      Demo of multiple stream/window capability (requires Tk or Tcl-DP).
//
//      Maurice LeBrun
//      IFS, University of Texas at Austin
//
// Copyright (C) 2004  Alan W. Irwin
//
// This file is part of PLplot.
//
// PLplot is free software; you can redistribute it and/or modify
// it under the terms of the GNU Library General Public License as published
// by the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// PLplot is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Library General Public License for more details.
//
// You should have received a copy of the GNU Library General Public License
// along with PLplot; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
//
//
