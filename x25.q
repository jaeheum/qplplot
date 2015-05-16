\l qplplot.q

// Parse and process command line arguments

// (void) plparseopts( &argc, argv, PL_PARSE_FULL );

// Initialize plplot

pl.ssub[3;3]
pl.init[];
xextreme:yextreme:`float$();
x0:y0:`float$();

xextreme:flip`float$(neg(120; 120; 120; 80; 220; 20; 20; 80; neg 20); (120; 120; 120; 80; 120; 20; 20; 80; 120));
yextreme:flip`float$(neg(120; (neg 20); 20; 20; 120; 120; 20; 80; 120); (120; 120; 120; 120; 120; 120; 20; 80; 120));

k:0; do[2;
    j:0; do[4;
        if[j=0;
// Polygon 1: a diamond
            x0:`float$(0; (neg 100); 0; 100); y0:`float$((neg 100); 0; 100; 0); npts:4];
// Polygon 1: a diamond - reverse direction
        if[j=1;
            x0:`float$(100; 0; (neg 100); 100); y0:`float$(0; 100; 0; (neg 100)); npts:4];
        if[j=2;
// Polygon 2: a square with punctures
            x0:`float$((neg 100); (neg 100); 80;(neg 100); (neg 100); (neg 80); 0; 80; 100; 100);
            y0:`float$((neg 100); (neg 80); 0; 80; 100; 100; 80; 100; 100; (neg 100));
            npts:10];
        if[j=3;
// Polygon 2: a square with punctures - reversed direction
            x0:`float$(100; 100; 80; 0; (neg 80); (neg 100); (neg 100); 80; (neg 100); (neg 100));
            y0:`float$((neg 100); 100; 100; 80; 100; 100; 80; 0; (neg 80); (neg 100));
            npts:10];

        i:0; do[9;
            pl.adv[0];
            pl.vsta[];
            pl.wind[xextreme[i][0]; xextreme[i][1]; yextreme[i][0]; yextreme[i][1]];

            pl.col0[pl`yellow];
            pl.box[`$"bc"; 1.0; 0; `$"bcnv"; 10.0, 0];
            pl.col0[pl`red];
            pl.psty[0];
            $[k=0;
                pl.fill[npts; x0; y0];
                pl.gradient[npts; x0; y0; 45.]];
            pl.col0[pl`yellow];
            pl.lsty[1];
            pl.line[npts; x0; y0];
            i+:1];
        j+:1];
    k+:1];

// Don't forget to call plend() to finish off!

pl.end[];
\\
// $Id: x25c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Filling and clipping polygons.
//
