\l qplplot.q
M_PI:4*atan[1];

mark:space:1500i;

XPTS:35i
YPTS:46i
XSPA:2%(XPTS-1)
YSPA:2%(YPTS-1)

// polar plot data
PERIMETERPTS:100i;
RPTS:40i;
THETAPTS:40i;

// potential plot data
PPERIMETERPTS:100i
PRPTS:40i
PTHETAPTS:64i
PNLEVEL:20i

clevel: -1. -.8 -.6 -.4 -.2 0 .2 .4 .6 .8 1.;

// Transformation function

tr:(XSPA; 0.0; -1.0; 0.0; YSPA; -1.0);

mypltr:{[x;y;z] z:0N; tx:(tr[0]*x)+(tr[1]*y)+tr[2]; ty:(tr[3]*x)+(tr[4]*y)+tr[5]; (tx;ty)}

polar:{
    pl.env[-1.; 1.; -1.; 1.; 0; -2];
    pl.col0[pl`red];

    //Perimeter
    t:(2. * M_PI % (PERIMETERPTS - 1))*til PERIMETERPTS;
    px:cos t;
    py:sin t;

    pl.line[PERIMETERPTS; px; py];

    //create data to be contoured.
    xg:yg:zz:(flip enlist RPTS#0f)$(enlist THETAPTS#0f);
    i:0; do[RPTS;
        r:i%(RPTS - 1);
        j:0; do[THETAPTS;
            theta:(2. * M_PI % (THETAPTS - 1)) * j;
            / N.B. xg yg zz are local, hence no `xg `yg `zz in amend lest 'length happens.
            xg:.[xg; (i;j); :; r * cos[theta]];
            yg:.[yg; (i;j); :; r * sin[theta]];
            zz:.[zz; (i;j); :; r];
            j+:1];
        i+:1];
    lev:0.05 + 0.10 * til 10;
    pl.col0[pl`yellow];
    pl.cont2[zz; (1i; RPTS); (1i; THETAPTS); lev; xg; yg];
    pl.col0[pl`red];
    pl.lab[`$""; `$""; `$"Polar Contour Plot"]}

// shielded potential contour plot example.
potential:{
    / N.B. 'locals or too many local variables. 23 max. CSE by hand...

    // create data to be contoured.
    xg:yg:zz:(flip enlist PRPTS#0f)$(enlist PTHETAPTS#0f);
    i:0; do[PRPTS;
        r:0.5+i;
        j:0; do[PTHETAPTS;
            theta:(2. * M_PI % (PTHETAPTS - 1)) * (0.5  + j);
            xg:.[xg; (i;j); :; r * cos[theta]];
            yg:.[yg; (i;j); :; r * sin[theta]];
            j+:1];
        i+:1];

    xmin:min raze xg;
    xmax:max raze xg;
    ymin:min raze yg;
    ymax:max raze yg;
    / x0:(xmin + xmax) % 2.;
    / y0:(ymin + ymax) % 2.;

    // Expanded limits
    // peps:0.05;
    / xpmin:xmin - abs[xmin] * 0.05;
    / xpmax:xmax + abs[xmax] * 0.05;
    / ypmin:ymin - abs[ymin] * 0.05;
    / ypmax:ymax + abs[ymax] * 0.05;

    // Potential inside a conducting cylinder (or sphere) by method of images.
    // Charge 1 is placed at (d1, d1), with image charge at (d2, d2).
    // Charge 2 is placed at (d1, -d1), with image charge at (d2, -d2).
    // Also put in smoothing term at small distances.
    //

    / eps:2.;

    / q1:1.;
    / d1:r % 4.;

    / neg 4. q1i:(neg 1.) * r % (r % 4.);
    / d1i:xexp[r; 2.] % (r % 4.);

    / q2:neg 1.;
    / d2:r % 4.;

    / q2i:neg q2 * r % (r % 4.);
    / d2i:xexp[r; 2.] % (r % 4.);

    i:0; do[PRPTS;
        j:0; do[PTHETAPTS;
            div1:sqrt[xexp[xg[i][j] - r%4; 2.] + xexp[yg[i][j] - r%4; 2.] + xexp[2.; 2.]];
            div1i:sqrt[xexp[xg[i][j] - xexp[r; 2.] % (r % 4.); 2.] + xexp[yg[i][j] - (xexp[r; 2.] % (r % 4.)); 2.] + xexp[2.; 2.]];
            div2:sqrt[xexp[xg[i][j] - r%4; 2.] + xexp[yg[i][j] + r%4; 2.] + xexp[2.; 2.]];
            div2i:sqrt[xexp[xg[i][j] - xexp[r; 2.] % (r % 4.); 2.] + xexp[yg[i][j] + (xexp[r; 2.] % (r % 4.)); 2.] + xexp[2.; 2.]];
            zz:.[zz; (i;j); :; (1. % div1) + (neg 4. % div1i) + (neg 1. % div2) + (4. % div2i)];
            j+:1];
        i+:1];

    zmin:min raze zz;
    zmax:max raze zz;
    // Positive and negative contour levels.
    // dz:(zmax - zmin) % PNLEVEL;
    / nlevelneg:0;
    / nlevelpos:0;
    /clevelpos:clevelneg:() / PNLEVEL#0f;
    /i:0; do[PNLEVEL;
    /    clevel2:zmin + (i + 0.5) * ((zmax - zmin) % PNLEVEL);
    /    $[clevel2 <= 0.;
    /        clevelneg,:clevel2;     /   clevelneg[nlevelneg+:1]:clevel2;
    /        clevelpos,:clevel2];    /   clevelpos[nlevelpos+:1]:clevel2];
    /    i+:1];

    clevel2:zmin+(0.5+til PNLEVEL)*((zmax-zmin)%PNLEVEL);
    // Colours!
    // ncollin:11i;
    // ncolbox:1i;
    // ncollab:2i;

    // Finally start plotting this page!
    pl.adv[0];
    pl.col0[1i]; / ncolbox

    pl.vpas[0.1; 0.9; 0.1; 0.9; 1.0];
    pl.wind[xmin - abs[xmin] * 0.05; xmax + abs[xmax] * 0.05; ymin - abs[ymin] * 0.05; ymax + abs[ymax] * 0.05];
    pl.box[`$""; 0.; 0; `$""; 0.; 0];

    pl.col0[11i];   / ncollin

    if[0<count where clevel2 <= 0f;
        // Negative contours
        pl.lsty[2i];
        pl.cont2[zz; (1i; PRPTS); (1i; PTHETAPTS); clevel2[where clevel2<=0f]; xg; yg]];

    if[0<count where clevel2>0f; / count clevelpos) > 0;
        // Positive contours
        pl.lsty[1i];
        pl.cont2[zz; (1i; PRPTS); (1i; PTHETAPTS); clevel2[where clevel2>0f]; xg; yg]];

    // Draw outer boundary
    / t:(2. * M_PI % (PPERIMETERPTS - 1)) * til PPERIMETERPTS;
    px:((xmin + xmax) % 2.) + r*cos[(2. * M_PI % (PPERIMETERPTS - 1)) * til PPERIMETERPTS];
    py:((ymin + ymax) % 2.) + r*sin[(2. * M_PI % (PPERIMETERPTS - 1)) * til PPERIMETERPTS];

    pl.col0[1i];    / ncolbox;
    pl.line[PPERIMETERPTS; px; py];

    pl.col0[2i];    / ncollab;
    pl.lab[`$""; `$""; `$"Shielded potential of charges in a conducting sphere"]}


// Parse and process command line arguments

//    (void) plparseopts( &argc, argv, PL_PARSE_FULL );

// Initialize plplot

pl.init[];

// Set up function arrays
z:w:(flip enlist XPTS#0f)$(enlist YPTS#0f)
i:0; do[XPTS;
    xx:(i - (XPTS div 2)) % (XPTS div 2);
    j:0; do[YPTS;
        yy:((j - (YPTS div 2)) % (YPTS div 2)) - 1.0;
        .[`z; (i;j); :; (xx * xx) - (yy * yy)];
        .[`w; (i;j); :; 2 * xx * yy];
        j+:1];
    i+:1]

// Set up grids

xg1:XPTS#0f;
yg1:YPTS#0f;
xg2:yg2:(flip enlist XPTS#0f)$(enlist YPTS#0f)

i:0; do[XPTS;
    j:0; do[YPTS;
        tt:mypltr[`float$i;`float$j;0N];
        xx:tt 0; yy:tt 1;
        argx:xx * M_PI % 2;
        argy:yy * M_PI % 2;
        distort:0.4;
        @[`xg1; i; :; xx + distort * cos[argx]];
        @[`yg1; j; :; yy - distort * cos[argy]];

        .[`xg2; (i;j); :; xx + distort * cos[argx] * cos[argy]];
        .[`yg2; (i;j); :; yy - distort * cos[argx] * cos[argy]];
        j+:1];
    i+:1];
// Plot using identity transform
pl.setcontlabelformat[4;3];
pl.setcontlabelparam[0.006; 0.3; 0.1; 1];
pl.env[-1.0; 1.0; -1.0; 1.0; 0; 0];
pl.col0[pl`yellow];
pl.cont[z; (1i; XPTS); (1i; YPTS); clevel; mypltr; 0N];
pl.styl[1; enlist mark; enlist space];
pl.col0[pl`green];
pl.cont[w; (1i; XPTS); (1i; YPTS); clevel; mypltr; 0N];
pl.styl[0; enlist mark; enlist space];
pl.col0[pl`red];
pl.lab[`$"X Coordinate"; `$"Y Coordinate"; `$"Streamlines of flow"];
pl.setcontlabelparam[0.006; 0.3; 0.1; 0];

// Plot using 1d coordinate transform
pl.env[-1.0; 1.0; -1.0; 1.0; 0; 0];
pl.col0[pl`yellow];
pl.cont1[z; (1i; XPTS); (1i; YPTS); clevel; xg1; yg1];
pl.styl[1; enlist mark; enlist space];
pl.col0[pl`green];
pl.cont1[w; (1i; XPTS); (1i; YPTS); clevel; xg1; yg1];
pl.styl[0; enlist mark; enlist space];
pl.col0[pl`red];
pl.lab[`$"X Coordinate"; `$"Y Coordinate"; `$"Streamlines of flow"];

// Plot using 2d coordinate transform
pl.env[-1.0; 1.0; -1.0; 1.0; 0; 0];
pl.col0[pl`yellow];
pl.cont2[z; (1i; XPTS); (1i; YPTS); clevel; xg2; yg2];
pl.styl[1; enlist mark; enlist space];
pl.col0[pl`green];
pl.cont2[w; (1i; XPTS); (1i; YPTS); clevel; xg2; yg2];
pl.styl[0; enlist mark; enlist space];
pl.col0[pl`red];
pl.lab[`$"X Coordinate"; `$"Y Coordinate"; `$"Streamlines of flow"];
pl.setcontlabelparam[0.006; 0.3; 0.1; 0];
polar[];
pl.setcontlabelparam[0.006; 0.3; 0.1; 0];
potential[];
pl.end[];
\\
// $Id: x09c.c 11680 2011-03-27 17:57:51Z airwin $
//
//      Contour plot demo.
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
