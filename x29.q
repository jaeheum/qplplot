\l qplplot.q


//--------------------------------------------------------------------------
// main
//
// Draws several plots which demonstrate the use of date / time formats for
// the axis labels.
// Time formatting is done using the strfqsas routine from the qsastime
// library.  This is similar to strftime, but works for a broad
// date range even on 32-bit systems.  See the
// documentation of strfqsas for full details of the available formats.
//
// 1) Plotting temperature over a day (using hours / minutes)
// 2) Plotting
//
// Note: We currently use the default call for plconfigtime (done in
// plinit) which means continuous times are interpreted as seconds since
// 1970-01-01, but that may change in future, more extended versions of
// this example.
//
//--------------------------------------------------------------------------

M_PI:4*atan[1];

// Parse command line arguments
/plparseopts( &argc, argv, PL_PARSE_FULL );

// Initialize plplot
pl.init[];

plot1:{
    // Data points every 10 minutes for 1 day
    npts:73;

    xmin:0;
    xmax:60.0 * 60.0 * 24.0; // Number of seconds in a day
    ymin:10.0;
    ymax:20.0;

    xi:yi:xerr1:xerr2:yerr1:yerr2:npts#0f; // NOT 365
    xi:xmax*(til npts)%npts;
    yi:15.0 - 5.0*cos[2*M_PI*(til npts)%npts];
    // Set x error bars to +/- 5 minute
    xerr1:xi-60*5;
    xerr2:xi+60*5;
    // Set y error bars to +/- 0.1 deg C
    yerr1:yi-0.1;
    yerr2:yi+0.1;

    pl.adv[0];
    // Rescale major ticks marks by 0.5
    pl.smaj[0.0; 0.5];
    // Rescale minor ticks and error bar marks by 0.5
    pl.smin[0.0; 0.5];

    pl.vsta[];
    pl.wind[xmin; xmax; ymin; ymax];

    // Draw a box with ticks spaced every 3 hour in X and 1 degree C in Y.
    pl.col0[pl`red];
    // Set time format to be hours:minutes
    pl.timefmt[`$"%H:%M"];
    pl.box[`$"bcnstd"; 3.0 * 60 * 60; 3; `$"bcnstv"; 1f; 5];

    pl.col0[pl`green];
    pl.lab[`$"Time (hours:mins)"; `$"Temperature (degC)"; `$"@frPLplot Example 29 - Daily temperature"];

    pl.col0[pl`aquamarine];

    pl.line[npts; xi; yi];
    pl.col0[pl`yellow];
    pl.errx[npts; xerr1; xerr2; yi];
    pl.col0[pl`green];
    pl.erry[npts; xi; yerr1; yerr2];

    // Rescale major / minor tick marks back to default
    pl.smin[0.0; 1.0];
    pl.smaj[0.0; 1.0]}

// Plot the number of hours of daylight as a function of day for a year
plot2:{
    // Latitude for London
    lat:51.5;

    npts:365;
    xi:yi:npts#0f;

    xmin:0;
    xmax:npts * 60.0 * 60.0 * 24.0;
    ymin:0f;
    ymax:24f;

    // Formula for hours of daylight from
    // "A Model Comparison for Daylength as a Function of Latitude and
    // Day of the Year"; 1995; Ecological Modelling; 80; pp 87-95.
    xi:(til npts) * 60.0 * 60.0 * 24.0;
    p:asin[0.39795 * cos[0.2163108 + 2 * atan[0.9671396 * tan[0.00860 * ((til npts) - 186)]]]];
    yi:d:24.0 - (24.0 % M_PI) * acos[(sin[0.8333 * M_PI % 180.0] + sin[lat * M_PI % 180.0] * sin[p]) % (cos[lat * M_PI % 180.0] * cos[p])];

    pl.col0[pl`red];
    // Set time format to be abbreviated month name followed by day of month
    pl.timefmt[`$"%b %d"];
    pl.prec[1; 1];
    pl.env[xmin; xmax; ymin; ymax; 0; 40];

    pl.col0[pl`green];
    pl.lab[`$"Date"; `$"Hours of daylight"; `$"@frPLplot Exampl.e 29 - Hours of daylight at 51.5N"];

    pl.col0[pl`aquamarine];

    pl.line[npts; xi; yi];

    pl.prec[0; 0]}

plot3:{
    // Calculate continuous time corresponding to 2005-12-01 UTC.
    tstart:pl.ctime[2005; 11; 01; 0; 0; 0.];
    /could be done in q:
    /tstart:3600*24*(`float$gtime ltime 2005.12.01T00:00:00)-offset:`float$gtime ltime 1970.01.01T00:00:00;
    /tstart:3600*24*(`float$2005.12.01T00:00:00)-offset:`float$1970.01.01T00:00:00;
    npts:62;

    xmin:tstart;
    xmax:xmin + npts * 60.0 * 60.0 * 24.0;
    ymin:0.0;
    ymax:5.0;

    xi:xmin + (til npts) * 60.0 * 60.0 * 24.0;
    yi:1.0 + sin[2 * M_PI *(til npts) % 7.0] + exp[min[(til npts; npts - til npts)]% 31.0];
    pl.adv[0];

    pl.vsta[];
    pl.wind[xmin; xmax; ymin; ymax];

    pl.col0[pl`red];
    // Set time format to be ISO 8601 standard YYYY-MM-DD.
    pl.timefmt[`$"%F"];
    // Draw a box with ticks spaced every 14 days in X and 1 hour in Y.
    pl.box[`$"bcnstd"; 14 * 24.0 * 60.0 * 60.0; 14; `$"bcnstv"; 1f; 4];

    pl.col0[pl`green];
    pl.lab[`$"Date"; `$"Hours of television watched"; `$"@frPLplot Example 29 - Hours of television watched in Dec 2005 / Jan 2006"];

    pl.col0[pl`aquamarine];

    // Rescale symbol size (used by plpoin) by 0.5
    pl.ssym[0.0; 0.5];
    pl.poin[npts; xi; yi; 2];
    pl.line[npts; xi; yi]}

plot4helper:{
    xx:yy:(x`npts)#0f;
    i:0;do[x`npts;
            xx[i]:(x`xmin) + i * ((x`xmax) - x`xmin) % ((x`npts) - 1);
            pl.configtime[x`scale; x`offset1; x`offset2; 0; 0; (0i; 0i; 0i; 0i; 0i; 0f)];
            tai:xx[i];
            taib:pl.btime[tai];
            pl.configtime[x`scale; x`offset1; x`offset2; 0x2; 0; (0i; 0i; 0i; 0i; 0i; 0f)];
            utcb:pl.btime[tai];
            pl.configtime[x`scale; x`offset1; x`offset2; 0; 0; (0i; 0i; 0i; 0i; 0i; 0f)];
            utc:pl.ctime[utcb`year; utcb`month; utcb`day; utcb`hour; utcb`min; utcb`sec];
            yy[i]:(tai - utc) * (x`scale) * 86400.;
            i+:1
    ];
    pl.adv[0];
    pl.vsta[];
    pl.wind[x`xmin; x`xmax; x`ymin; x`ymax];
    pl.col0[pl`red];
    $[x`if_TAI_time_format;
        pl.configtime[x`scale; x`offset1; x`offset2; 0; 0; (0i; 0i; 0i; 0i; 0i; 0f)];
        pl.configtime[x`scale; x`offset1; x`offset2; 2; 0; (0i; 0i; 0i; 0i; 0i; 0f)]];
    pl.timefmt[x`time_format];
    pl.box[`$"bcnstd"; x`xlabel_step; 0; `$"bcnstv"; 0.; 0];
    pl.col0[pl`green];
    title:`$"@frPLplot Example 29 - TAI-UTC ";
    title:{`$(string x),(string " "),(string y)}[title; x`title_suffix];
    pl.lab[x`xtitle; `$"TAI-UTC (sec)"; title];
    pl.col0[pl`aquamarine];
    pl.line[(x`npts); xx; yy]}

plot4:{
    // TAI-UTC (seconds) as a function of time.
    // Use Besselian epochs as the continuous time interval just to prove
    // this does not introduce any issues.

    // Use the definition given in http://en.wikipedia.org/wiki/Besselian_epoch
    // B:1900. + (JD -2415020.31352)/365.242198781
    // ==> (as calculated with aid of "bc -l" command)
    // B:(MJD + 678940.364163900)/365.242198781
    // ==>
    // MJD:B*365.24219878 - 678940.364163900
    scale:365.242198781;
    offset1:-678940.;
    offset2:-0.3641639;
    pl.configtime[scale; offset1; offset2; 0; 0; (0i; 0i; 0i; 0i; 0i; 0f)];

    / N.B. 'branch happens
    kind:0; / do[7;
    /do[1; / kind=0;
    xmin:pl.ctime[1950; 0; 2; 0; 0; 0.];
    xmax:pl.ctime[2020; 0; 2; 0; 0; 0.];
    npts:(70 * 12) + 1;
    ymin:0.0;
    ymax:36.0;
    time_format:`$"%Y%";
    if_TAI_time_format:1i;
    title_suffix:`$"from 1950 to 2020";
    xtitle:`$"Year";
    xlabel_step:10.;
    h:(`npts`xmin`xmax`ymin`ymax`scale`offset1`offset2`time_format`title_suffix`xtitle`xlabel_step`if_TAI_time_format)!(npts;xmin;xmax;ymin;ymax;scale;offset1;offset2;time_format;title_suffix;xtitle;xlabel_step;if_TAI_time_format);
    plot4helper[h];
    kind+:1;
    do[2; / (kind=1) or kind=2;
            xmin:pl.ctime[1961; 7; 1; 0; 0; 1.64757 - .20];
            xmax:pl.ctime[1961; 7; 1; 0; 0; 1.64757 + .20];
            npts:1001;
            ymin:1.625;
            ymax:1.725;
            time_format:`$"%S%2%";
            title_suffix:`$"near 1961-08-01 (TAI)";
            xlabel_step:0.05 % (scale * 86400.);
            $[kind=1;
                [if_TAI_time_format:1i; xtitle:`$"Seconds (TAI)"];
                [if_TAI_time_format:0i; xtitle:`$"Seconds (TAI) labelled with corresponding UTC"]];
            h:(`npts`xmin`xmax`ymin`ymax`scale`offset1`offset2`time_format`title_suffix`xtitle`xlabel_step`if_TAI_time_format)!(npts;xmin;xmax;ymin;ymax;scale;offset1;offset2;time_format;title_suffix;xtitle;xlabel_step;if_TAI_time_format);
            plot4helper[h];
        kind+:1];
    do[2; / (kind=3) or kind=4;
            xmin:pl.ctime[1963; 10; 1; 0; 0; 2.6972788 - .20];
            xmax:pl.ctime[1963; 10; 1; 0; 0; 2.6972788 + .20];
            npts:1001;
            ymin:2.55;
            ymax:2.75;
            time_format:`$"%S%2%";
            title_suffix:`$"near 1963-11-01 (TAI)";
            xlabel_step:0.05 % (scale * 86400.);
            $[kind=3;
                [if_TAI_time_format:1i; xtitle:`$"Seconds (TAI)"];
                [if_TAI_time_format:0i; xtitle:`$"Seconds (TAI) labelled with corresponding UTC"]];
            h:(`npts`xmin`xmax`ymin`ymax`scale`offset1`offset2`time_format`title_suffix`xtitle`xlabel_step`if_TAI_time_format)!(npts;xmin;xmax;ymin;ymax;scale;offset1;offset2;time_format;title_suffix;xtitle;xlabel_step;if_TAI_time_format);
            plot4helper[h];
        kind+:1];
    do[2; / (kind=5) or kind=6;
            xmin:pl.ctime[2009; 0; 1; 0; 0; 34. - 5.];
            xmax:pl.ctime[2009; 0; 1; 0; 0; 34. + 5.];
            npts:1001;
            ymin:32.5;
            ymax:34.5;
            time_format:`$"%S%2%";
            title_suffix:`$"near 2009-01-01 (TAI)";
            xlabel_step:1. % (scale * 86400.);
            $[kind=5;
                [if_TAI_time_format:1i; xtitle:`$"Seconds (TAI)"];
                [if_TAI_time_format:0i; xtitle:`$"Seconds (TAI) labelled with corresponding UTC"]];
            h:(`npts`xmin`xmax`ymin`ymax`scale`offset1`offset2`time_format`title_suffix`xtitle`xlabel_step`if_TAI_time_format)!(npts;xmin;xmax;ymin;ymax;scale;offset1;offset2;time_format;title_suffix;xtitle;xlabel_step;if_TAI_time_format);
            plot4helper[h];
        kind+:1]}


// Change the escape character to a '@' instead of the default '#'
pl.sesc["@"];

plot1[];

plot2[];

plot3[];

plot4[];

// Don't forget to call plend() to finish off!
pl.end[];
\\
// $Id: x29c.c 11680 2011-03-27 17:57:51Z airwin $
//
//     Sample plots using date / time formatting for axes
//
// Copyright (C) 2007 Andrew Ross
//
// This file is part of PLplot.
//
//  PLplot is free software; you can redistribute it and/or modify
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
