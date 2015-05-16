\l qplplot.q
M_PI:4*atan[1]

bor:{0b sv (0b vs x) | (0b vs y)}

plot1:{
    pl.adv 0;

    // Set up data for log plot

    f0:1.0;
    freql:-2.0+(til 101)%20.0;
    freq:xexp[10.0; freql];
    ampl:20.0*xlog[10; 1.0%sqrt[1.0+xexp[freq%f0; 2.]]];
    phase:neg (180.0%M_PI)*atan[freq%f0];

    pl.vpor[0.15; 0.85; 0.1; 0.9];
    pl.wind[-2.0; 3.0; -80.0; 0.0];

    // Try different axis and labelling styles.

    pl.col0 1;
    $[x=0; pl.box[`$"bclnst"; 0.0; 0i; `$"bnstv"; 0.0; 0i];
        x=1; pl.box[`$"bcfghlnst"; 0.0; 0i; `$"bcghnstv"; 0.0; 0i]];

    // Plot ampl vs freq

    pl.col0[pl`yellow];
    pl.line[101; freql; ampl];
    pl.col0[pl`yellow];
    pl.ptex[1.6; -30.0; 1.0; -20.0; 0.5; `$"-20 dB/decade"];

    // Put labels on

    pl.col0[pl`red];
    pl.mtex[`$"b"; 3.2; 0.5; 0.5; `$"Frequency"];
    pl.mtex[`$"t"; 2.0; 0.5; 0.5; `$"Single Pole Low-Pass Filter"];
    pl.col0[pl`yellow];
    pl.mtex[`$"l"; 5.0; 0.5; 0.5; `$"Amplitude (dB)"];
    nlegends:1i;

    // For the gridless case, put phase vs freq on same plot

    $[x=0; [pl.col0[pl`red]; pl.wind[-2.0; 3.0; -100.0; 0.0];
        pl.box[`$""; 0.0; 0; `$"cmstv"; 30.0; 3];
        pl.col0[pl`green]; pl.line[101; freql; phase];
        pl.string[101; freql; phase; `$"*"];
        pl.col0[pl`green]; pl.mtex[`$"r"; 5.0; 0.5; 0.5; `$"Phase shift (degrees)"];
        nlegends:2i];];

    PL_LEGEND_LINE:4i;
    PL_LEGEND_SYMBOL:8i;
    PL_LEGEND_BACKGROUND:32i;
    PL_LEGEND_BOUNDING_BOX:64i;

    opt_array:(PL_LEGEND_LINE; bor[PL_LEGEND_LINE; PL_LEGEND_SYMBOL]);
    text_colors:2 3i;
    text:`$("Amplitude";"Phase shift");
    line_colors:2 3i;
    line_styles:1 1i;
    line_widths:1 1f;
    symbol_colors:0 3i;
    symbol_scales:0 1f;
    symbol_numbers:0 4i;
    symbols:`,(`$"*");
    // from the above opt_arrays we can completely ignore everything
    // to do with boxes.

    pl.scol0a[15; 32; 32; 32; 0.7];
    pl.legend[(bor[PL_LEGEND_BACKGROUND; PL_LEGEND_BOUNDING_BOX]; 0i; 0.0; 0.0; 0.1); // x
       15 1 1i; // y
       (0i; 0i; nlegends); // z
       opt_array; //z4
       (1.0; 1.0; 2.0; 1.; text_colors; text); // z5
       ((0i;0i);(0i;0i);(0i;0i);(0i;0i)); // z6
       (line_colors; line_styles; line_widths); // z7
       (symbol_colors; symbol_scales; symbol_numbers; symbols)];} // z8

// Initialize plplot

pl.init[]
pl.font 2

// Make log plots using two different styles.

plot1 0
plot1 1
pl.end[]
\\
// $Id: x04c.c 11717 2011-04-21 00:47:06Z airwin $
//
//      Log plot demo.
//
