\l qplplot.q
/pl.sdev`xwin

fbox:{[x; y25; y50; y75; lw; uw];
    spacing:.4;
    xmin:x+spacing%2.;
    xmax:x+1.-spacing%2.;

    // box

    px:(xmin; xmin; xmax; xmax; xmin);
    py:(y25; y75; y75; y25; y25);

    pl.psty[0];
    pl.fill[4; px; py];
    pl.col0[pl`red];
    pl.lsty[1];
    pl.line[5; px; py];


    // median

    mx:(xmin; xmax);
    my:(y50; y50);

    pl.lsty[1];
    pl.line[2; mx; my];

    // lower whisker

    xmid:(xmin + xmax)% 2.;
    xwidth:xmax - xmin;
    wx:(xmid; xmid);
    wy:(lw; y25);

    pl.lsty[2]; // short dashes and gaps
    pl.line[2; wx; wy];

    barx:(xmid - xwidth%4.;xmid + xwidth%4.);
    bary:(lw; lw);

    pl.lsty[1];
    pl.line[2; barx; bary];

    // upper whisker

    xmid:(xmin + xmax)%2.;
    xwidth:xmax - xmin;
    wy:(y75; uw);

    pl.lsty[2]; // short dashes and gaps
    pl.line[2; wx; wy];

    bary:(uw; uw);

    pl.lsty[1];
    pl.line[2; barx; bary];}

y25:0.984 0.980 0.976 0.975 0.973 0.967 0.974 0.954 0.987 0.991;
y50:0.994 0.999 1.035 0.995 1.002 0.997 1.034 0.984 1.007 1.017;
y75:1.054 1.040 1.066 1.025 1.043 1.017 1.054 1.004 1.047 1.031;
lw:0.964 0.950 0.926 0.955 0.963 0.937 0.944 0.924 0.967 0.941;
uw:1.071 1.062 1.093 1.045 1.072 1.067 1.085 1.024 1.057 1.071;
outx:3.5 6.5;
outy:0.89 1.09;

pl.init[];
pl.adv[0];
pl.vsta[];

x0:1.;
pl.wind[x0; x0+10; 0.85; 1.15];
pl.col0[pl`red];
pl.box[`$"bc"; 1.0; 0; `$"bcgnst"; 0; 0];
pl.lab[`$"Group"; `$"Value"; `$"#frplplot Example 32"];

i:0; do[10;
    pl.col1[i%9.0];
    fbox[x0+i; y25[i]; y50[i]; y75[i]; lw[i]; uw[i]];
    pl.mtex[`$"b"; 1.0; ((i+1)*.1)-.05; 0.5; `$string x0+i];
    i+:1;]

pl.poin[2; outx; outy; 22];
pl.end[];
\\
// $Id: x32c.c 11680 2011-03-27 17:57:51Z airwin $
//
//      Box plot demo.
//
// Copyright (C) 2008 by FLLL <http://www.flll.jku.at>
// Author: Robert Pollak <robert.pollak@jku.at>
// Copyright (C) 2009 Andrew Ross
//
// This file is part of PLplot.
//
//  PLplot is free software; you can redistribute it and/or modify
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
