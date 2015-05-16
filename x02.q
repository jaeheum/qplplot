\l qplplot.q
dtr:4*atan[1]%180
draw_windows:{[nw; cmap0_offset]
    pl.schr[0f; 3.5];
    pl.font 4;
    i:0; do[nw;
        pl.col0[i+cmap0_offset];
        text:string i;
        pl.adv 0;
        vmin:0.1;
        vmax:0.9;
        j:0; do[3; pl.width[j+1f]; pl.vpor[vmin; vmax; vmin; vmax]; pl.wind[0.0; 1.0; 0.0; 1.0]; pl.box[`bc; 0.0; 0; `bc; 0.0; 0]; vmin+:0.1; vmax+:0.1; j+:1];
        pl.width[1f];
        pl.ptex[0.5; 0.5; 1.0; 0.0; 0.5; `$text]; i+:1]}

demo1:{pl.box[];
    // Divide screen into 16 regions
    pl.ssub[4;4]; draw_windows[16;0]; pl.eop[]}
//--------------------------------------------------------------------------
// demo2
//
// Demonstrates multiple windows, user-modified color map 0 palette, and
// HLS -> RGB translation.
//--------------------------------------------------------------------------
demo2:{pl.bop[];
    // Set up cmap0
    // Use 100 custom colors in addition to base 16
    r:g:b:116#0i;

    // Min & max lightness values
    lmin:0.15; lmax:0.85;

    pl.bop[];

    // Divide screen into 100 regions
    pl.ssub[10;10];

    i:0; do[100;
        // Bounds on HLS, from plhlsrgb() commentary --
        //      hue             [0., 360.]      degrees
        //      lightness       [0., 1.]        magnitude
        //      saturation      [0., 1.]        magnitude
        //

        // Vary hue uniformly from left to right
        h:(360.%10.)*(i mod 10);
        // Vary lightness uniformly from top to bottom, between min & max
        l:lmin+(lmax-lmin)*(i%10)%9.;
        // Use max saturation
        s:1.0;

        rgb1:pl.hlsrgb[h; l; s];
        // r1:rgb1 0; g1:rgb1 1; b1: rgb1 2;

        // Use 255.001 to avoid close truncation decisions in this example.
        r[i+16]:`int$(rgb1`p_r)*255.001;
        b[i+16]:`int$(rgb1`p_b)*255.001;
        g[i+16]:`int$(rgb1`p_g)*255.001;
        i+:1];

// Load default cmap0 colors into our custom set
    i:0i; do[16; rgb2:pl.gcol0[i];
        r[i]:rgb2`r; b[i]:rgb2`b; g[i]: rgb2`g;
        i+:1];

// A more q like way, without scalar do loops.
/   h:(360.%10.)*(til 100)%10;
/   l:lmin +(lmax-lmin)*((til 100)%10)%9.;
/   s:100#1f;
/   rgb1:pl.hlsrgb . flip(h;l;s);
/   rgb2:each[pl.gcol] til 16i;
/   rgb:flip(rgb2,rgb1)
/   r:`int$rgb`p_r; g:`int$rgb`p_g; b:`int$rgb`p_b;

    pl.scmap0[`int$r; `int$g; `int$b; 116];

    draw_windows[100; 16];

    pl.eop[]}

pl.init[]
demo1[]
demo2[]
pl.end[]
\\
// $Id: x02c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Multiple window and color map 0 demo.
//
