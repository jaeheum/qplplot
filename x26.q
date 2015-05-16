\l qplplot.q
M_PI:4*atan[1]

bor:{0b sv (0b vs x) | (0b vs y)}
x_label:(`$"Frequency"; `$"Частота");
y_label:(`$"Amplitude (dB)"; `$"Амплитуда (dB)");
alty_label:(`$"Phase shift (degrees)";`$"Фазовый сдвиг (градусы)");
// Short rearranged versions of y_label and alty_label.
legend_text:((`$"Amplitude"; `$"Phase shift"); (`$"Амплитуда"; `$"Фазовый сдвиг"));
title_label:(`$"Single Pole Low-Pass Filter"; `$"Однополюсный Низко-Частотный Фильтр");
line_label:(`$"-20 dB/decade"; `$"-20 dB/десяток");

plot1:{[plottype; x_label; y_label; alty_label; legend_text; title_label; line_label]
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
    $[plottype=0; pl.box[`$"bclnst"; 0.0; 0i; `$"bnstv"; 0.0; 0i];
        x=1; pl.box[`$"bcfghlnst"; 0.0; 0i; `$"bcghnstv"; 0.0; 0i]];

    // Plot ampl vs freq

    pl.col0[pl`yellow];
    pl.line[101; freql; ampl];
    pl.col0[pl`yellow];
    pl.ptex[1.6; -30.0; 1.0; -20.0; 0.5; line_label]; // `$"-20 dB/decade"];

    // Put labels on

    pl.col0[pl`red];
    pl.mtex[`$"b"; 3.2; 0.5; 0.5; x_label]; // `$"Frequency"];
    pl.mtex[`$"t"; 2.0; 0.5; 0.5; title_label]; // `$"Single Pole Low-Pass Filter"];
    pl.col0[pl`yellow];
    pl.mtex[`$"l"; 5.0; 0.5; 0.5; y_label]; // `$"Amplitude (dB)"];
    nlegends:1i;

    // For the gridless case, put phase vs freq on same plot

    $[plottype=0; [pl.col0[pl`red]; pl.wind[-2.0; 3.0; -100.0; 0.0];
        pl.box[`$""; 0.0; 0; `$"cmstv"; 30.0; 3];
        pl.col0[pl`green]; pl.line[101; freql; phase];
        pl.string[101; freql; phase; `$"*"];
        pl.col0[pl`green]; pl.mtex[`$"r"; 5.0; 0.5; 0.5; alty_label]; // `$"Phase shift (degrees)"];
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
       (1.0; 1.0; 2.0; 1.; text_colors; legend_text); // z5
       ((0i;0i);(0i;0i);(0i;0i);(0i;0i)); // z6
       (line_colors; line_styles; line_widths); // z7
       (symbol_colors; symbol_scales; symbol_numbers; symbols)];} // z8

// Initialize plplot

pl.init[]
pl.font 2

// Make log plots using two different styles.
i:0; do[2;
    plot1[0; x_label[i]; y_label[i]; alty_label[i]; legend_text[i]; title_label[i]; line_label[i]]; i+:1]

pl.end[]
\\
// -*- coding: utf-8; -*-
//
// $Id: x26c.c 11717 2011-04-21 00:47:06Z airwin $
//
// Multi-lingual version of the first page of example 4.
//
// Copyright (C) 2006 Alan Irwin
// Copyright (C) 2006 Andrew Ross
//
// Thanks to the following for providing translated strings for this example:
// Valery Pipin (Russian)
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

//
// This example designed just for devices (e.g., psttfc and the
// cairo-related devices) that use the pango and fontconfig libraries. The
// best choice of glyph is selected by fontconfig and automatically rendered
// by pango in way that is sensitive to complex text layout (CTL) language
// issues for each unicode character in this example. Of course, you must
// have the appropriate TrueType fonts installed to have access to all the
// required glyphs.
//
// Translation instructions: The strings to be translated are given by
// x_label, y_label, alty_label, title_label, and line_label below.  The
// encoding used must be UTF-8.
//
// The following strings to be translated involve some scientific/mathematical
// jargon which is now discussed further to help translators.
//
// (1) dB is a decibel unit, see http://en.wikipedia.org/wiki/Decibel .
// (2) degrees is an angular measure, see
//    http://en.wikipedia.org/wiki/Degree_(angle) .
// (3) low-pass filter is one that transmits (passes) low frequencies.
// (4) pole is in the mathematical sense, see
//    http://en.wikipedia.org/wiki/Pole_(complex_analysis) .  "Single Pole"
//    means a particular mathematical transformation of the filter function has
//    a single pole, see
//    http://ccrma.stanford.edu/~jos/filters/Pole_Zero_Analysis_I.html .
//    Furthermore, a single-pole filter must have an inverse square decline
//    (or -20 db/decade). Since the filter plotted here does have that
//    characteristic, it must by definition be a single-pole filter, see also
//    http://www-k.ext.ti.com/SRVS/Data/ti/KnowledgeBases/analog/document/faqs/1p.htm
// (5) decade represents a factor of 10, see
//    http://en.wikipedia.org/wiki/Decade_(log_scale) .
//

