\l qplplot.q
cmap1_init:{
    i:0.0 1.0;         // left boundary; right boundary
    h:240 0f;        // blue -> green -> yellow -> ; -> red
    l:0.6 0.6;
    s:0.8 0.8;
    pl.scmap1n[256];
    pl.scmap1l[0i; 2i; i; h; l; s; 0 0i]}

create_grid:{[px; py]
    xg::xm + (xM - xm) * (til px) % (px - 1.);
    yg::ym + (yM - ym) * (til py) % (py - 1.)}

create_data:{[npts]
    i:0; do[npts;
        xt:(xM - xm) * pl.randd[];
        yt:(yM - ym) * pl.randd[];
        $[not randn; [x_[i]::xt + xm; y_[i]::yt + ym];
            [x_[i]::(sqrt[neg 2. * log[xt]] * cos[2. * M_PI * yt]) + xm;
             y_[i]::(sqrt[neg 2. * log[xt]] * cos[2. * M_PI * yt]) + ym]];
        $[not rosen;
            [r:sqrt[(x_[i]*x_[i]) + (y_[i] * y_[i])]; z_[i]::exp[neg r * r] * cos[2.0 * M_PI * r]];
            [z_[i]::log[xexp[1. - x_[i]; 2.]+ 100. * xexp[y_[i] - xexp[x_[i]; 2.]; 2.]]]];
        i+:1]}

title:(`$"Cubic Spline Approximation";
    `$"Delaunay Linear Interpolation";
    `$"Natural Neighbors Interpolation";
    `$"KNN Inv. Distance Weighted";
    `$"3NN Linear Interpolation";
    `$"4NN Around Inv. Dist. Weighted");
opt:(0.; 0.; 0.; 0.; 0.; 0.);

xm:ym:-0.2;
xM:yM:0.6;

pts:500i;
xp:25i;
yp:20i;
nl:16i;
knn_order:20i
threshold:1.001;
wmin:-1e3;
randn:0i
rosen:0i

opt[2]:wmin;
opt[3]:`float$knn_order;
opt[4]:threshold;

// Initialize plplot

pl.init[];

// Use a colour map with no black band in the middle.
cmap1_init[];
// Initialise random number generator
pl.seed[5489];

x_:y_:z_:pts#0f;
create_data[pts];

zmin:min z_;
zmax:max z_;

xg:xp#0f;
yg:yp#0f;
create_grid[xp; yp]; // grid the data at
zg:(flip enlist xg)$(enlist yg);
clev:nl#0f;

pl.col0[1];
pl.env[xm; xM; ym; yM; 2; 0];
pl.col0[15];
pl.lab[`$"X"; `$"Y"; `$"The original data sampling"];
i:0; do[pts;
    pl.col1[(z_[i] - zmin) % (zmax - zmin)];
    // The following plstring call should be the the equivalent of
    // plpoin( 1, &x[i], &y[i], 5 ); Use plstring because it is
    // not deprecated like plpoin and has much more powerful
    // capabilities.  N.B. symbol 141 works for Hershey devices
    // (e.g., -dev xwin) only if plfontld( 0 ) has been called
    // while symbol 727 works only if plfontld( 1 ) has been
    // called.  The latter is the default which is why we use 727
    // here to represent a centred X (multiplication) symbol.
    // This dependence on plfontld is one of the limitations of
    // the Hershey escapes for PLplot, but the upside is you get
    // reasonable results for both Hershey and Unicode devices.
    / N.B. notice pl.string's first argument of 1 because we are
    / passing in (x,y) pair at a time (hence enlist, not just x_;y_).
    pl.string[1; enlist x_[i]; enlist y_[i]; `$"#(727)"];
    i+:1];

pl.adv[0];
pl.ssub[3; 2];

k:0; do[2;
    pl.adv[0];
    alg:1; do[6;
        zg:pl.griddata[x_; y_; z_; xg; yg; alg; opt[alg - 1]];

        // - CSA can generate NaNs (only interpolates?!).
        // - DTLI and NNI can generate NaNs for points outside the convex hull
        //      of the data points.
        // - NNLI can generate NaNs if a sufficiently thick triangle is not found
        //
        // PLplot should be NaN/Inf aware, but changing it now is quite a job...
        // so, instead of not plotting the NaN regions, a weighted average over
        // the neighbors is done.
        //

        if[alg in (pl`GRID_CSA; pl`GRID_DTLI; pl`GRID_NNLI; pl`GRID_NNI);
            i:0; do[xp;
                j:0; do[yp;
                    if[null zg[i][j]; // average (IDW) over the 8 neighbors
                        zg:.[zg; (i;j); :; 0.]; dist:0.;
                        ii:i - 1; do[3;
                            jj:j - 1; do[3;
                                if[(ii >= 0) and (jj >= 0) and not null zg[ii][jj];
                                    d:$[(abs[ii - i] + abs[jj - j])=1; 1.; 1.4142];
                                    zg:.[zg; (i;j); +; zg[ii][jj] % (d * d)];
                                    dist+:d];
                                jj+:1];
                            ii+:1];
                        $[not dist = 0.;
                            zg:.[zg; (i;j); %; dist];
                            zg:.[zg; (i;j); :; zmin]]];
                    j+:1];
                i+:1]];

        lzm:min raze zg;
        lzM:max raze zg;
        lzm:min (lzm; zmin);
        lzM:max (lzM; zmax);

        // Increase limits slightly to prevent spurious contours
        // due to rounding errors
        lzm:lzm - 0.01;
        lzM:lzM + 0.01;

        pl.col0[1];

        pl.adv[alg];

        $[k=0;
            [clev:lzm + ((lzM - lzm) % (nl - 1)) * (til nl);
                pl.env0[xm; xM; ym; yM; 2; 0];
                pl.col0[15];
                pl.lab[`$"X"; `$"Y"; title[alg - 1]];
                pl.shades[zg; 0N; (xm; xM; ym; yM; clev); (1.; 0i; 1.); 0; 1; 0];
                pl.col0[2]];
            [clev:lzm + ((lzM - lzm) % (nl - 1)) * (til nl);
                pl.vpor[0.0; 1.0; 0.0; 0.9];
                pl.wind[-1.1; 0.75; -0.65; 1.20];
                //
                // For the comparison to be fair; all plots should have the
                // same z values; but to get the max/min of the data generated
                // by all algorithms would imply two passes. Keep it simple.
                //
                // plw3d(1.; 1.; 1.; xm; xM; ym; yM; zmin; zmax; 30; -60);
                //

                / N.B. note arity of pl.w3d, pl.box3 and pl.ot3dc.
                pl.w3d[(1.; 1.; 1.); (xm; xM; ym; yM; lzm; lzM); (30f; -40f)];
                pl.box3[(`$"bntu"; `$"X"; 0.; 0i);
                    (`$"bntu"; `$"Y"; 0.; 0i);
                    (`$"bcdfntu"; `$"Z"; 0.5; 0i)];
                pl.col0[15];
                pl.lab[`$""; `$""; title[alg - 1]];
                pl.ot3dc[xg; yg; zg; xp; yp; bor[bor[pl`DRAW_LINEXY; pl`MAG_COLOR]; pl`BASE_CONT]; clev; nl]]];
        alg+:1];
    k+:1];

pl.end[];
\\
// $Id: x21c.c 11680 2011-03-27 17:57:51Z airwin $
//      Grid data demo
//
// Copyright (C) 2004  Joao Cardoso
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
