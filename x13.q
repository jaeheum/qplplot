// $Id: x13c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Pie chart demo.
//
\l qplplot.q
/pl.sdev`xwin


text:`Maurice`Geoffrey`Alan`Rafael`Vince;

//--------------------------------------------------------------------------
// main
//
// Does a simple pie chart.
//--------------------------------------------------------------------------
x:y:500#0f;
per:10. 32. 12. 30. 16.;
// Initialize plplot
pl.init[];
pl.adv[0];
// Ensure window has aspect ratio of one so circle is
// plotted as a circle.
pl.vasp[1.0];
pl.wind[0.; 10.; 0.; 10.];
pl.col0[pl`yellow];
// n.b. all theta quantities scaled by 2*M_PI/500 to be integers to avoid
// floating point logic problems.

M_PI:4*atan[1];

theta0:0;
dthet:1;
i:0; while[i<=4;
    j:0;
    // n.b. the theta quantities multiplied by 2*M_PI/500 afterward so
    // in fact per is interpreted as a percentage.
    theta1:`int$(theta0 + 5 * per[i]);
    //x:y:(theta1-theta0)#0f;
    x[j]:5.;
    y[j]:5.;
    j+:1;
    $[i=4;theta1:500;];
    theta:theta0;
    while[theta <= theta1;
        x[j]:5 + 3 * cos[(2. * M_PI % 500.) * theta];
        y[j]:5 + 3 * sin[(2. * M_PI % 500.) * theta];
        j+:1;
        theta+:dthet];

    pl.col0[i + 1];
    pl.psty[((i + 3) mod 8) + 1];
    pl.fill[j; x; y];
    pl.col0[pl`red];
    pl.line[j; x; y];
    just:(2. * M_PI % 500.) * (theta0 + theta1) % 2.;
    dx:.25 * cos[just];
    dy:.25 * sin[just];
    $[((theta0 + theta1) < 250 ) or  (theta0 + theta1) > 750;
        just:0.;
        just:1.];

    pl.ptex[x[j div 2] + dx; y[j div 2]+ dy; 1.0; 0.0; just; text[i]];
    theta0:theta - dthet;
    i+:1];
pl.font[2];
pl.schr[0.; 1.3];
pl.ptex[5.0; 9.0; 1.0; 0.0; 0.5; `$"Percentage of Sales"];

// Don't forget to call pl.END to finish off!

pl.end[];
\\
// $Id: x13c.c 11289 2010-10-29 20:44:17Z airwin $
//
//      Pie chart demo.
//
