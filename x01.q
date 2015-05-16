\l qplplot.q
flags:.Q.def[(enlist`fontset)!(enlist 0)].Q.opt .z.x

plot1:{
    xi:xoff+xscale*(1+til 60)%60;
    yi:yoff+yscale*xi*xi;
    xmin:min xi; xmax: max xi;
    ymin:min yi; ymax: max yi;
    xs:xi[4+10*til 6];
    ys:yi[4+10*til 6];

    pl.col0[pl`red];
    pl.env[xmin; xmax; ymin; ymax; 0; 0];
    pl.col0[pl`yellow];
    pl.lab[`$"(x)"; `$"(y)"; `$"#frPLplot Example 1 - y=x#u2"];

    pl.col0[pl`aquamarine];
    pl.poin[count xs; xs; ys; 9];

    pl.col0[pl`green];
    pl.line[count xi; xi; yi]}

plot2:{
    pl.col0[pl`red];
    pl.env[-2f; 10f; -0.4; 1.2; 0; 1];
    pl.col0[pl`yellow];
    pl.lab[`$"(x)"; `$"sin(x)/x"; `$"#frPLplot Example 1 - Sinc Function"];

    yi:1^sin[xi]%xi:((1+til 100)-20)%6;

    pl.col0[pl`green];
    pl.width[2f];
    pl.line[count xi; xi;yi];
    pl.width[1f]}

plot3:{
    pl.adv[0];
    pl.vsta[];
    pl.wind[0f; 360f; -1.2; 1.2];

    pl.col0[pl`red];
    pl.box[`bcnst; 60f; 2; `bcnstv; 0.2; 2];

    pl.styl[1; enlist 1500i; enlist 1500i];
    pl.col0[pl`yellow];
    pl.box[`g; 30f; 0; `g; 0.2; 0];
    pl.styl[0; 0; 0]

    pl.col0[pl`green];
    pl.lab[`$"Angle (degrees)"; `$"sine"; `$"#frPLplot Example 1 - Sine function"];

    xi:3.6*til 101;
    yi:sin[xi*PI%180];

    pl.col0[pl`aquamarine];
    pl.line[count xi; xi; yi];}



ver:pl.gver[]
show"PLplot library version: ",string ver

//pl.sdev`xwin

pl.star[2;2]
$[flags`fontset; pl.fontld[1]; pl.fontld[0]]

PI:4*atan 1

xscale:6f
yscale:1f
xoff:yoff:0f

plot1[0]

xscale:1f
yscale:0.0014
yoff:0.0185

digmax:5
pl.syax[digmax; 0]

plot1[1]
plot2[]
plot3[]

pl.end[]

\\
// $Id: x01c.c 11680 2011-03-27 17:57:51Z airwin $
//
//      Simple line plot and multiple windows demo.
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
//
