//--------------------------------------------------------------------------
// main
//
// Displays the entire "plsym" symbol (font) set.
//--------------------------------------------------------------------------
\l qplplot.q
/pl.sdev`xwin;
pl.init[];


base:0 100 0 100 200 500 600 700 800 900 2000 2100 2200 2300 2400 2500 2600 2700 2800 2900;
pl.fontld[0];
l:0; while[l<20;
    $[l=2; pl.fontld[1];];
    pl.adv[0];
    // Set up viewport and window

    pl.col0[pl`yellow];
    pl.vpor[0.15; 0.95; 0.1; 0.9];
    pl.wind[0.0; 1.0; 0.0; 1.0];

    // Draw the grid using plbox

    pl.box[`$"bcg"; 0.1; 0; `$"bcg"; 0.1; 0];

    // Write the digits below the frame

    pl.col0[15];
    i:0; while[i<=9; pl.mtex[`$"b"; 1.5;(0.1 * i) + 0.05; 0.5; `$string i]; i+:1;];
    i:j:k:0; while[i<=9;
        // Write the digits to the left of the frame
        pl.mtex[`$"lv"; 1.0;0.95 - (0.1 * i); 1.0; `$string base[l] + 10 * i];
        j:0; while[j<=9;
            x0:(0.1 * j) + 0.05;
            y0:0.95 - (0.1 * i);

            // Display the symbols

            pl.sym[count x0; enlist x0; enlist y0; base[l] + k];
            j+:1; k+:1;];
        i+:1;];

    $[l<2;
        pl.mtex[`$"t"; 1.5; 0.5; 0.5; `$"PLplot Example 7 - PLSYM symbols (compact)"];
        pl.mtex[`$"t"; 1.5; 0.5; 0.5; `$"PLplot Example 7 - PLSYM symbols (extended)"]];
    l+:1;];
pl.end[];
\\
// $Id: x07c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Font demo.
//
