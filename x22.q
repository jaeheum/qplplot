\l qplplot.q
// Pairs of points making the line segments used to plot the user defined arrow
arrow_x:-0.5 0.5 0.3 0.5 0.3 0.5;
arrow_y:0.0 0.0 0.2 0.0 -0.2 0.0;
arrow2_x:-0.5 0.3 0.3 0.5 0.3 0.3;
arrow2_y:0.0 0.0 0.2 0.0 -0.2 0.0;

//--------------------------------------------------------------------------
// main
//
// Generates several simple vector plots.
//--------------------------------------------------------------------------

//
// Vector plot of the circulation about the origin
//
circulation:{
    nx:ny:20;
    dx:dy:1.0;

    xmin:(neg nx % 2) * dx;
    xmax:(nx % 2) * dx;
    ymin:(neg ny % 2) * dy;
    ymax:(ny % 2) * dy;

    xg:yg:u:v:(flip enlist nx#0f)$(enlist ny#0f);

    // Create data - circulation around the origin.
    i:0; do[nx;
        xi:((i - (nx % 2)) + 0.5) * dx;
        j:0; do[ny;
            yj:((j - (ny % 2)) + 0.5) * dy;
            xg:.[xg; (i;j); :; xi];
            yg:.[yg; (i;j); :; yj];
            u:.[u; (i;j); :; yj];
            v:.[v; (i;j); :; neg xi];
            j+:1];
        i+:1];

    // Plot vectors with default arrows
    pl.env[xmin; xmax; ymin; ymax; 0; 0];
    pl.lab[`$"(x)"; `$"(y)"; `$"#frPLplot Example 22 - circulation"];
    pl.col0[pl`yellow];
    pl.vect2[u; v; 0.0; xg; yg];
    pl.col0[pl`red]}

//
// Vector plot of flow through a constricted pipe
//
constriction:{[astyle]
    nx:ny:20;
    dx:dy:1.0;

    xmin:(neg nx % 2) * dx;
    xmax:(nx % 2) * dx;
    ymin:(neg ny % 2) * dy;
    ymax:(ny % 2) * dy;

    xg:yg:u:v:(flip enlist nx#0f)$(enlist ny#0f);

    Q:2.0;
    i:0; do[nx;
        xi:((i - (nx % 2)) + 0.5) * dx;
        j:0; do[ny;
            yj:((j - (ny % 2)) + 0.5) * dy;
            xg:.[xg; (i;j); :; xi];
            yg:.[yg; (i;j); :; yj];
            b:(ymax % 4.0) * (3 - cos[M_PI * xi % xmax]);
            $[abs[yj]<b;
                [dbdx:(ymax % 4.0) * sin[M_PI * xi  % xmax] * yj % b;
                u:.[u; (i;j); :; Q * ymax % b];
                v:.[v; (i;j); :; dbdx * u[i][j]]];
                [u:.[u; (i;j); :; 0.0];
                v:.[v; (i;j); :; 0.0];]];
            j+:1];
        i+:1];

    pl.env[xmin; xmax; ymin; ymax; 0; 0];
    pl.lab[`$"(x)"; `$"(y)"; `$"#frPLplot Example 22 - constriction (arrow style ",(string astyle),")"];
    pl.col0[pl`yellow];
    pl.vect2[u; v; -1.0; xg; yg];
    pl.col0[pl`red]}

//
// Global transform function for a constriction using data passed in
// This is the same transformation used in constriction.
//
transform:{
    xt:x;
    yt:(y % 4.0) * ( 3 - cos[M_PI * x % xmax:z]);
    (xt; yt)}

//
// Vector plot of flow through a constricted pipe
// with a coordinate transform
//
constriction2:{
    nx:ny:20;
    nc:NC:11;
    nseg:20;

    dx:dy:1.0;

    xmin:(neg nx % 2) * dx;
    xmax:(nx % 2) * dx;
    ymin:(neg ny % 2) * dy;
    ymax:(ny % 2) * dy;

    pl.stransform[transform; xmax];

    xg:yg:u:v:(flip enlist nx#0f)$(enlist ny#0f);

    Q:2.0;
    i:0; do[nx;
        xi:((i - (nx % 2)) + 0.5) * dx;
        j:0; do[ny;
            yj:((j - (ny % 2)) + 0.5) * dy;
            xg:.[xg; (i;j); :; xi];
            yg:.[yg; (i;j); :; yj];
            b:(ymax % 4.0) * (3 - cos[M_PI * xi % xmax]);
            u:.[u; (i;j); :; Q * ymax % b];
            v:.[v; (i;j); :; 0.0];
        j+:1];
    i+:1];

    clev:Q + (til nc) * Q % (nc - 1);

    pl.env[xmin; xmax; ymin; ymax; 0; 0];
    pl.lab[`$"(x)"; `$"(y)"; `$"#frPLplot Example 22 - constriction with plstransform"];
    pl.col0[pl`yellow];
    pl.shades[u; 0N;
        (xmin + dx % 2; xmax - dx % 2; ymin + dy % 2; ymax - dy % 2; clev);
        (0.0; 1i; 1.0); 0; 0N; 0N];
    pl.vect2[u; v; -1.0; xg; yg];
    // Plot edges using pl.path (which accounts for coordinate transformation) rather than pl.line
    pl.path[nseg; xmin; ymax; xmax; ymax];
    pl.path[nseg; xmin; ymin; xmax; ymin];
    pl.col0[pl`red];

    pl.stransform[0N;0N]}

//
// Vector plot of the gradient of a shielded potential (see example 9)
//
potential:{
    / 'branch. :-(
    ;}

pl.init[];
circulation[];

narr:6;
fill:0;

// Set arrow style using arrow_x and arrow_y then
// pl.ot using these arrows.
pl.svect[arrow_x; arrow_y; narr; fill];
constriction[1];

// Set arrow style using arrow2_x and arrow2_y then
// pl.ot using these filled arrows.
fill:1;
pl.svect[arrow2_x; arrow2_y; narr; fill];
constriction[2];

constriction2[];

// Reset arrow style to the default by passing two
// NULL arrays
pl.svect[enlist 0N; enlist 0N;0; 0];

potential[];

pl.end[];
\\
// $Id: x22c.c 11680 2011-03-27 17:57:51Z airwin $
//
//  Simple vector plot example
//  Copyright (C) 2004 Andrew Ross <andrewross@users.sourceforge.net>
//  Copyright (C) 2004  Rafael Laboissiere
//
//
//  This file is part of PLplot.
//
//  PLplot is free software; you can redistribute it and/or modify
//  it under the terms of the GNU Library General Public License as published
//  by the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  PLplot is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Library General Public License for more details.
//
//  You should have received a copy of the GNU Library General Public License
//  along with PLplot; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
//
//
