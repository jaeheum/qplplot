# Qplplot
Q bindings of
[PLplot graphical data plotting library](http://plplot.sourceforge.net).

PLplot provides C API to plot data. Qplplot is q bindings of PLplot for plotting
data both in interactive mode inside kdb+ sessions and in batch mode from `*.q`
scripts.

A notable feature of PLplot is its speed. For example, `plhist()` computes
distribution or frequency of a data array of 100 million elements and makes a
histogram plot in a window in subsecond on a modern laptop.
(Sandy Bridge i7 from 2012 takes about 600ms).
There is no copying or transfering data from q to PLplot as
qplplot passes a pointer so that plotting is done with
in-place data managed by kdb+. Compare running example scripts `x05.q` and `x05w100M.q`.

## version
As of today (2015.02.16), qplplot supports most of PLplot 5.10,
the latest public release.

# Qplplot Documentation
## PLplot documentation
* [PLplot home page](http://plplot.sourceforge.net/)
* [PLplot documentation](http://plplot.sourceforge.net/documentation.php)
* [PLplot API reference](http://plplot.sourceforge.net/docbook-manual/plplot-html-5.10.0/API.html).

## qplplot synopsis
Qplplot (in qplplot.q) uses `pl` as its namespace prefix.

    \l qplplot.q / loads qplplot API as a dictionary named pl.
    pl.functionname[] / matches plfunctionname() (functionname is a placeholder name)
    pl`OPTION / matches OPTION C symbol exported by plplot.h

## PLplot vs qplplot
Qplplot API mirrors that of PLplot so that users can refer to
[PLplot API reference](http://plplot.sourceforge.net/docbook-manual/plplot-html-5.10.0/API.html).

`pl.functionname[]` corresponds to `plfunctionanme()` in PLplot. For example,

    PLplot in C             qplplot
    -----------------------------------------------
    plinit()                pl.init[]
    plline(n, x, y)         pl.line[n; x; y]

Translating API of PLplot to q or qplplot is easy once types are understood:

    PLplot types            q types
    -----------------------------------------------
    (PLINT, input)          `int atom or type -6h
    (PLFLT, input)          `float atom or type -9h
    (PLBOOL, input)         `int atom or type -9h, (NOT `boolean or -1h)
    (const PLFLT *, input)  `float vector or 9h
    (char *, input)         `sym or -11h
    (char *, output)        `sym or -11h, N.B. output parameter

Therefore [`plline(PLINT n, const PLFLT* x, const PLFLT* y)`](http://plplot.sourceforge.net/docbook-manual/plplot-html-5.10.0/plline.html)
would be translated into q as
`pl.line[n; x; y]` where `n:count x`; `x` and `y`, vectors of float (of equal counts).

Here is a short example that draws a random walk across 1000 points:

    \l qplplot.q
    pl.init[] / plinit();
    pl.env[0f;1f;0f;1f;0;0] / plenv(PLFLT xmin, PLFLT xmax, PLFLT ymin, PLFLT ymax, PLINT just, PLINT axis).
    pl.col0 9 / plcol0(PLINT icol0); // same as pl.col0 pl`blue;
    K:1000
    x:K?1f
    y:K?1f
    pl.line[K;x;y] / plline(PLINT n, const PLFLT*, const PLFLT* y); // draw lines of random walk across 1000 points.
    pl.lab[`x; `y; `$"random walk across 1000 points"]
    / pllab(const char* xlabel, const char* ylabel, const char* tlabel);
    pl.end[] / plend();
    \\

Many PLplot APIs use PLplot's exported C symbols or constants. For example,
[`plmesh()`](http://plplot.sourceforge.net/docbook-manual/plplot-html-5.10.0/plmesh.html)
expects a `PLINT` `opt` argument that can be either `DRAW_LINEX`, `DRAW_LINEY`, or `DRAW_LINEXY`.
In qplplot's `pl.mesh[]`, these `opt` values are q symbol keys to `pl`:
``pl`DRAW_LINEX``, ``pl`DRAW_LINEY`` or ``pl`DRAW_LINEXY``.

[`plcol0()`](http://plplot.sourceforge.net/docbook-manual/plplot-html-5.10.0/plcol0.html)
expects an integer argument representing a color.
Qplplot lets users to use color names listed in the `plcol0` reference,
e.g. `pl.col0[0]` works as well as ``pl.col0[pl`black]``.

Most PLplot APIs return void but some return an output parameter (marked `output` type). For example,
[`plgver()`](http://plplot.sourceforge.net/docbook-manual/plplot-html-5.10.0/plgver.html)

    plgver(char* p_ver);
        p_ver (char *, output)
               Pointer to the current library version number.

Qplplot's counterpart returns output parameter `p_ver` as a symbol:

    q)pl.gver[]
    `5.10.0

Some other APIs return multiple output parameters and qplplot wraps them in a dictionary. For example,
[`plgchr()`](http://plplot.sourceforge.net/docbook-manual/plplot-html-5.10.0/plgchr.html)

    q)pl.gchr[] / plgchr(&p_def, &p_ht); in C
    p_def| 7.5
    p_ht | 7.5

Notice that symbol keys of the output dictionary match the names of output
parameters in PLplot's API reference.

## further hints for translation
* A qplplot function name is same as PLplot's original name except for a `.` between `pl` and the rest of the name.
* Most PLplot API names are abbreviations:
    * `plg*()` APIs are usually getter functions, e.g. `plgver()` or `pl.gver[]` above.
    * `pls*()` APIs are usually setter functions, e.g. `plsdev(const char* devname)` or ``pl.sdev[`devname]``.
* Examples resemble PLplot's original examples closely. See Examples section below.

## types or `` `int `` vs `` `long ``
* `PLINT` atom can be passed as `` `long `` or `-7h` as long as its value fits
  `` `int ``. This leniency lets users skip adding `i`-suffix behind every integer
  that is `` `long `` by default in Kdb+ 3.0 or later.
* However, if a list that expects a `PLINT` (or `PLBOOL`), make sure to use ``
  `int `` in q.
* Getters (`plg*()` or `pl.g*[]`) returning `PLINT` returns `` `int
  `` (see `x31.q`).

## special cases
Because a q function allows maximum of 8 arguments
(define a function with more than 8 arguments and q returns `'params` exception),
some PLplot APIs with more than 8 arguments deserve special attention.

For most PLplot APIs, qplplot preserves order, count and types of arguments
of the original PLplot APIs so that PLplot's API documentation can cover qplplot's.
However, PLplot APIs with more than 8 arguments are expressed differently in qplplot:

* Arguments are grouped logically into lists. See the `pl.*` functions below and cross-check with PLplot's reference.
* Often, argument for count and other bookkeeping arguments are elided.
* [`plcont()`](http://plplot.sourceforge.net/docbook-manual/plplot-html-5.10.0/plcont.html)
  uses a callback function: a user-defined one as well as built-in
  `pltr0`, `pltr1` or, `pltr2`.
  Qplplot's `pl.cont*` come with four flavors: `pl.cont[]`, `pl.cont0[]`,
  `pl.cont1[]` and `pl.cont2[]`.
  See examples for usage (see Examples section below).
* Likewise for `plimagefr()`, `plshade()`, `plshades()`, `plvect()`.
* See also Bugs section below.

        pl.box3[(`xopt;`lsxlabel;xtick;nxsub);
            (`yopt;`lsylabel;ytick;nysub);
            (`zopt;`lszlabel;ztick;nzsub)]
        pl.colorbar[dict] / dict is made of all input args as keys and values.
            / Returns a dict with keys p_colorbar_width and p_colorbar_height.
        pl.cont[z; (kx;lx); (ky;ly); clevel; pltr; pltr_data]; / nlevel=count clevel
        pl.cont0[f; (kx;ly); (ky;ly); clevel]; / nlevel=count clevel; pltr0 called by qplplot.
        pl.cont1[z; (kx;ly); (ky;ly); clevel; xg1; yg1]; / nlevel=count clevel; pltr1 called by qplplot.
        pl.cont2[f; (kx;ly); (ky;ly); clevel; xg2; yg2]; / nlevel=count clevel; pltr2 called by qplplot.
        pl.imagefr[x; (xmin;xmax;ymin;ymax);(zmin;zmax);(valuemin;valuemax); pltr; pltr_data]
        pl.imagefr0[x; (xmin;xmax;ymin;ymax);(zmin;zmax);(valuemin;valuemax)]
        pl.imagefr1[x; (xmin;xmax;ymin;ymax);(zmin;zmax);(valuemin;valuemax); xg1; yg1]
        pl.imagefr2[x; (xmin;xmax;ymin;ymax);(zmin;zmax);(valuemin;valuemax); xg2; yg2]
        pl.image[x; (xmin;xmax; ymin;ymax);(zmin;zmax);(dxmin;dxmax;dymin;dymax)]
        pl.legend[(opt; position; x; y; plot_width);
            (bg_color; bb_color; bb_style);
            (nrow,ncolumn,nlegend);
            opt_array;
            (text_offset; text_scale;  text_spacing;  test_justification; text_colors; text);
            (box_colors; box_patterns; box_scales; box_line_widths);
            (line_colors; line_styles; line_widths);
            (symbol_colors; symbol_scales; symbol_numbers; symbols)]
        pl.ptex3[(x;y;z);(dx;dy;dz);(sx;sy;sz);just;text]
        pl.shade[a; defined;
            (xmin;xmax;ymin;ymax;shade_min;shade_max);
            (sh_cmap;sh_color;sh_width;min_color;min_width;min_color;max_color;max_width);
            fill; rectangular; pltr; pltr_data]
            / fill is ignored but left for future compatibility
        pl.shade1[a; defined;
            (xmin;xmax;ymin;ymax;shade_min;shade_max);
            (sh_cmap;sh_color;sh_width;min_color;min_width;min_color;max_color;max_width);
            fill; rectangular; pltr; pltr_data]
            / fill is ignored but left for future compatibility
        pl.shades[a; defined;
            (xmin; xmax; ymin; ymax; clevel);
            (fill_width; cont_color; cont_width);
            fill; rectangular; pltr]
            / fill is ignored but left for future compatibility
        pl.shades0[a; defined;
            (xmin; xmax; ymin; ymax; clevel);
            (fill_width; cont_color; cont_width);
            fill; rectangular] / pltr0 setby pl.shades0[]
        pl.shades2[a; defined;
            (xmin; xmax; ymin; ymax; clevel);
            (fill_width; cont_color; cont_width);
            fill; rectangular; xg2; yg2] / pltr2 setby pl.shades2[]
        pl.stripc[(xspec;yspec);
            (xmin;xmax;xjump; ymin;ymax);
            (xlpos;ylpos); (y_ascl;acc); (colbox;collab); (colline;styline;legline); (labx;laby;labtop)]
        pl.surf3d[x; y; z; opt; clevel]
        pl.surf3dl[x; y; z; opt; clevel; (xmin;xmax); ymin;ymax)]
        pl.fsurf3d[x; y; z; opt; clevel]
        pl.vect[u; v; scale; pltr]; / nx=count u; ny=count v;
        pl.vect0[u; v; scale]; / nx=count u; ny=count v; pltr0 set by plvect.
        pl.vect1[u; v; scale; xg1; yg1]; / nx=count u; ny=count v; pltr1 set by plvect.
        pl.vect2[u; v; scale; xg2; yg2]; / nx=count u; ny=count v; pltr2 set by plvect.
        pl.w3d[(basex;basey;height); (xmin;xmax;ymin;ymax;zmin;zmax); (alt;az)]

# Examples
PLplot comes with 33 examples to demonstrate its APIs. Reference for PLplot refers to these examples.
Most of them have been "translated" to q. See `xNN.q`, where NN is a two-digit number.
Some `xNN.q` contains `/ N.B.` comments to draw attention to exceptions
listed in the previous section as well as easy-to-trigger bugs.

Examples are by no means written in [idiomatic q](http://kxcommunity.com/category/idioms/).
They resemble their C original to help readers translate between PLplot API and qplplot counterparts.

Once all is properly installed, try out examples:

    q x01.q
    q x05.q
    q x05w100M.q    # x05.q with 100M data points.

Compare output of examples with the [PLplot's](http://plplot.sourceforge.net/examples.php).

## Drivers differences
PLplot supports many kinds of output drivers with various capabilities. For
example, `xcairo` driver handles color shading (`x30.q`) and Unicode (`x26.q`) better than `xwin` one.
However `xwin` driver can rescale graphics when its windows are
resized, but `xcairo` cannot.

# Installation
## Kdb+ 3.0 or above only
Qplplot supports Kdb+ 3.0 or later only.

## Linux (Ubuntu 14.04) with kdb+ 3 or above, 32-bit (l32)

    # Multi-arch development environment should be installed:
    # Consult local documentation or sysadmin for more definitive instructions.
    sudo apt-get install gcc-multilib
    sudo apt-get install libplplot12:i386
    sudo apt-get install libplplot-dev:i386
    sudo apt-get install plplot12-driver-xwin:i386
    sudo apt-get install plplot12-driver-cairo:i386

    # Assuming 32-bit libplplot is installed, and code.kx.com svn is set locally.
    export KXSVN=/local/path/to/svn/from/kx.com
    gcc -DKXVER=3 -m32 -shared -rdynamic -fPIC \
        qplplot.c \
        -o ./qplplot.so \
        -I$KXSVN/kx/kdb+/c/c  \
        -L$KXSVN/kx/kdb+/l32 \
        `pkg-config --cflags --libs plplotd`
    cp qplplot.q plopts.q $HOME/q/
    mv qplplot.so $HOME/q/l32/qplplot.so # do not keep .so in $PWD (q gets confused)

## Mac OS X with kdb+ 3 or above, 32-bit (m32)

    # TODO: instruction of installing PLplot on Mac OS X.
    export KXSVN=/local/path/to/svn/from/kx.com
    gcc -DKXVER=3  -m32 -bundle -undefined dynamic_lookup \
        qplplot.c \
        -o ./qplplot.so \
        -I$KXSVN/kx/kdb+/c/c  \
        -L$KXSVN/kx/kdb+/m32 \
        -Wl,-rpath -Wl,. \
        -Wl,-reexport_library -Wl,/usr/local/lib/libplplotd.dylib
    cp qplplot.q plopts.q $HOME/q/
    mv qplplot.so $HOME/q/m32/qplplot.so # do not keep .so in $PWD (q gets confused)

## Windows
PLplot supports Windows but qplplot has not been built nor tested on Windows.

## 64-bit kdb+ support
Qplplot has not been built nor tested with 64-bit kdb+.
For 64-bit kdb+,

* A 64-bit version of PLplot needs to be installed:
    * For example, change `sudo apt-get install ...` on Ubuntu to drop `:i386` suffixes.
* Change gcc invocation:
    * Drop `-m32` flag.
    * Instead of `$KXSVN/kx/kdb+/X32`, use `$KXSVN/kx/kdb+/X64` with `X` being either
      `l` or `m` (and maybe `w` in the future).

# Bugs
## missing APIs and their examples

* A few PLplot APIs are not yet implemented: `plmap()`, `plot3dcl()`, `plslabelfunc()`, `plsmem()`, `plsmema()`.
  Probably `plsmem*` APIs will remain unimplemented as they are meant for memory access from C API.
* `plimage()` example is not translated yet.
* `plparseopts()` is not yet tested. (Future design decision: whether or
  not integrate `plparseopts()` with q's own command line options parsing feature).
* Not yet translated examples: `x08.q`, `x19.q`, `x20.q`, `x23.q`, `x24.q`, `x27.q`, `x28.q`, `x33.q`.

## segfaults
Qplplot API expects q symbols in places where C API expects `char*`.
For example,

    pl.lab[`xlabel; `ylabel; `plottitle];

or

    pl.lab[`$"x long label"; `$"y long label"; `$"plot with long title"];

If user provides a q byte string, instead of q symbol as argument, qplplot does not
convert the byte string to symbol and PLplot will segfault as it expects a nul-terminated
C string.

    pl.lab["byte string, not C string"; "q symbols are C strings"; "glad q has real byte strings."]

    Sorry, this application or an associated library has encountered a fatal error and will exit.
    If known, please email the steps to reproduce this error to tech@kx.com
    with a copy of the kdb+ startup banner.
    Thank you.
    /home/hjh/q/l32/q() [0x80af898]
    [0xf77b9410]
    /lib/i386-linux-gnu/libc.so.6(+0x83716) [0xf75ed716]
    /usr/lib/libplplotd.so.12(+0x36fb2) [0xf34e3fb2]
    /usr/lib/libplplotd.so.12(+0x37a29) [0xf34e4a29]
    /usr/lib/libplplotd.so.12(c_plmtex+0x255) [0xf34e4645]
    /usr/lib/libplplotd.so.12(c_pllab+0x7f) [0xf34e496f]
    /home/hjh/q/l32/qplplot.so(+0x8a2a) [0xf77ada2a]
    /home/hjh/q/l32/q(dlc+0xde) [0x80ae99e]
    Segmentation fault (core dumped)

## type error leading to program abortion and/or "blank" output
Qplplot APIs often have many arguments and users can mistype arguments:

    pl.box[`$"bcnstd"; 14 * 24.0 * 60.0 * 60.0; 14; `$"bcnstv"; 1; 4];

    *** PLPLOT ERROR, IMMEDIATE EXIT ***
    pldtik: magnitude of specified tick spacing is much too small
    Program aborted

According to [`plbox()`](http://plplot.sourceforge.net/docbook-manual/plplot-html-5.10.0/plbox.html),
`ytick` argument (`1` in the above example)
should be `PLFLT` or `` `float ``, not `PLINT` or `` `int ``.

Fix `1` to `1f`:

    pl.box[`$"bcnstd"; 14 * 24.0 * 60.0 * 60.0; 14; `$"bcnstv"; 1f; 4];


## arity mismatch hides issues

    pl.wind[x;y;z;w;] / last ; should not be there!

## 'rank error
`pl.line[K; x; y; unnecessaryargs]` will generate `'rank` error because `pl.line[]` expects 3 arguments.

## better documentation of callback function usage
Examples in q need more comments on how to define callback functions in q.

## more consistent usage pattern of translating PLplot `NULL` to q
Some PLplot APIs use `NULL` for special values. Examples in q need more
comments and consistent translations.


# Notes on Implementation
* `qplplot.c` -- q bindings of PLplot APIs.
* `plopts.q` -- C symbols used in PLplot APIs as symbols inside `pl` dictionary.
* `qplplot.q` -- q wrapper for qplplot and plopts.q, a dictionary named `pl`.

`qplplot.c` needs trimming as it is currently 1166 lines covering 180+ APIs.
There are 95 `#define` macros and 200 lines for exporting `pl` dictionary.
Most of PLplot APIs are covered in one-liners
but there are quite a bit of repetitions in constructing return dictionaries
and converting 2-D matrix inputs.

# Future Plan
* Fix bugs and improve code/macro hygiene.
* Update qplplot to support PLplot 5.11 when it comes out.
* Implement a few missing APIs and translate a few missing examples.
* Increase type safety for better usability (`` `int `` vs `` `long `` in lists, accepting byte string inputs, etc.)
* Distant future: high-level APIs wrapping the current low-level qplplot APIs for productivity.

# License
Qplplot is licensed under GNU Library General Public License 2.0, the same license used by PLplot. See `COPYING.LIB`.

# Copyright
Qplplot is copyright (c) 2015 Jaeheum Han All rights reserved.

# Contact
Email: Jay Han <jay.han@gmail.com>
