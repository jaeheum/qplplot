\l qplplot.q

red:0 255 0 0i;
green:0 0 255 0i;
blue:0 0 0 255i;
alpha:1.0 1.0 1.0 1.0;

px:0.1 0.5 0.5 0.1;
py:0.1 0.1 0.5 0.5;

pos:0.0 1.0;
rcoord:1.0 1.0;
gcoord:0.0 0.0;
bcoord:0.0 0.0;
acoord:0.0 1.0;
rev:0 0i;

pl.init[];
pl.scmap0n[4];
pl.scmap0a[red; green; blue; alpha; 4];

//
// Page 1:
//
// This is a series of red; green and blue rectangles overlaid
// on each other with gradually increasing transparency.
//

// Set up the window
pl.adv[0];
pl.vpor[0.0; 1.0; 0.0; 1.0];
pl.wind[0.0; 1.0; 0.0; 1.0];
pl.col0[0];
pl.box[`$""; 1.0; 0; `$""; 1.0; 0];

 // Draw the boxes

i:0; do[9;
    icol:(i mod 3) + 1;
    // Get a color; change its transparency and
    // set it as the current color.
    rgba:pl.gcol0a[icol];
    pl.scol0a[icol; rgba`r; rgba`g; rgba`b; 1.0 - i % 9.0];
    pl.col0[icol];

    // Draw the rectangle
    pl.fill[4; px; py];

    // Shift the rectangles coordinates
    j:0; do[4;
        px[j] +: (0.5 % 9.0);
        py[j] +: (0.5 % 9.0);
        j+:1];
    i+:1]

//
// Page 2:
//
// This is a bunch of boxes colored red; green or blue with a single
// large (red) box of linearly varying transparency overlaid. The
// overlaid box is completely transparent at the bottom and compl.etely
// opaque at the top.
//

// Set up the window
pl.adv[0];
pl.vpor[0.1; 0.9; 0.1; 0.9];
pl.wind[0.0; 1.0; 0.0; 1.0];

// Draw the boxes. There are 25 of them drawn on a 5 x 5 grid.
i:0; do[5;
    // Set box X position
    px[0]:0.05 + 0.2 * i;
    px[1]:px[0] + 0.1;
    px[2]:px[1];
    px[3]:px[0];

    // We don't want the boxes to be transparent; so since we changed
    // the colors transparencies in the first example we have to change
    // the transparencies back to completely opaque.
    icol:(i mod 3) + 1;
    rgba:pl.gcol0a[icol];
    pl.scol0a[icol; rgba`r; rgba`g; rgba`b; 1.0];
    pl.col0[icol];

    j:0; do[5;
        // Set box y position and draw the box.
        py[0]:0.05 + 0.2 * j;
        py[1]:py[0];
        py[2]:py[0] + 0.1;
        py[3]:py[2];
        pl.fill[4; px; py];
        j+:1];
    i+:1]

// Create the color map with 128 colors and use pl.scmap1la to initialize
// the color values with a linearly varying red transparency (or alpha)
pl.scmap1n[128];
pl.scmap1la[1b; 2; pos; rcoord; gcoord; bcoord; acoord; rev];

// Use that cmap1 to create a transparent red gradient for the whole
// window.
px:0. 1. 1. 0.;
py:0. 0. 1. 1.;
pl.gradient[4; px; py; 90.];

pl.end[];
\\
//
// Alpha color values demonstration.
//
// Copyright (C) 2008 Hazen Babcock
//
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
// This example will only really be interesting when used with devices that
// support or alpha (or transparency) values, such as the cairo device family.
//
