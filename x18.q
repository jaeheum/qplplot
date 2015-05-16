\l qplplot.q

M_PI:4*atan[1];

opt:1010b;
alt:20.0 35.0 50.0 65.0;
az:30.0 40.0 50.0 60.0;

//--------------------------------------------------------------------------
// main
//
// Does a series of 3-d plots for a given data set, with different
// viewing options in each plot.
//--------------------------------------------------------------------------

NPTS:1000

// Parse and process command line arguments

/    (void) plparseopts( &argc, argv, PL_PARSE_FULL );

test_poly:{[k]
    draw:(1 1 1 1i; 1 0 1 0i; 0 1 0 1i; 1 1 0 0i);
    pi:M_PI; two_pi:2. * M_PI;
    pl.adv[0];
    pl.vpor[0.0; 1.0; 0.0; 0.9];
    pl.wind[-1.0; 1.0; -0.9; 1.1];
    pl.col0[pl`red];
    pl.w3d[(1.0; 1.0; 1.0);( -1.0; 1.0; -1.0; 1.0; -1.0; 1.0); (alt[k]; az[k])];
    pl.box3[(`$"bnstu"; `$"x axis"; 0.0; 0i);
        (`$"bnstu"; `$"y axis"; 0.0; 0i);
        (`$"bcdmnstuv"; `$"z axis"; 0.0; 0i)];

    pl.col0[pl`yellow];

//
// x = r sin(phi) cos(theta)
// y = r sin(phi) sin(theta)
// z = r cos(phi)
// r = 1 :=)
//

    / N.B. til 21, not 20 because i+1 and j+1 below.
    THETA:two_pi*(til 21)%20.;
    PHI:pi*(til 21)%20.1;

    cp:cos[PHI];
    sp:sin[PHI];
    ct:cos[THETA];
    st:sin[THETA];
    xi:yi:zi:5#0f;
    i:0; do[20;
        j:0; do[20;
            / 'branch or a branch(if;do;while;$[.;.;.]) more than 255 byte codes away
            xi[0]:sp[j]*ct[i]; / sin[PHI[j]] * cos[THETA[i]];
            yi[0]:sp[j]*st[i]; / sin[PHI[j]] * sin[THETA[i]];
            zi[0]:cp[j]; / cos[PHI[j]];

            xi[1]:sp[j+1]*ct[i]; / sin[PHI[j + 1]] * cos[THETA[i]];
            yi[1]:sp[j+1]*st[i]; / sin[PHI[j + 1]] * sin[THETA[i]];
            zi[1]:cp[j+1]; / cos[PHI[j + 1]];

            xi[2]:sp[j+1]*ct[i+1]; / sin[PHI[j + 1]] * cos[THETA[i + 1]];
            yi[2]:sp[j+1]*st[i+1]; / sin[PHI[j + 1]] * sin[THETA[i + 1]];
            zi[2]:cp[j+1]; / zi[1]; / cos[PHI[j + 1]];

            xi[3]:sp[j]*ct[i+1]; / sin[PHI[j]] * cos[THETA[i + 1]];
            yi[3]:sp[j]*st[i+1]; / sin[PHI[j]] * sin[THETA[i + 1]];
            zi[3]:cp[j]; / zi[0]; / cos[PHI[j]];

            xi[4]:sp[j]*ct[i]; / xi[0]; / sin[PHI[j]] * cos[THETA[i]];
            yi[4]:sp[j]*st[i]; / yi[0]; / sin[PHI[j]] * sin[THETA[i]];
            zi[4]:cp[j]; / zi[0]; / cos[PHI[j]];

            pl.poly3[5; xi; yi; zi; draw[k]; 1b];
            /pl.poly3[5; xi; yi; zi; draw[k]; 1b];
            /pl.poly3[5; xi; yi; zi; draw[k]; 1b];
            /pl.poly3[5; xi; yi; zi; draw[k]; 1b];
            /pl.poly3[5; xi; yi; zi; draw[k]; 1b];
            j+:1];
        i+:1];

    pl.col0[pl`green];
    pl.mtex[`$"t"; 1.0; 0.5; 0.5; `$"unit radius sphere"]}


// Initialize plplot

pl.init[];

k:0; do[4; test_poly[k]; k+:1];

xi:yi:zi:NPTS#0f;

// From the mind of a sick and twisted physicist...

/i:0; do[NPTS;
  /  zi[i]:-1. + 2. * i % NPTS;

// Pick one ...

//      r    = 1. - ( (PLFLT) i / (PLFLT) NPTS );
    /r:zi[i];
    /xi[i]:r * cos[2. * M_PI * 6. * i % NPTS];
    /yi[i]:r * sin[2. * M_PI * 6. * i % NPTS]]

zi:-1. + 2. * (til NPTS) % NPTS;
xi:zi * cos[2. * M_PI * 6. * (til NPTS) % NPTS];
yi:zi * sin[2. * M_PI * 6. * (til NPTS) % NPTS];

k:0; do[4;
    pl.adv[0];
    pl.vpor[0.0; 1.0; 0.0; 0.9];
    pl.wind[-1.0; 1.0; -0.9; 1.1];
    pl.col0[pl`red];
    pl.w3d[(1.0; 1.0; 1.0); (-1.0; 1.0; -1.0; 1.0; -1.0; 1.0); (alt[k]; az[k])];
    pl.box3[(`$"bnstu"; `$"x axis"; 0.0; 0i);
        (`$"bnstu"; `$"y axis"; 0.0; 0i);
        (`$"bcdmnstuv"; `$"z axis"; 0.0; 0i)];

    pl.col0[pl`yellow];

    $[opt[k];
        pl.line3[NPTS; xi; yi; zi];
        // U+22C5 DOT OPERATOR.
        // N.B. xcairo driver can display U+22C5, but xwin may not be able to.
        pl.string3[NPTS; xi; yi; zi; `$"⋅"]];

    pl.col0[pl`green];
    title:`$"#frPLplot Example 18 - Alt=",(string alt[k]),"; Az=",(string az[k]);
    pl.mtex[`$"t"; 1.0; 0.5; 0.5; title];
    k+:1];

pl.end[];
\\
// -*- coding: utf-8; -*-
// $Id: x18c.c 11354 2010-11-28 20:53:56Z airwin $
//
//      3-d line and point plot demo.  Adapted from x08c.c.
//
