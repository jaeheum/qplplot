\l qplplot.q
XPTS:35i            // Data points in x
YPTS:46i           // Data points in y
LEVELS:10i

opt:(pl`DRAW_LINEXY;pl`DRAW_LINEXY)
alt:33.0 17.0;
az:24.0 115.0;

title:(`$"#frPLplot Example 11 - Alt=33, Az=24, Opt=3";`$"#frPLplot Example 11 - Alt=17, Az=115, Opt=3");

cmap1_init:{
    i:0.0 1.0;         // left boundary; right boundary
    h:240 0f;        // blue -> green -> yellow -> ; -> red
    l:0.6 0.6;
    s:0.8 0.8;
    pl.scmap1n[256];
    pl.scmap1l[0i; 2i; i; h; l; s; 0 0i]}

//--------------------------------------------------------------------------
// main
//
// Does a series of mesh plots for a given data set; with different
// viewing options in each plot.
//--------------------------------------------------------------------------


// Initialize plplot
pl.init[];
x:3.*((til XPTS) - (XPTS div 2)) % (XPTS div 2);
y:3.*((til YPTS) - (YPTS div 2)) % (YPTS div 2);
z:(flip enlist XPTS#0f)$(enlist YPTS#0f)

pow:xexp;
i:0; do[XPTS;
        xx:x[i];
        j:0; do[YPTS; yy:y[j];
            z0:(3.*(1.-xx)*(1.-xx) * exp[(neg xx*xx) - (yy+1.)*(yy+1.)]);
            z1:10. * (((xx % 5.) - pow[xx; 3.]) - pow[yy; 5.]);
            z11:exp[(neg xx*xx)-yy*yy];
            z2:((1. % 3.) * exp[(neg (xx+1)*(xx+1)) - yy*yy]);
            .[`z; (i;j); :; (z0-(z1*z11))-z2];
                /(3.*pow[1.-xx;2] * exp[(neg pow[xx;2]) - pow[yy+1.; 2]])
                /- (10. * (((xx % 5.) - pow[xx; 3.]) - pow[yy; 5.]) * exp[(neg pow[xx;2]) - pow[yy; 2]])
                /- ((1. % 3.) * exp[(neg pow[xx+1.;2]) - pow[yy;2]])];
            //if[z[i][j] < -1.; .[`z; (i;j); : ; -1f]];
            j+:1];
        i+:1];

// plMinMax2dGrid
zmax:max raze z;
zmin:min raze z;
nlevel:LEVELS;
step:(zmax-zmin) % (nlevel+1);
clevel:zmin+step+step*til nlevel;

cmap1_init[];

k:0; do[2;
    i:0; do[4;
        pl.adv[0];
        pl.col0[pl`red];
        pl.vpor[0.0; 1.0; 0.0; 0.9];
        pl.wind[-1.0; 1.0; -1.0; 1.5];
        // N.B. pl.w3d takes three arguments.
        pl.w3d[(1.0; 1.0; 1.2); (-3.0; 3.0; -3.0; 3.0; zmin; zmax); (alt[k]; az[k])];
        // N.B. pl.box3 takes three arguments.
        pl.box3[(`$"bnstu"; `$"x axis"; 0.0; 0i); (`$"bnstu"; `$"y axis"; 0.0; 0i); (`$"bcdmnstuv"; `$"z axis"; 0.0; 4i)];
        pl.col0[pl`yellow];
        // wireframe plot
        if[i=0; pl.mesh[x; y; z; XPTS; YPTS; opt[k]]];
        // magnitude colored wireframe plot
        if[i=1; pl.mesh[x; y; z; XPTS; YPTS; bor[opt[k]; pl`MAG_COLOR]]];
        // magnitude colored wireframe plot with sides
        if[i=2; pl.ot3d[x; y; z; XPTS; YPTS; bor[opt[k]; pl`MAG_COLOR]; 1]];
        // magnitude colored wireframe plot with base contour
        if[i=3; pl.meshc[x; y; z; XPTS; YPTS; bor[bor[opt[k]; pl`MAG_COLOR]; pl`BASE_CONT]; clevel; nlevel:LEVELS]];
        pl.col0[pl`green];
        pl.mtex[`$"t"; 1.0; 0.5; 0.5; title[k]];
        i+:1];
    k+:1];

pl.end[];
\\
// $Id: x11c.c 11680 2011-03-27 17:57:51Z airwin $
//
//      Mesh plot demo.
//
// Copyright (C) 2004  Rafael Laboissiere
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
