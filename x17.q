\l qplplot.q
M_PI:4*atan[1];
nsteps:1000;
// The plot will grow automatically if needed (but not shrink)
ymin:neg 0.1f;
ymax:0.1f;
// Specify initial tmin and tmax -- this determines length of window.
// Also specify maximum jump in t
// This can accomodate adaptive timesteps

tmin:0.;
tmax:10.;
tjump:0.3;        // percentage of plot to jump

// Axes options same as plbox.
// Only automatic tick generation and label placement allowed
// Eventually I'll make this fancier

colbox:1i;
collab:3i;
styline:colline:2 3 4 5i;       // pens color and line style
legline:`sum`sin,(`$"sin*noi"),(`$"sin+noi"); // pens legend
xlab:0.; ylab:0.25;     // legend position
autoy:1i;                  // autoscale y
acc:1i;                  // don't scrip, accumulate

// Initialize plplot

pl.init[];

pl.adv[0];
pl.vsta[];

// Register our error variables with PLplot
// From here on, we're handling all errors here
/plsError( &pl_errcode, errmsg );

id1:pl.stripc[(`$"bcnst"; `$"bcnstv");
        (tmin; tmax; tjump; ymin; ymax);
        (xlab; ylab);
        (autoy; acc);
        (colbox; collab);
        (colline; styline; legline);
        (`$"t"; `$""; `$"Strip chart demo")];

// Let pl.pl.ot handle errors from here on

/pl.sError[ NULL; NULL ];

autoy:0b;  // autoscale y
acc:1b;  // accumulate

// This is to represent a loop over time
// Let's try a random walk process

y1:y2:y3:y4:0.0;
dt:0.1;
n:0;
do[nsteps; system"sleep 0.01";
    t:n*dt;
    noise:pl.randd[] - 0.5;
    y1:y1 + noise;
    y2:sin[t * M_PI % 18.];
    y3:y2 * noise;
    y4:y2 + noise % 3.;

    // There is no need for all pens to have the same number of
    // points or beeing equally time spaced.

    if [1=n mod 2; pl.stripa[id1; 0; t; y1]];
    if [1=n mod 3; pl.stripa[id1; 1; t; y2]];
    if [1=n mod 4; pl.stripa[id1; 2; t; y3]];
    if [1=n mod 5; pl.stripa[id1; 3; t; y4]];

    // needed if using double buffering [-db on command line]
    //pl.eop[];
    n+:1];

// Destroy strip chart and it's memory

pl.stripd[id1];
pl.end[];
\\
// $Id: x17c.c 11289 2010-10-29 20:44:17Z airwin $
//
// Plots a simple stripchart with four pens.
//
