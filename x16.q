\l qplplot.q

// Fundamental settings.  See notes[] for more info.

ns:20i;        // Default number of shade levels
nx:35i;        // Default number of data points in x
ny:46i;        // Default number of data points in y
exclude:0i;         // By default do not plot a page illustrating
                                // exclusion.  API is probably going to change
                                // anyway, and cannot be reproduced by any
                                // front end other than the C one.

// For now, don't show the colorbars while we are working out the API.
colorbar:1i;

// polar plot data
PERIMETERPTS:100i

// Transformation function
mypltr:{[x; y; z] z:0N; tx:(tr[0]*x)+(tr[1]*y)+tr[2]; ty:(tr[3]*x)+(tr[4]*y)+tr[5]; (tx;ty)}

// defined
zdefined:{a:sqrt[(x*x)+y*y]; `int$((a < 0.4) or a > 0.6)}

// Does several shade plots using different coordinate mappings.
//--------------------------------------------------------------------------
fill_width:2f;
cont_width:0f;
cont_color:0i;

n_axis_opts:NUM_AXES:1i;
axis_opts:enlist `$"bcvtm";
axis_ticks:enlist 0f;
axis_subticks:enlist 0i;
n_labels:NUM_LABELS:1i;
label_opts:enlist pl`PL_COLORBAR_LABEL_BOTTOM;
labels:enlist `$"Magnitude";

// Load colour palettes
pl.spal0[`$"cmap0_black_on_white.pal"];
pl.spal1[`$"cmap1_gray.pal"; 1i];
// Reduce colors in cmap 0 so that cmap 1 is useful on a 16-color display
pl.scmap0n[3i]
// Initialize plplot
pl.init[];

// Set up transformation function
tr:6#0f;
tr[0]:2. % (nx - 1);
tr[1]:0.0;
tr[2]:neg 1.0;
tr[3]:0.0;
tr[4]:2. % (ny - 1);
tr[5]:neg 1.0;

// Allocate data structures

clevel:nx#0f;
shedge:(ns+1)#0f;
xg1:nx#0f;
yg1:ny#0f;
z:w:(flip enlist nx#0f)$(enlist ny#0f);

// Set up data array

i:0; do[nx;
    xi:(i - (nx%2))%(nx%2);
    j:0; do[ny;
        yj:((j-(ny%2))%(ny%2)) - 1.0;
        .[`z; (i;j); :; (neg sin[7. * xi] * cos[7. * yj]) + (xi*xi) - (yj*yj)];
        .[`w; (i;j); :; (neg cos[7. * xi] * sin[7. * yj]) + 2*xi*yj];
        j+:1];
    i+:1];
zmin:min raze z;
zmax:max raze z;
clevel:zmin + (zmax - zmin)*(0.5 + til ns)%ns;
shedge:zmin + (zmax - zmin)*(til ns+1)%ns;

// Set up coordinate grids

xg2:yg2:(flip enlist nx#0f)$(enlist ny#0f);

i:0; do[nx;
    j:0; do[ny;
        txty:mypltr[`float$i; `float$j; 0N];
        tx:txty 0;
        ty:txty 1;
        argx:tx * M_PI % 2;
        argy:ty * M_PI % 2;
        distort:0.4;

        xg1[i]:tx + distort * cos[argx];
        yg1[j]:ty - distort * cos[argy];

        .[`xg2; (i;j); :; tx + distort * cos[argx] * cos[argy]];
        .[`yg2; (i;j); :; ty - distort * cos[argx] * cos[argy]];
        j+:1];
    i+:1];

// Plot using identity transform

pl.adv[0];
pl.vpor[0.1; 0.9; 0.1; 0.9];
pl.wind[neg 1.0; 1.0; neg 1.0; 1.0];
pl.psty[0];

rectangular:1i;

pl.shades[z; 0; (-1f; 1f; -1f; 1f; shedge); (fill_width; cont_color; cont_width); 0; rectangular; 0];

if[colorbar;
    // Smaller text
    pl.schr[0.0; 0.75];
    // Small ticks on the vertical axis
    pl.smaj[0.0; 0.5];
    pl.smin[0.0; 0.5];

    num_values:enlist ns + 1i;
    values:enlist shedge;

   / N.B. plcolorbar() requires 24 arguments (2 for output, 22 for input).
   / Use a dict hack to pack the 22 input arguments from pl.colorbar[] to plcolorbar().
    cbk:`opt`position`x`y`x_length`y_length`bg_color`bb_color`bb_style`low_cap_color`high_cap_color`cont_color`cont_width`n_labels`label_opts`labels`n_axes`axis_opts`ticks`sub_ticks`n_values`values;
    cbv:(bor[pl`PL_COLORBAR_SHADE; pl`PL_COLORBAR_SHADE_LABEL]; 0i;
        0.005; 0.0; 0.0375; 0.875; 0i; 1i; 1i; 0.0; 0.0;
        cont_color; cont_width;
        n_labels; label_opts; labels;
        n_axis_opts; axis_opts;
        axis_ticks; axis_subticks;
        num_values; values);
    wh:pl.colorbar[cbk!cbv];

    // Reset text and tick sizes
    pl.schr[0.0; 1.0];
    pl.smaj[0.0; 1.0];
    pl.smin[0.0; 1.0]];

pl.col0[pl`red];
pl.box[`$"bcnst"; 0.0; 0; `$"bcnstv"; 0.0; 0];
pl.col0[pl`yellow];

pl.lab[`$"distance"; `$"altitude"; `$"Bogon density"];

// Plot using 1d coordinate transform

// Load colour palettes
pl.spal0[`$"cmap0_black_on_white.pal"];
pl.spal1[`$"cmap1_blue_yellow.pal"; 1];
// Reduce colors in cmap 0 so that cmap 1 is useful on a 16-color display
pl.scmap0n[3];

pl.adv[0];
pl.vpor[0.1; 0.9; 0.1; 0.9];
pl.wind[-1.0; 1.0; -1.0; 1.0];

pl.psty[0];

pl.shades1[z; 0; (-1f; 1f; -1f; 1f; shedge); (fill_width; cont_color; cont_width); 0; rectangular; xg1; yg1];

if[colorbar;
    // Smaller text
    pl.schr[0.0; 0.75];
    // Small ticks on the vertical axis
    pl.smaj[0.0; 0.5];
    pl.smin[0.0; 0.5];

    num_values:enlist ns + 1i;
    values:enlist shedge;
    cbk:`opt`position`x`y`x_length`y_length`bg_color`bb_color`bb_style`low_cap_color`high_cap_color`cont_color`cont_width`n_labels`label_opts`labels`n_axes`axis_opts`ticks`sub_ticks`n_values`values;
    cbv:(bor[pl`PL_COLORBAR_SHADE; pl`PL_COLORBAR_SHADE_LABEL]; 0i;
        0.005; 0.0; 0.0375; 0.875; 0i; 1i; 1i; 0.0; 0.0;
        cont_color; cont_width;
        n_labels; label_opts; labels;
        n_axis_opts; axis_opts;
        axis_ticks; axis_subticks;
        num_values; values);
    wh:pl.colorbar[cbk!cbv];

    // Reset text and tick sizes
    pl.schr[0.0; 1.0];
    pl.smaj[0.0; 1.0];
    pl.smin[0.0; 1.0]];

pl.col0[pl`red];
pl.box[`$"bcnst"; 0.0; 0; `$"bcnstv"; 0.0; 0];
pl.col0[pl`yellow];

pl.lab[`$"distance"; `$"altitude"; `$"Bogon density"];

// Plot using 2d coordinate transform

// Load colour palettes
pl.spal0[`$"cmap0_black_on_white.pal"];
pl.spal1[`$"cmap1_blue_red.pal"; 1];
// Reduce colors in cmap 0 so that cmap 1 is useful on a 16-color display
pl.scmap0n[3];

pl.adv[0];
pl.vpor[0.1; 0.9; 0.1; 0.9];
pl.wind[-1.0; 1.0; -1.0; 1.0];

pl.psty[0];

pl.shades2[z; 0; (-1f; 1f; -1f; 1f; shedge); (fill_width; cont_color; cont_width); 0; 0; xg2; yg2];

if[colorbar;
    // Smaller text
    pl.schr[0.0; 0.75];
    // Small ticks on the vertical axis
    pl.smaj[0.0; 0.5];
    pl.smin[0.0; 0.5];

    num_values:enlist ns + 1i;
    values:enlist shedge;
    cbk:`opt`position`x`y`x_length`y_length`bg_color`bb_color`bb_style`low_cap_color`high_cap_color`cont_color`cont_width`n_labels`label_opts`labels`n_axes`axis_opts`ticks`sub_ticks`n_values`values;
    cbv:(bor[pl`PL_COLORBAR_SHADE; pl`PL_COLORBAR_SHADE_LABEL]; 0i;
        0.005; 0.0; 0.0375; 0.875; 0i; 1i; 1i; 0.0; 0.0;
        cont_color; cont_width;
        n_labels; label_opts; labels;
        n_axis_opts; axis_opts;
        axis_ticks; axis_subticks;
        num_values; values);
    wh:pl.colorbar[cbk!cbv];

    // Reset text and tick sizes
    pl.schr[0.0; 1.0];
    pl.smaj[0.0; 1.0];
    pl.smin[0.0; 1.0]];

pl.col0[pl`red];
pl.box[`$"bcnst"; 0.0; 0; `$"bcnstv"; 0.0; 0];
pl.col0[pl`yellow];
pl.cont2[w; (1i; nx); (1i; ny); clevel; xg2; yg2];

pl.lab[`$"distance"; `$"altitude"; `$"Bogon density, with streamlines"];

// Plot using 2d coordinate transform

// Load colour palettes
pl.spal0[`$""];
pl.spal1[`$""; 1];
// Reduce colors in cmap 0 so that cmap 1 is useful on a 16-color display
pl.scmap0n[3];

pl.adv[0];
pl.vpor[0.1; 0.9; 0.1; 0.9];
pl.wind[-1.0; 1.0; -1.0; 1.0];

pl.psty[0];

pl.shades2[z; 0; (-1f; 1f; -1f; 1f; shedge); (fill_width; cont_color:2i; cont_width:3f); 0; 0; xg2; yg2];

if[colorbar;
    // Smaller text
    pl.schr[0.0; 0.75];
    // Small ticks on the vertical axis
    pl.smaj[0.0; 0.5];
    pl.smin[0.0; 0.5];

    num_values:enlist ns + 1i;
    values:enlist shedge;
    cbk:`opt`position`x`y`x_length`y_length`bg_color`bb_color`bb_style`low_cap_color`high_cap_color`cont_color`cont_width`n_labels`label_opts`labels`n_axes`axis_opts`ticks`sub_ticks`n_values`values;
    cbv:(bor[pl`PL_COLORBAR_SHADE; pl`PL_COLORBAR_SHADE_LABEL]; 0i;
        0.005; 0.0; 0.0375; 0.875; 0i; 1i; 1i; 0.0; 0.0;
        cont_color; cont_width;
        n_labels; label_opts; labels;
        n_axis_opts; axis_opts;
        axis_ticks; axis_subticks;
        num_values; values);
    wh:pl.colorbar[cbk!cbv];

    // Reset text and tick sizes
    pl.schr[0.0; 1.0];
    pl.smaj[0.0; 1.0];
    pl.smin[0.0; 1.0]];

pl.col0[pl`red];
pl.box[`$"bcnst"; 0.0; 0; `$"bcnstv"; 0.0; 0];
pl.col0[pl`yellow];
/ pl.cont2[w; (1i; nx); (1i; ny); clevel; xg2; yg2];

pl.lab[`$"distance"; `$"altitude"; `$"Bogon density"];

// Note this exclusion API will probably change.

// Plot using 2d coordinate transform and exclusion

if[exclude;
    // Load colour palettes
    pl.spal0["cmap0_black_on_white.pal"];
    pl.spal1["cmap1_gray.pal"; 1];
    // Reduce colors in cmap 0 so that cmap 1 is useful on a 16-color displ.ay
    pl.scmap0n[3];

    pl.adv[0];
    pl.vpor[0.1; 0.9; 0.1; 0.9];
    pl.wind[-1.0; 1.0; -1.0; 1.0];

    pl.psty[0];
    pl.shades2[z; zdefined; (-1f; 1f; -1f; 1f; shedge); (fill_width; cont_color:2i; cont_width:3f); 0; 0; xg2; yg2];

    pl.col0[1];
    pl.box["bcnst"; 0.0; 0; "bcnstv"; 0.0; 0];

    pl.lab["distance"; "altitude"; "Bogon density with exclusion"]];

// Example with polar coordinates.

// Load colour palettes
pl.spal0[`$"cmap0_black_on_white.pal"];
pl.spal1[`$"cmap1_gray.pal"; 1];
// Reduce colors in cmap 0 so that cmap 1 is useful on a 16-color displ.ay
pl.scmap0n[3];

pl.adv[0];
pl.vpor[.1, .9, .1, .9];
pl.wind[-1., 1., -1., 1.];


pl.psty[0];

// Build new coordinate matrices.

i:0; do[nx;
    r:i % (nx - 1);
    j:0; do[ny;
        t:(2. * M_PI % ( ny - 1. )) * j;
        .[`xg2; (i;j); :; r * cos[t]];
        .[`yg2; (i;j); :; r * sin[t]];
        .[`z; (i;j); :; exp[neg r * r ] * cos[5. * M_PI * r] * cos[5. * t]];
        j+:1];
    i+:1];

// Need a new shedge to go along with the new data set.
zmin:min raze z;
zmax:max raze z;
shedge:zmin + (zmax - zmin) * (til ns+1i) % ns;

//  Now we can shade the interior region.
pl.shades2[z; 0; (-1f; 1f; -1f; 1f; shedge); (fill_width; cont_color:0i; cont_width:0f); 0; 0; xg2; yg2];

if[colorbar;
    // Smaller text
    pl.schr[0.0; 0.75];
    // Small ticks on the vertical axis
    pl.smaj[0.0; 0.5];
    pl.smin[0.0; 0.5];

    num_values:enlist ns + 1i;
    values:enlist shedge;
    cbk:`opt`position`x`y`x_length`y_length`bg_color`bb_color`bb_style`low_cap_color`high_cap_color`cont_color`cont_width`n_labels`label_opts`labels`n_axes`axis_opts`ticks`sub_ticks`n_values`values;
    cbv:(bor[pl`PL_COLORBAR_SHADE; pl`PL_COLORBAR_SHADE_LABEL]; 0i;
        0.005; 0.0; 0.0375; 0.875; 0i; 1i; 1i; 0.0; 0.0;
        cont_color; cont_width;
        n_labels; label_opts; labels;
        n_axis_opts; axis_opts;
        axis_ticks; axis_subticks;
        num_values; values);
    wh:pl.colorbar[cbk!cbv];

    // Reset text and tick sizes
    pl.schr[0.0; 1.0];
    pl.smaj[0.0; 1.0];
    pl.smin[0.0; 1.0]]

// Now we can draw the perimeter.  (If do before, shade stuff may overlap.)
t:(2. * M_PI % ( PERIMETERPTS - 1)) * til PERIMETERPTS;
px:sin[t];
py:cos[t];
pl.col0[pl`red];
pl.line[PERIMETERPTS; px; py];

// And label the plot.

pl.col0[pl`yellow];
pl.lab[`$""; `$""; `$"Tokamak Bogon Instability"];


// Clean up

pl.end[];
\\
// $Id: x16c.c 11767 2011-06-13 16:16:57Z airwin $
//
//      plshade demo, using color fill.
//
//      Maurice LeBrun
//      IFS, University of Texas at Austin
//      20 Mar 1994
//
