ae:{if[not x~y;'`fail]}

// Test setting / getting familying parameters before plinit
// Save values set by plparseopts to be restored later.

\l qplplot.q

r1:0 255i;
g1:255 0i;
b1:0 0i;
a1:1 1f;

// Test setting / getting familying parameters before plinit
// Save values set by plparseopts to be restored later.
fmb0:pl.gfam[];
fam0:fmb0`fam;
num0:fmb0`num;
bmax0:fmb0`bmax;

fam1:0i;
num1:10i;
bmax1:1000i;
fmb1:(`fam`num`bmax)!(fam1;num1;bmax1);
pl.sfam[fam1; num1; bmax1];

// Retrieve the same values?
fmb2:pl.gfam[];
ae[fmb1; fmb2];
// Restore values set initially by plparseopts.
pl.sfam[fam0; num0; bmax0];

// Test setting / getting page parameters before plinit
// Save values set by plparseopts to be restored later.
gpage:pl.gpage[];
xp1:200.;
yp1:200.;
xleng1:400i;
yleng1:200i;
xoff1:10i;
yoff1:20i;

// Retrieve the same values?
gpage1:(`xp`yp`xleng`yleng`xoff`yoff)!(xp1;yp1;xleng1;yleng1;xoff1;yoff1);
pl.spage[xp1; yp1; xleng1; yleng1; xoff1; yoff1];

// Retrieve the same values?
gpage2:pl.gpage[];

ae[gpage1; gpage2];

// Restore values set initially by plparseopts.
pl.spage[gpage`xp; gpage`yp; gpage`xleng; gpage`yleng; gpage`xoff; gpage`yoff];

// Test setting / getting compression parameter across plinit.
compression1:95i;
pl.scompression[compression1];

// Initialize plplot
pl.init[];

// Test if device initialization screwed around with the preset
// compression parameter.
compression2:pl.gcompression[];
ae[compression1; compression2];

// Exercise plscolor, plscol0, plscmap1, and plscmap1a to make sure
// they work without any obvious error messages.
pl.scolor[1];
pl.scol0[1; 255; 0; 0];
pl.scmap1[r1; g1; b1; 2];
pl.scmap1a[r1; g1; b1; a1; 2];

level2:pl.glevel[];
ae[level2; 1i];

pl.adv[0];
pl.vpor[0.01; 0.99; 0.02; 0.49];
vpd:pl.gvpd[];
ae[vpd`p_xmin; 0.01];
ae[vpd`p_xmax; 0.99];
ae[vpd`p_ymin; 0.02];
ae[vpd`p_ymax; 0.49];

xmid:0.5*((vpd`p_xmin) + vpd`p_xmax);
ymid:0.5*((vpd`p_ymin) + vpd`p_ymay);

pl.wind[0.2; 0.3; 0.4; 0.5];
vpw:pl.gvpw[];
ae[vpw`p_xmin; 0.2];
ae[vpw`p_xmax; 0.3];
ae[vpw`p_ymin; 0.4];
ae[vpw`p_ymax; 0.5];

// Get world coordinates for middle of viewport
w:pl.calc_world[xmid; ymid];
if[(abs[(w`wx) - 0.5 * ((w`xmin) + w`xmax)] > 1.0e-5) or abs[(w`wy) - 0.5 * ((w`ymin) + w`ymax)] > 1.0e-5; `fail];

// Retrieve and print the name of the output file (if any).
// This goes to stderr not stdout since it will vary between tests and
// we want stdout to be identical for compare test.
fnam:pl.gfnam[];
-1 string fnam;

// Set and get the number of digits used to display axis labels
// Note digits is currently ignored in pls[xyz]ax and
// therefore it does not make sense to test the returned
// value
pl.sxax[3; 0];
xax:pl.gxax[];
ae[xax`digmax; 3i];

pl.syax[4; 0];
yax:pl.gyax[];
ae[yax`digmax; 4i];

pl.szax[5; 0]
zax:pl.gzax[];
ae[zax`digmax; 5i];

pl.sdidev[0.05; pl`PL_NOTSET; 0.1; 0.2];
didev:pl.gdidev[];
ae[didev`p_mar; 0.05];
ae[didev`p_jx; 0.1];
ae[didev`p_jy; 0.2];

pl.sdiori 1.0;
diori:pl.gdiori[];
ae[diori; 1.0];

pl.sdiplt[0.1; 0.2; 0.9; 0.8];
diplt:pl.gdiplt[];
ae[diplt`p_xmin; 0.1];
ae[diplt`p_xmax; 0.9];
ae[diplt`p_ymin; 0.2];
ae[diplt`p_ymax; 0.8];

pl.sdiplz[0.1; 0.1; 0.9; 0.9];
dipltz:pl.gdiplt[];
ae[(abs[(dipltz`p_xmin) - ((diplt`p_xmin) + ((diplt`p_xmax) - diplt`p_xmin) * 0.1)] > 1.0e-5) or
         (abs[(dipltz`p_xmax) - ((diplt`p_xmin) + ((diplt`p_xmax) - diplt`p_xmin) * 0.9)] > 1.0e-5) or
         (abs[(dipltz`p_ymin) - ((diplt`p_ymin) + ((diplt`p_ymax) - diplt`p_ymin) * 0.1)] > 1.0e-5) or
         (abs[(dipltz`p_ymax) - ((diplt`p_ymin) + ((diplt`p_ymax) - diplt`p_ymin) * 0.9)] > 1.0e-5)];


pl.scolbg[10; 20; 30];
rgb0:(`r`g`b)!(10i;20i;30i);
rgb:pl.gcolbg[];
ae[rgb0; rgb];

pl.scolbga[20; 30; 40; 0.5];
rgba:pl.gcolbga[];
rgba0:(`r`g`b`a)!(20i;30i;40i;0.5);
ae[rgba0; rgba];
pl.end[];

\\
// $Id: x31c.c 11680 2011-03-27 17:57:51Z airwin $
//
// Copyright (C) 2008 Alan W. Irwin
// Copyright (C) 2008 Andrew Ross
//
// set/get tester
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
