\l qplplot.q
dtr:4*atan[1]%180

/pl.sdev`xwin
// Set orientation to portrait - note not all device drivers
// support this, in particular most interactive drivers do not
pl.sori[1]
// Initialize plplot
pl.init[]
// Set up viewport and window, but do not draw box
pl.env[-1.3; 1.3; -1.3; 1.3; 1; -2]
// Draw circles for polar grid
i:1; do[10; pl.arc[0.0; 0.0; 0.1*i; 0.1*i; 0.0; 360.0; 0.0; 0]; i+:1]
// {pl.arc[0f;0f;0.1*x;0.1*x;0f;360f;0f;0]}each (1+til 10)
pl.col0[pl`yellow]
// Slightly off zero to avoid floating point logic flips at 90 and 270 deg.
i:0; do[11; theta:30*i; dx:cos[dtr*theta]; dy:sin[dtr*theta];
    pl.join[0;0;dx;dy]; text:string "i"$theta;
    $[theta<9.99;offset:0.45;
        $[theta<99.9;offset:0.30;offset:0.15]];
    $[dx>=neg 0.00001; pl.ptex[dx;dy;dx;dy;neg offset; `$text];
        pl.ptex[dx;dy;neg dx;neg dy;1.+offset; `$text]]; i+:1]

// Draw the graph
xi:cos[dtr*(1+til 360)]
yi:sin[dtr*(1+til 360)]
xx:xi*r:sin[dtr*5*1+til 360]
yy:yi*r

pl.col0[pl`green]
pl.line[count xx; xx;yy]

pl.col0[pl`aquamarine]
pl.mtex[`$"t"; 2; 0.5; 0.5; `$"#frPLplot Example 3 - r(#gh)=sin 5#gh"]
// Close the plot at end
pl.end[]
\\
// $Id: x03c.c 11663 2011-03-20 23:08:13Z hezekiahcarty $
//
//      Polar plot demo.
//
