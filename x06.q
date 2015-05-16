\l qplplot.q
NPTS:2047
PI:4*atan 1
delta:2*PI%NPTS
// Initialize plplot
pl.init[]
kind_font:0;
do[2;
    pl.fontld[kind_font];
    $[kind_font=0; maxfont:1; maxfont:4];
    font:0;
    do[maxfont;
        pl.font[font+1];
        pl.adv 0;
        // Set up viewport and window
        pl.col0 2;
        pl.vpor[0.1; 1.0; 0.1; 0.9];
        pl.wind[0.0; 1.0; 0.0; 1.3];
        // Draw the grid using plbox
        pl.box[`$"bcg"; 0.1; 0; `$"bcg"; 0.1; 0];
        // Write the digits below the frame
        pl.col0[15];
        i:0; do[9+1;
            pl.mtex[`$"b"; 1.5; 0.05+0.1*i; 0.5; `$string i];
            i+:1];
        k:0;
        i:0; do[12+1;
            // Write the digits to the left of the frame
            pl.mtex[`$"lv"; 1.0; (1.0-(1+2*i)%26.0); 1.0; `$string 10*i];
            j:0; do[9+1;
                xi:0.05+0.1*j;
                yi:1.25-0.1*i;
                j+:1;
                // Display the symbols (plpoin expects that x and y are arrays so
                // pass pointers)
                / N.B. from q, pass arrays that will get converted to pointers in plplot.
                if[k<128; pl.poin[1; enlist xi; enlist yi; k]];
                k+:1]; i+:1];
        $[kind_font=0;
            pl.mtex[`$"t"; 1.5; 0.5; 0.5; `$"PLplot Example 6 - plpoin symbols (compact)"];
            pl.mtex[`$"t"; 1.5; 0.5; 0.5; `$"PLplot Example 6 - plpoin symbols (extended)"]];
        font+:1];
    kind_font+:1];

pl.end[]
\\
// $Id: x06c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Font demo.
//
