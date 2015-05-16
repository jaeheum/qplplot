\l qplplot.q

//--------------------------------------------------------------------------
// cmap1_init2
//
// Initializes color map 1 in HLS space.
//--------------------------------------------------------------------------

cmap1_init2:{
    i:h:l:s:4#0f;

    i[0]:0.;           // left boundary
    i[1]:0.45;        // just before center
    i[2]:0.55;        // just after center
    i[3]:1.;           // right boundary

    h[0]:260.;         // hue -- low: blue-violet
    h[1]:260.;         // only change as we go over vertex
    h[2]:20.;          // hue -- high: red
    h[3]:20.;          // keep fixed

    l[0]:0.6;         // lightness -- low
    l[1]:0.0;         // lightness -- center
    l[2]:0.0;         // lightness -- center
    l[3]:0.6;         // lightness -- high

    s[0]:1.;           // saturation -- low
    s[1]:0.5;         // saturation -- center
    s[2]:0.5;         // saturation -- center
    s[3]:1.;           // saturation -- high

    pl.scmap1l[0; 4; i; h; l; s; 4#0i];}

//--------------------------------------------------------------------------
// plot1
//
// Illustrates a single shaded region.
//--------------------------------------------------------------------------

plot1:{
    sh_cmap:min_color:max_color:0i;
    sh_width:min_width:max_width:0.;

    pl.adv[0];
    pl.vpor[0.1; 0.9; 0.1; 0.9];
    pl.wind[-1.0; 1.0; -1.0; 1.0];

// Plot using identity transform

    shade_min:zmin + (zmax - zmin) * 0.4;
    shade_max:zmin + (zmax - zmin) * 0.6;
    sh_color :7.; / N.B. should be a float, not an int.
    sh_width :2.;
    min_color:9i;
    max_color:2i;
    min_width:2.;
    max_width:2.;

    pl.psty[8];
    pl.shade1[zm; 0; (-1.; 1.; -1.; 1.; shade_min; shade_max);
        (sh_cmap; sh_color; sh_width; min_color; min_width; max_color; max_width);
        0; 1; 0];

    pl.col0[1];
    pl.box[`$"bcnst"; 0.0; 0; `$"bcnstv"; 0.0; 0];
    pl.col0[2];
    pl.lab[`$"distance"; `$"altitude"; `$"Bogon flux"]}

//--------------------------------------------------------------------------
// plot2
//
// Illustrates multiple adjacent shaded regions, using different fill
// patterns for each region.
//--------------------------------------------------------------------------
plot2:{
    sh_cmap:min_color:max_color:0i;
    sh_width:min_width:max_width:0.;
    nlin:`int$(1; 1; 1; 1; 1; 2; 2; 2; 2; 2);
    inc:`int$((450;    0); (neg 450;    0); (0;   0); (900;   0); (300;    0); (450; neg 450); (0; 900); (0; 450); (450; neg 450); (0;  900));
    del:`int$((2000; 2000); (2000; 2000); (2000; 2000); (2000; 2000); (2000; 2000);
            (2000; 2000); (2000; 2000); (2000; 2000); (4000; 4000); (4000; 2000));

    sh_width:2.;

    pl.adv[0];
    pl.vpor[0.1; 0.9; 0.1; 0.9];
    pl.wind[-1.0; 1.0; -1.0; 1.0];


// Plot using identity transform

    i:0; do[10;
        shade_min:zmin + (zmax - zmin) * i % 10.0;
        shade_max:zmin + (zmax - zmin) * (i + 1) % 10.0;
        sh_color:i + 6.; / N.B. sh_color is a float.
        pl.pat[nlin[i]; inc[i]; del[i]];

        pl.shade1[zm; 0N; (-1.; 1.; -1.; 1.; shade_min; shade_max);
            (sh_cmap; sh_color; sh_width; min_color; min_width; max_color; max_width);
            0N; 1; 0N];
        i+:1];

    pl.col0[1];
    pl.box[`$"bcnst"; 0.0; 0; `$"bcnstv"; 0.0; 0];
    pl.col0[2];
    pl.lab[`$"distance"; `$"altitude"; `$"Bogon flux"]}

//--------------------------------------------------------------------------
// plot3
//
// Illustrates shaded regions in 3d; using a different fill pattern for
// each region.
//--------------------------------------------------------------------------

plot3:{
    xx:((-1.0; 1.0; 1.0; -1.0; -1.0); (-1.0; 1.0; 1.0; -1.0; -1.0));
    yy:((1.0;  1.0; 0.0; 0.0;  1.0); (-1.0; -1.0; 0.0; 0.0; -1.0));
    zz:((0.0; 0.0; 1.0; 1.0; 0.0); (0.0; 0.0; 1.0; 1.0; 0.0));

    pl.adv[0];
    pl.vpor[0.1; 0.9; 0.1; 0.9];
    pl.wind[-1.0; 1.0; -1.0; 1.0];
    / N.B. pl.w3d[] takes three args, not 11 like plw3d().
    pl.w3d[(1.; 1.; 1.); (-1.0; 1.0; -1.0; 1.0; 0.0; 1.5); (30.; -40.)];

// Plot using identity transform

    pl.col0[1];
    / N.B. pl.box3[] takes three args, not 12 like plbox3().
    pl.box3[(`$"bntu"; `$"X"; 0.0; 0i); (`$"bntu"; `$"Y"; 0.0; 0i); (`$"bcdfntu"; `$"Z"; 0.5; 0i)];
    pl.col0[2];
    pl.lab[`$""; `$""; `$"3-d polygon filling"];

    pl.col0[3];
    pl.psty[1];
    pl.line3[5; xx[0]; yy[0]; zz[0]];
    pl.fill3[4; xx[0]; yy[0]; zz[0]];
    pl.psty[2];
    pl.line3[5; xx[1]; yy[1]; zz[1]];
    pl.fill3[4; xx[1]; yy[1]; zz[1]]}


// Set up color map 0
//
//  plscmap0n(3);
//
// Set up color map 1

cmap1_init2[];

// Initialize plplot

pl.init[];

// Set up data array
XPTS:35i;
YPTS:46i;
zm:(flip enlist XPTS#0f)$(enlist YPTS#0f);

i:0; do[XPTS;
    xx:(i - (XPTS div 2)) % (XPTS div 2);
    j:0; do[YPTS;
        yy:((j - (YPTS div 2)) % (YPTS div 2)) - 1.0;
        / N.B. x-y+z in C is (x-y)+z in q.
        .[`zm; (i;j); :; ((xx * xx) - (yy * yy)) + (xx - yy) % ((xx * xx) + (yy * yy) + 0.1)];
        j+:1];
    i+:1];

zmax:max raze zm;
zmin:min raze zm;

plot1[];
plot2[];
plot3[];

pl.end[];
\\
// $Id: x15c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Shade plot demo.
//
//      Maurice LeBrun
//      IFS, University of Texas at Austin
//      31 Aug 1993
//
