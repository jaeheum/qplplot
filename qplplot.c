// Copyright 2015 Jay Han
// LGPL (like plplot)
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "plplot.h"
#include "k.h"

#define K0(f) K f(void)
#define K3(f) K f(K x,K y,K z)
#define K4(f) K f(K x,K y,K z,K z4)
#define K5(f) K f(K x,K y,K z,K z4,K z5)
#define K6(f) K f(K x,K y,K z,K z4,K z5,K z6)
#define K7(f) K f(K x,K y,K z,K z4,K z5,K z6,K z7)
#define K8(f) K f(K x,K y,K z,K z4,K z5,K z6,K z7,K z8)
#define yG y->G0
#define yF ((F*)yG)
#define yI ((I*)yG)
#define yJ ((J*)yG)
#define yK ((K*)yG)
// #define yg TX(G,y)
#define yf y->f
#define yi y->i
#define yj y->j
#define yn y->n
#define yt y->t
#define ys y->s
#define zG z->G0
#define zF ((F*)zG)
#define zI ((I*)zG)
#define zJ ((J*)zG)
#define zK ((K*)zG)
#define zg TX(G,z)
#define zf z->f
#define zi z->i
#define zj z->j
#define zn z->n
#define zs z->s
#define zt z->t
#define z4G z4->G0
#define z4F ((F*)z4G)
#define z4I ((I*)z4G)
#define z4K ((K*)z4G)
#define z4g TX(G,z4)
#define z4f z4->f
#define z4i z4->i
#define z4j z4->j
#define z4n z4->n
#define z4s z4->s
#define z5G z5->G0
#define z5I ((I*)z5G)
#define z5J ((J*)z5G)
#define z5E ((E*)z5G)
#define z5F ((F*)z5G)
#define z5f z5->f
#define z5g TX(G,z5)
#define z5i z5->i
#define z5j z5->j
#define z5n z5->n
#define z5s z5->s
#define z6G z6->G0
#define z6F ((F*)z6G)
#define z6I ((I*)z6G)
#define z6i z6->i
#define z6f z6->f
#define z6g TX(G,z6)
#define z6j z6->j
#define z6n z6->n
#define z6s z6->s
#define z6G z6->G0
#define z6I ((I*)z6G)
#define z6n z6->n
#define z7G z7->G0
#define z7F ((F*)z7G)
#define z7I ((I*)z7G)
#define z7J ((J*)z7G)
#define z7n z7->n
#define z7i z7->i
#define z7f z7->f
#define z7g TX(G,z7)
#define z7j z7->j
#define z8G z8->G0
#define z8F ((F*)z8G)
#define z8I ((I*)z8G)
#define z8n z8->n
#define z8i z8->i
#define z8j z8->j
#define z8f z8->f
#define z8g TX(G,z8)

#define DO2(n,x)	{J j=0,_j=(n);for(;j<_j;++j){x;}}
#define RZ R(K)0
#define KRR(x) krr(strerror(x))
#define CSTR(x) S s;if(x->t>0){s=(S)kC(x);s[x->n]='\0';}else{s=(S)&TX(G,x);s[1]='\0';} // x->n may be unset for n=1.
#define TC(x,T) P(x->t!=T,krr("type")) // typechecker
#define TC2(x,T,T2) P(x->t!=T&&x->t!=T2,krr("type"))
//~ #define IC(x) P(x->t==-KJ&&abs(x->j)>wi,krr("type")) //if(x->t==-KJ)x=ki((int)x->j); // j from i (=<0Wi).
//~ #define IJ(x) TC2(x,-KI,-KJ);IC(x); // I or J within I min/max.
//~ #define kIJ(x) TC2(x,KI,KJ);
#define tblsize(x)      (sizeof (x) / sizeof ((x) [0]))

Z K2(setcontlabelformat){pl_setcontlabelformat(xi,yi); RZ;}
Z K4(setcontlabelparam){pl_setcontlabelparam(xf,yf,zf,z4i); RZ;}
Z K1(adv){pladv(xi); RZ;}
Z K8(arc){plarc(xf,yf,zf,z4f,z5f,z6f,z7f,z8i); RZ;}
Z K8(axes){plaxes(xf,yf,zs,z4f,z5j,z6s,z7f,z8i); RZ;}
Z K4(bin){plbin(xi,yF,zF,z4i); RZ;}
Z K0(bop){plbop(); RZ;}
Z K6(box){plbox(xs,yf,zi,z4s,z5f,z6i); RZ;}
// xopt: xs; xlabel: xs; xtick: xf; nxsub: xi
// N.B. pl.box3[(`xopt;`lsxlabel;xtick;nxsub); (`yopt;`lsylabel;ytick;nysub); (`zopt;`lszlabel;ztick;nzsub)]
Z K3(box3){plbox3(kK(x)[0]->s,kK(x)[1]->s,kK(x)[2]->f,kK(x)[3]->j,
    kK(y)[0]->s,kK(y)[1]->s,kK(y)[2]->f,kK(y)[3]->i,
    kK(z)[0]->s,kK(z)[1]->s,kK(z)[2]->f,kK(z)[3]->j); RZ;}
Z K1(btime){PLINT year,month,day,hour,min; PLFLT sec; plbtime(&year,&month,&day,&hour,&min,&sec,xf);
    K rk=ktn(KS,6); K rv=ktn(0,6);
    kS(rk)[0]=ss("year"); kK(rv)[0]=ki(year);
    kS(rk)[1]=ss("month"); kK(rv)[1]=ki(month);
    kS(rk)[2]=ss("day"); kK(rv)[2]=ki(day);
    kS(rk)[3]=ss("hour"); kK(rv)[3]=ki(hour);
    kS(rk)[4]=ss("min"); kK(rv)[4]=ki(min);
    kS(rk)[5]=ss("sec"); kK(rv)[5]=kf(sec);
    R xD(rk,rv);}
Z K2(calc_world){PLFLT wx,wy; PLINT window; plcalc_world(xf,yf,&wx,&wy,&window);
    K rk=ktn(KS,3); K rv=ktn(0,3);
    kS(rk)[0]=ss("wx"); kK(rv)[0]=kf(wx);
    kS(rk)[1]=ss("wy"); kK(rv)[1]=kf(wy);
    kS(rk)[2]=ss("window"); kK(rv)[2]=ki(window);
    R xD(rk,rv);}
Z K0(clear){plclear(); RZ;}
Z K1(col0){plcol0(xi); RZ;}
Z K1(col1){plcol1(xf); RZ;}
// plcolorbar() has way too many args that are not foldable into 8.
// Users have to pass a dictionary whose entries are in the order of plcolorbar().
// We can do something like
//      I opt=k(0,"{x@y}",r1(x),ks("one"),(K)0)->i;
//      I opt=k(0,"{x[y]}",......
// but that is too much work.
#define A(i) kK(xy)[i]
// N.B. pl.colorbar[dict] where dict is made of all input args as keys and values. Returns a dict with keys p_colorbar_width and p_colorbar_height.
Z K1(colorbar){
    TC(x,XD);
    TC(xx,KS);
    TC(xy,0);
    PLFLT p_colorbar_width,p_colorbar_height;
    PLFLT**values;
    I nx=(I)A(21)->n;
    I ny=(I)kK(A(21))[0]->n;
    K v=A(21);
    plAlloc2dGrid(&values,nx,ny);
    DO(nx,DO2(ny,values[i][j]=kF(kK(v)[i])[j]));
    plcolorbar(&p_colorbar_width,&p_colorbar_height,
        A(0)->i,// opt (PLINT, input)
        A(1)->i,// position (PLINT, input)
        A(2)->f,// x (PLFLT, input)
        A(3)->f,// y (PLFLT, input)
        A(4)->f,// x_length (PLFLT, input)
        A(5)->f,// y_length (PLFLT, input)
        A(6)->i,// bg_color (PLINT, input)
        A(7)->i,// bb_color (PLINT, input)
        A(8)->i,// bb_style (PLINT, input)
        A(9)->f,// low_cap_color (PLFLT, input)
        A(10)->f,// high_cap_color (PLFLT, input)
        A(11)->i,// cont_color (PLINT, input)
        A(12)->f,// cont_width (PLFLT, input)
        A(13)->i,// n_labels (PLINT, input)
        kI(A(14)),// label_opts (const PLINT *, input)
        (const char * const *)kS(A(15)),// labels (const char * const *, input)
        A(16)->i,// n_axes (PLINT, input)
        (const char * const *)kS(A(17)),// axis_opts (const char * const *, input)
        kF(A(18)),// ticks (const PLFLT *, input)
        kI(A(19)),// sub_ticks (const PLINT *, input)
        kI(A(20)),// n_values (const PLINT *, input)
        (const PLFLT*const*)values); // values (const PLFLT * const *, input)
    plFree2dGrid(values,nx,ny);

    K rk=ktn(KS,2); K rv=ktn(KF,2);
    kS(rk)[0]=ss("p_colorbar_width"); kF(rv)[0]=p_colorbar_width;
    kS(rk)[1]=ss("p_colorbar_height"); kF(rv)[1]=p_colorbar_height;
    R xD(rk,rv);}
#undef A
Z K6(configtime){plconfigtime(xf,yf,zf,z4i,z5i,kK(z6)[0]->i,kK(z6)[1]->i,kK(z6)[2]->i,kK(z6)[3]->i,kK(z6)[4]->i,kK(z6)[5]->f); RZ;}
ZK mypltr;
ZV setpltr(K x){if(xt==XD+1){r1(x); mypltr=x;}else{mypltr=(K)0;}R;}
ZV unsetpltr(K x){if(xt==XD+1)r0(x); mypltr=(K)0; R;}
// Q version of mypltr:{[x;y;z] ... returns (tx;ty)}
ZV pltr(PLFLT x,PLFLT y,PLFLT* tx,PLFLT* ty,PLPointer p){
    K z=k(0,".",r1(mypltr),r1(knk(3,kf(x),kf(y),(K)p)),(K)0);
    r1(z);
    if(zt==-128){O("pltr k() error: %s\n",zs);}
    if(zt!=KF){O("type:%d\n",zt);}
    if(zn!=2){O("size:%lld\n",zn);}
    *tx=kF(z)[0]; *ty=kF(z)[1];}
// N.B. pl.cont[z; (kx;lx); (ky;ly); clevel; pltr; pltr_data]; / nlevel=count clevel
Z K6(cont){
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    setpltr(z5);
    plcont((const PLFLT*const*)f,nx,ny,kI(y)[0],kI(y)[1],kI(z)[0],kI(z)[1],z4F,z4n,mypltr?pltr:NULL,z6);
    plFree2dGrid(f,nx,ny);
    unsetpltr(z5); RZ;}
// N.B. pl.cont0[f; (kx;ly); (ky;ly); clevel]; / nlevel=count clevel; pltr0 called by qplplot.
Z K4(cont0){
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    plcont((const PLFLT*const*)f,nx,ny,kI(y)[0],kI(y)[1],kI(z)[0],kI(z)[1],z4F,z4n,pltr0,(V*)0);
    plFree2dGrid(f,nx,ny);
    RZ;}
#undef xg
// N.B. pl.cont1[z; (kx;ly); (ky;ly); clevel; xg1; yg1]; / nlevel=count clevel; pltr1 called by qplplot.
Z K6(cont1){PLcGrid g; g.xg=(PLFLT*)z5F; g.yg=(PLFLT*)z6F; g.nx=z5n; g.ny=z6n;
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    plcont((const PLFLT*const*)f,nx,ny,kI(y)[0],kI(y)[1],kI(z)[0],kI(z)[1],z4F,z4n,pltr1,&g);
    plFree2dGrid(f,nx,ny);
    RZ;}
// N.B. pl.cont2[f; (kx;ly); (ky;ly); clevel; xg2; yg2]; / nlevel=count clevel; pltr2 called by qplplot.
Z K6(cont2){PLcGrid2 g;
    g.nx=z5n;
    g.ny=kK(z5)[0]->n;
    PLFLT**xg;
    PLFLT**yg;
    plAlloc2dGrid(&xg,g.nx,g.ny);
    plAlloc2dGrid(&yg,g.nx,g.ny);
    DO(g.nx,DO2(g.ny,xg[i][j]=kF(kK(z5)[i])[j]; yg[i][j]=kF(kK(z6)[i])[j]));
    g.xg=xg;
    g.yg=yg;
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    plcont((const PLFLT*const*)f,nx,ny,kI(y)[0],kI(y)[1],kI(z)[0],kI(z)[1],z4F,z4n,pltr2,&g);
    plFree2dGrid(f,nx,ny);
    plFree2dGrid(xg,g.nx,g.ny);
    plFree2dGrid(yg,g.nx,g.ny);
    RZ;}
Z K2(cpstrm){plcpstrm(xi,yi); RZ;}
Z K6(ctime){PLFLT ctime; plctime(xi,yi,zi,z4i,z5i,z6f,&ctime); R r1(kf(ctime));}
Z K0(end){plend(); RZ;}
Z K0(end1){plend1(); RZ;}
Z K6(env0){plenv0(xf,yf,zf,z4f,z5f,z6i); RZ;}
Z K6(env){plenv(xf,yf,zf,z4f,z5i,z6i); RZ;}
Z K0(eop){pleop(); RZ;}
Z K4(errx){plerrx(xi,yF,zF,z4F); RZ;}
Z K4(erry){plerry(xi,yF,zF,z4F); RZ;}
Z K0(famadv){plfamadv(); RZ;}
Z K3(fill){plfill(xi,yF,zF); RZ;}
Z K4(fill3){plfill3(xi,yF,zF,z4F); RZ;}
Z K0(flush){plflush(); RZ;}
Z K1(font){plfont(xi); RZ;}
Z K1(fontld){plfontld(xi); RZ;}
Z K0(gchr){PLFLT p_def,p_ht; plgchr(&p_def,&p_ht);
    K rk=ktn(KS,2); K rv=ktn(KF,2);
    kS(rk)[0]=ss("p_def"); kF(rv)[0]=p_def;
    kS(rk)[1]=ss("p_ht"); kF(rv)[1]=p_ht;
    R xD(rk,rv);}
Z K0(gcmap1_range){PLFLT min_color,max_color; plgcmap1_range(&min_color,&max_color);
    K rk=ktn(KS,2); K rv=ktn(KF,2);
    kS(rk)[0]=ss("min_color"); kF(rv)[0]=min_color;
    kS(rk)[1]=ss("max_color"); kF(rv)[1]=max_color;
    R xD(rk,rv);}
Z K1(gcol0){PLINT r,g,b; plgcol0(xi,&r,&g,&b);
    K rk=ktn(KS,3); K rv=ktn(KI,3);
    kS(rk)[0]=ss("r"); kI(rv)[0]=r;
    kS(rk)[1]=ss("g"); kI(rv)[1]=g;
    kS(rk)[2]=ss("b"); kI(rv)[2]=b;
    R xD(rk,rv);}
Z K1(gcol0a){PLINT r,g,b; PLFLT a; plgcol0a(xi,&r,&g,&b,&a);
    K rk=ktn(KS,4); K rv=ktn(0,4);
    kS(rk)[0]=ss("r"); kK(rv)[0]=ki(r);
    kS(rk)[1]=ss("g"); kK(rv)[1]=ki(g);
    kS(rk)[2]=ss("b"); kK(rv)[2]=ki(b);
    kS(rk)[3]=ss("a"); kK(rv)[3]=kf(a);
    R xD(rk,rv);}
Z K0(gcolbg){PLINT r,g,b; plgcolbg(&r,&g,&b);
    K rk=ktn(KS,3); K rv=ktn(KI,3);
    kS(rk)[0]=ss("r"); kI(rv)[0]=r;
    kS(rk)[1]=ss("g"); kI(rv)[1]=g;
    kS(rk)[2]=ss("b"); kI(rv)[2]=b;
    R xD(rk,rv);}
Z K0(gcolbga){PLINT r,g,b; PLFLT a; plgcolbga(&r,&g,&b,&a);
    K rk=ktn(KS,4); K rv=ktn(0,4);
    kS(rk)[0]=ss("r"); kK(rv)[0]=ki(r);
    kS(rk)[1]=ss("g"); kK(rv)[1]=ki(g);
    kS(rk)[2]=ss("b"); kK(rv)[2]=ki(b);
    kS(rk)[3]=ss("a"); kK(rv)[3]=kf(a);
    R xD(rk,rv);}
Z K0(gcompression){PLINT output; plgcompression(&output); R r1(ki(output));}
Z K0(gdev){char v[80]; plgdev(v); R r1(ks(v));}
Z K0(gdidev){PLFLT p_mar,p_aspect,p_jx,p_jy; plgdidev(&p_mar,&p_aspect,&p_jx,&p_jy);
    K rk=ktn(KS,4); K rv=ktn(KF,4);
    kS(rk)[0]=ss("p_mar"); kF(rv)[0]=p_mar;
    kS(rk)[1]=ss("p_aspect"); kF(rv)[1]=p_aspect;
    kS(rk)[2]=ss("p_jx"); kF(rv)[2]=p_jx;
    kS(rk)[3]=ss("p_jy"); kF(rv)[3]=p_jy;
    R xD(rk,rv);}
Z K0(gdiori){PLFLT output; plgdiori(&output); R r1(kf(output));}
Z K0(gdiplt){PLFLT p_xmin,p_ymin,p_xmax,p_ymax; plgdiplt(&p_xmin,&p_ymin,&p_xmax,&p_ymax);
    K rk=ktn(KS,4); K rv=ktn(KF,4);
    kS(rk)[0]=ss("p_xmin"); kF(rv)[0]=p_xmin;
    kS(rk)[1]=ss("p_ymin"); kF(rv)[1]=p_ymin;
    kS(rk)[2]=ss("p_xmax"); kF(rv)[2]=p_xmax;
    kS(rk)[3]=ss("p_ymax"); kF(rv)[3]=p_ymax;
    R xD(rk,rv);}
Z K0(gdrawmode){R ki(plgdrawmode());}
Z K0(gfam){PLINT fam,num,bmax; plgfam(&fam,&num,&bmax);
    K rk=ktn(KS,3); K rv=ktn(KI,3);
    kS(rk)[0]=ss("fam"); kI(rv)[0]=fam;
    kS(rk)[1]=ss("num"); kI(rv)[1]=num;
    kS(rk)[2]=ss("bmax"); kI(rv)[2]=bmax;
    R xD(rk,rv);}
Z K0(gfci){PLUNICODE output; plgfci(&output); R r1(ki(output));}
Z K0(gfnam){char output[80]; plgfnam(output); R r1(ks(output));}
Z K0(gfont){PLINT p_family,p_style,p_weight; plgfont(&p_family,&p_style,&p_weight);
    K rk=ktn(KS,3); K rv=ktn(KI,3);
    kS(rk)[0]=ss("p_family"); kI(rv)[0]=p_family;
    kS(rk)[1]=ss("p_style"); kI(rv)[1]=p_style;
    kS(rk)[2]=ss("p_weight"); kI(rv)[2]=p_weight;
    R xD(rk,rv);}
Z K0(glevel){PLINT output; plglevel(&output); R r1(ki(output));}
Z K0(gpage){PLFLT xp,yp; PLINT xleng,yleng,xoff,yoff;
    plgpage(&xp,&yp,&xleng,&yleng,&xoff,&yoff);
    K rk=ktn(KS,6); K rv=ktn(0,6);
    kS(rk)[0]=ss("xp"); kK(rv)[0]=kf(xp);
    kS(rk)[1]=ss("yp"); kK(rv)[1]=kf(yp);
    kS(rk)[2]=ss("xleng"); kK(rv)[2]=ki(xleng);
    kS(rk)[3]=ss("yleng"); kK(rv)[3]=ki(yleng);
    kS(rk)[4]=ss("xoff"); kK(rv)[4]=ki(xoff);
    kS(rk)[5]=ss("yoff"); kK(rv)[5]=ki(yoff);
    R xD(rk,rv);}
Z K0(gra){plgra(); RZ;}
Z K4(gradient){plgradient(xi,yF,zF,z4f); RZ;}
Z K7(griddata){PLFLT**output; plAlloc2dGrid(&output,z4n,z5n);
    plgriddata(xF,yF,zF,xn,z4F,z4n,z5F,z5n,output,z6i,z7f);
    // convert output to a K matrix
    K m=knk(0,0); DO(z4n,jk(&m,ktn(KF,z5n)));
    DO(z4n,DO2(z5n,kF(kK(m)[i])[j]=output[i][j]));
    plFree2dGrid(output,z4n,z5n);
    R m;}
Z K0(gspa){PLFLT xmin,xmax,ymin,ymax; plgspa(&xmin,&xmax,&ymin,&ymax);
    K rk=ktn(KS,4); K rv=ktn(KF,4);
    kS(rk)[0]=ss("xmin"); kF(rv)[0]=xmin;
    kS(rk)[1]=ss("ymin"); kF(rv)[1]=ymin;
    kS(rk)[2]=ss("xmax"); kF(rv)[2]=xmax;
    kS(rk)[3]=ss("ymax"); kF(rv)[3]=ymax;
    R xD(rk,rv);}
Z K0(gstrm){PLINT p_strm; plgstrm(&p_strm); R r1(ki(p_strm));}
Z K0(gver){char v[80]; plgver(v); R r1(ks(v));}
Z K0(gvpd){PLFLT p_xmin,p_xmax,p_ymin,p_ymax; plgvpd(&p_xmin,&p_xmax,&p_ymin,&p_ymax);
    K rk=ktn(KS,4); K rv=ktn(KF,4);
    kS(rk)[0]=ss("p_xmin"); kF(rv)[0]=p_xmin;
    kS(rk)[1]=ss("p_ymin"); kF(rv)[1]=p_ymin;
    kS(rk)[2]=ss("p_xmax"); kF(rv)[2]=p_xmax;
    kS(rk)[3]=ss("p_ymax"); kF(rv)[3]=p_ymax;
    R xD(rk,rv);}
Z K0(gvpw){PLFLT p_xmin,p_xmax,p_ymin,p_ymax; plgvpw(&p_xmin,&p_xmax,&p_ymin,&p_ymax);
    K rk=ktn(KS,4); K rv=ktn(KF,4);
    kS(rk)[0]=ss("p_xmin"); kF(rv)[0]=p_xmin;
    kS(rk)[1]=ss("p_ymin"); kF(rv)[1]=p_ymin;
    kS(rk)[2]=ss("p_xmax"); kF(rv)[2]=p_xmax;
    kS(rk)[3]=ss("p_ymax"); kF(rv)[3]=p_ymax;
    R xD(rk,rv);}
Z K0(gxax){PLINT digmax,digits; plgxax(&digmax,&digits);
    K rk=ktn(KS,2); K rv=ktn(KI,2);
    kS(rk)[0]=ss("digmax"); kI(rv)[0]=digmax;
    kS(rk)[1]=ss("digits"); kI(rv)[1]=digits;
    R xD(rk,rv);}
Z K0(gyax){PLINT digmax,digits; plgyax(&digmax,&digits);
    K rk=ktn(KS,2); K rv=ktn(KI,2);
    kS(rk)[0]=ss("digmax"); kI(rv)[0]=digmax;
    kS(rk)[1]=ss("digits"); kI(rv)[1]=digits;
    R xD(rk,rv);}
Z K0(gzax){PLINT digmax,digits; plgzax(&digmax,&digits);
    K rk=ktn(KS,2); K rv=ktn(KI,2);
    kS(rk)[0]=ss("digmax"); kI(rv)[0]=digmax;
    kS(rk)[1]=ss("digits"); kI(rv)[1]=digits;
    R xD(rk,rv);}
Z K6(hist){plhist(xi,yF,zf,z4f,z5i,z6i); RZ;}
Z K3(hlsrgb){PLFLT p_r,p_g,p_b; plhlsrgb(xf,yf,zf,&p_r,&p_g,&p_b);
    K rk=ktn(KS,3); K rv=ktn(KF,3);
    kS(rk)[0]=ss("p_r"); kF(rv)[0]=p_r;
    kS(rk)[1]=ss("p_g"); kF(rv)[1]=p_g;
    kS(rk)[2]=ss("p_b"); kF(rv)[2]=p_b;
    R xD(rk,rv);}
// N.B. pl.imagefr[x; (xmin;xmax;ymin;ymax);(zmin;zmax);(valuemin;valuemax); pltr; pltr_data]
Z K5(imagefr){PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    setpltr(z5);
    plimagefr((const PLFLT**)f,nx,ny,
        kF(y)[0],kF(y)[1],kF(y)[2],kF(y)[3],
        kF(z)[0],kF(z)[1],
        kF(z4)[0],kF(z4)[1],
        mypltr?pltr:NULL,(V*)0);
    plFree2dGrid(f,nx,ny);
    RZ;}
// N.B. pl.imagefr0[x; (xmin;xmax;ymin;ymax);(zmin;zmax);(valuemin;valuemax)]
Z K4(imagefr0){PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    plimagefr((const PLFLT**)f,nx,ny,
        kF(y)[0],kF(y)[1],kF(y)[2],kF(y)[3],
        kF(z)[0],kF(z)[1],
        kF(z4)[0],kF(z4)[1],
        pltr0,(V*)0);
    plFree2dGrid(f,nx,ny);
    RZ;}
// N.B. pl.imagefr1[x; (xmin;xmax;ymin;ymax);(zmin;zmax);(valuemin;valuemax); xg1; yg1]
Z K6(imagefr1){PLcGrid g;
    g.nx=z5n;
    g.ny=z6n;
    g.xg=z5F;
    g.yg=z6F;
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    plimagefr((const PLFLT**)f,nx,ny,
        kF(y)[0],kF(y)[1],kF(y)[2],kF(y)[3],
        kF(z)[0],kF(z)[1],
        kF(z4)[0],kF(z4)[1],
        pltr1,&g);
    plFree2dGrid(f,nx,ny);
    RZ;}
// N.B. pl.imagefr2[x; (xmin;xmax;ymin;ymax);(zmin;zmax);(valuemin;valuemax); xg2; yg2]
Z K6(imagefr2){PLcGrid2 g;
    g.nx=z5n;
    g.ny=kK(z5)[0]->n;
    PLFLT**xg;
    PLFLT**yg;
    plAlloc2dGrid(&xg,g.nx,g.ny);
    plAlloc2dGrid(&yg,g.nx,g.ny);
    DO(g.nx,DO2(g.ny,xg[i][j]=kF(kK(z5)[i])[j]; yg[i][j]=kF(kK(z6)[i])[j]));
    g.xg=xg;
    g.yg=yg;
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    setpltr(z5);
    plimagefr((const PLFLT**)f,nx,ny,
        kF(y)[0],kF(y)[1],kF(y)[2],kF(y)[3],
        kF(z)[0],kF(z)[1],
        kF(z4)[0],kF(z4)[1],
        pltr2,&g);
    plFree2dGrid(f,nx,ny);
    plFree2dGrid(xg,g.nx,g.ny);
    plFree2dGrid(yg,g.nx,g.ny);
    RZ;}
// N.B. pl.image[x; (xmin;xmax; ymin;ymax);(zmin;zmax);(dxmin;dxmax;dymin;dymax)]
Z K4(image){PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    plimage((const PLFLT**)f,nx,ny,
        kF(y)[0],kF(y)[1],kF(y)[2],kF(y)[3],
        kF(z)[0],kF(z)[1],
        kF(z4)[0],kF(z4)[1],kF(z4)[2],kF(z4)[3]);
    plFree2dGrid(f,nx,ny);
    RZ;}
Z K0(init){plinit(); RZ;}
Z K4(join){pljoin(xf,yf,zf,z4f); RZ;}
Z K3(lab){pllab(xs,ys,zs); RZ;}
/*
pllegend(
p_legend_width, p_legend_height,
position,  opt,  x,  y,plot_width,
bg_color, bb_color, bb_style,
nrow, ncolumn, nlegend,
opt_array,
text_offset,text_scale, text_spacing, test_justification,text_colors,     text,     box_colors,     box_patterns,    box_scales,box_line_widths,
line_colors,line_styles,line_widths,
symbol_colors,symbol_scales,symbol_numbers,symbols)
*/
// N.B. pl.legend[(opt; position; x; y; plot_width); (bg_color; bb_color; bb_style); (nrow,ncolumn,nlegend); opt_array; (text_offset; text_scale;  text_spacing;  test_justification; text_colors; text); (box_colors; box_patterns; box_scales; box_line_widths); (line_colors; line_styles; line_widths); (symbol_colors; symbol_scales; symbol_numbers; symbols)]
Z K8(legend){
    PLFLT p_legend_width,p_legend_height;
    pllegend(&p_legend_width,&p_legend_height,// 1 2
        // (opt; position; x; y; plot_width) // 3 .. 8
        kK(x)[0]->i,kK(x)[1]->i,kK(x)[2]->f,kK(x)[3]->f,kK(x)[4]->f,
        // (bg_color; bb_color; bb_style) // 9 .. 11
        kI(y)[0],kI(y)[1],kI(y)[2],
        // (nrow,ncolumn,nlegend) // 12 .. 14
        kI(z)[0],kI(z)[1],kI(z)[2],
        //opt_array,// 15
        kI(z4),// kI -> kJ
        //(text_offset; text_scale;  text_spacing;  test_justification; text_colors; text) // 16 .. 20
        kK(z5)[0]->f,kK(z5)[1]->f,kK(z5)[2]->f,kK(z5)[3]->f,kI(kK(z5)[4]),(const char**)kS(kK(z5)[5]),
        // (box_colors; box_patterns; box_scales; box_line_widths); // 21 .. 24
        kI(kK(z6)[0]),kI(kK(z6)[1]),kF(kK(z6)[2]),kF(kK(z6)[3]),// kI -> kJ
        // (line_colors; line_styles; line_widths) // 25 .. 27
        kI(kK(z7)[0]),kI(kK(z7)[1]),kF(kK(z7)[2]),// kI -> kJ
        // (symbol_colors; symbol_scales; symbol_numbers; symbols) // 28 .. 31
        kI(kK(z8)[0]),kF(kK(z8)[1]),kI(kK(z8)[2]),(const char**)kS(kK(z8)[3])); // kI -> kJ
    RZ;}
Z K3(lightsource){pllightsource(xf,yf,zf); RZ;}
Z K3(line){plline(xi,yF,zF); RZ;}
Z K4(line3){plline3(xi,yF,zF,z4F); RZ;}
Z K1(lsty){pllsty(xi); RZ;}
Z K0(map){R krr("nyi");}
Z K6(meridians){plmeridians(NULL,xf,yf,zf,z4f,z5f,z6f);RZ;}
Z K6(mesh){PLFLT**f;
    I nx=(I)zn;
    I ny=(I)kK(z)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(z)[i])[j]));
    plmesh(xF,yF,(const PLFLT**)f,z4i,z5i,z6i);
    plFree2dGrid(f,nx,ny);
    RZ;}
Z K8(meshc){PLFLT**f;
    I nx=(I)zn;
    I ny=(I)kK(z)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(z)[i])[j]));
    plmeshc(xF,yF,(const PLFLT**)f,z4i,z5i,z6i,z7F,z8i);
    plFree2dGrid(f,nx,ny);
    RZ;}
Z K0(mkstrm){PLINT output; plmkstrm(&output); R r1(ki(output));}
Z K5(mtex){plmtex(xs,yf,zf,z4f,z5s); RZ;}
Z K5(mtex3){plmtex3(xs,yf,zf,z4f,z5s); RZ;}
Z K7(ot3d){PLFLT**f;
    I nx=(I)zn;
    I ny=(I)kK(z)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(z)[i])[j]));
    plot3d(xF,yF,(const PLFLT**)f,z4i,z5i,z6i,z7i);
    plFree2dGrid(f,nx,ny);
    RZ;}
Z K8(ot3dc){PLFLT**f;
    I nx=(I)zn;
    I ny=(I)kK(z)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(z)[i])[j]));
    plot3dc(xF,yF,(const PLFLT**)f,z4i,z5i,z6i,z7F,z8i);
    plFree2dGrid(f,nx,ny);
    RZ;}
Z K0(ot3dcl){R krr("nyi");}
Z K3(parseopts){I xint=xi; CSTR(y); plparseopts(&xint,(const char**)&s,zi); RZ;}
Z K3(pat){plpat(xi,yI,zI); RZ;}
Z K5(path){plpath(xi,yf,zf,z4f,z5f); RZ;}
Z K4(poin){plpoin(xi,yF,zF,z4i); RZ;}
Z K5(poin3){plpoin3(xi,yF,zF,z4F,z5i); RZ;}
Z K6(poly3){plpoly3(xi,yF,zF,z4F,(const PLBOOL *)z5I,z6g); RZ;}
Z K2(prec){plprec(xi,yi); RZ;}
Z K1(psty){plpsty(xi); RZ;}
Z K6(ptex){plptex(xf,yf,zf,z4f,z5f,z6s); RZ;}
// N.B. pl.ptex3[(x;y;z);(dx;dy;dz);(sx;sy;sz);just;text]
Z K5(ptex3){plptex3(kF(x)[0],kF(x)[1],kF(x)[2],
    kF(y)[0],kF(y)[1],kF(y)[2],kF(z)[0],kF(z)[1],kF(z)[2],
    z4f,z5s); RZ;}
Z K0(randd){R r1(kf(plrandd()));}
Z K0(replot){plreplot(); RZ;}
Z K3(rgbhls){PLFLT h,l,s; plrgbhls(xi,yi,zi,&h,&l,&s);
    K rk=ktn(KS,3); K rv=ktn(KF,3);
    kS(rk)[0]=ss("h"); kF(rv)[0]=h;
    kS(rk)[1]=ss("l"); kF(rv)[1]=l;
    kS(rk)[2]=ss("s"); kF(rv)[2]=s;
    R xD(rk,rv);}
Z K2(schr){plschr(xf,yf); RZ;}
Z K4(scmap0){plscmap0(xI,yI,zI,z4i); RZ;}
Z K5(scmap0a){plscmap0a(xI,yI,zI,z4F,z5i); RZ;}
Z K1(scmap0n){plscmap0n(xi); RZ;}
Z K2(scmap1_range){plscmap1_range(xf,yf); RZ;}
Z K4(scmap1){plscmap1(xI,yI,zI,z4i); RZ;}
Z K5(scmap1a){plscmap1a(xI,yI,zI,z4F,z5i); RZ;}
Z K7(scmap1l){plscmap1l(xi,yi,zF,z4F,z5F,z6F,(const PLBOOL*)z7I); RZ;}
Z K8(scmap1la){plscmap1la(xi,yi,zF,z4F,z5F,z6F,z7F,(const PLBOOL*)z8I); RZ;}
Z K1(scmap1n){plscmap1n(xi); RZ;}
Z K4(scol0){plscol0(xi,yi,zi,z4i); RZ;}
Z K5(scol0a){plscol0a(xi,yi,zi,z4i,z5f); RZ;}
Z K3(scolbg){plscolbg(xi,yi,zi); RZ;}
Z K4(scolbga){plscolbga(xi,yi,zi,z4f); RZ;}
Z K1(scolor){plscolor(xi); RZ;}
Z K1(scompression){plscompression(xi); RZ;}
Z K1(sdev){plsdev(xs); RZ;}
Z K4(sdidev){plsdidev(xf,yf,zf,z4f); RZ;}
Z K6(sdimap){plsdimap(xi,yi,zi,z4i,z5i,z6i); RZ;}
Z K1(sdiori){plsdiori(xf); RZ;}
Z K4(sdiplt){plsdiplt(xf,yf,zf,z4f); RZ;}
Z K4(sdiplz){plsdiplz(xf,yf,zf,z4f); RZ;}
Z K1(sdrawmode){plsdrawmode(xi); RZ;}
Z K1(seed){plseed(xi); RZ;} // XX plseed(unsigned int),not usual signed int.
Z K1(sesc){plsesc(xi); RZ;}
Z K2(setopt){R ki(plsetopt(xs,ys));}
Z K3(sfam){plsfam(xi,yi,zi); RZ;}
Z K1(sfnam){plsfnam(xs); RZ;}
Z K1(sfci){plsfci(xi); RZ;} // PLUNICODE unsigned 32-bit integer
Z K3(sfont){plsfont(xi,yi,zi); RZ;}

ZK mydefined;
ZV setdefined(K x){if(xt==XD+1){r1(x); mydefined=x;}else{mydefined=(K)0;}R;}
ZV unsetdefined(K x){if(xt==XD+1)r0(x); mydefined=(K)0; R;}
// Q version of defined:{[x;y] ... returns `int}
ZI defined(PLFLT x,PLFLT y){
    K z=k(0,".",r1(mydefined),r1(knk(2,kf(x),kf(y))),(K)0);
    r1(z);
    if(zt==-128){O("defined k() error: %s\n",zs);}
    if(zt!=-KI){O("type:%d\n",zt);}
    R zi;}
/* pl.shade args:
1   a (const PLFLT*const*); nx; ny
2   defined
3   xmin; xmax; ymin; ymax; shade_min; shade_max (PLFLT, input)
4   sh_cmap; sh_color; sh_width; min_color; min_width; max_color; max_width (PLFLT, input)
5   fill (void (*) (PLINT, const PLFLT *,const PLFLT *), input)
6   rectangular (PLBOOL, input)
7   pltr (void (*) (PLFLT,PLFLT,PLFLT *,PLFLT *,PLPointer) , input)
8   pltr_data (PLPointer, input) -- ignored.
 */
// N.B. pl.shade[a; defined; (xmin;xmax;ymin;ymax;shade_min;shade_max); (sh_cmap;sh_color;sh_width;min_color;min_width;min_color;max_color;max_width); fill; rectangular; pltr; pltr_data] / fill is ignored but left for future compatibility
Z K7(shade){
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    setdefined(y);
    z5=(K)0; // placeholder for plfill.
    setpltr(z7);
    plshade((const PLFLT*const*)f,nx,ny,
        mydefined?defined:NULL,
        kF(z)[0],kF(z)[1],kF(z)[2],kF(z)[3],kF(z)[4],kF(z)[5],
        kK(z4)[0]->i,// sh_cmap (PLINT)
        kK(z4)[1]->f,// sh_color (PLFLT)
        kK(z4)[2]->f,// sh_width (PLFLT)
        kK(z4)[3]->i,// min_color (PLINT)
        kK(z4)[4]->f,// min_width (PLFLT)
        kK(z4)[5]->i,// max_color (PLINT)
        kK(z4)[6]->f,// max_width (PLFLT)
        plfill,
        z6i,
        mypltr?pltr:NULL,
        (V*)0);
    unsetdefined(y); unsetpltr(z7);
    plFree2dGrid(f,nx,ny);
    RZ;}
// same as plshade above except that a is casted as (const PLFLT*).
// N.B. pl.shade1[a; defined; (xmin;xmax;ymin;ymax;shade_min;shade_max); (sh_cmap;sh_color;sh_width;min_color;min_width;min_color;max_color;max_width); fill; rectangular; pltr; pltr_data] / fill is ignored but left for future compatibility
Z K7(shade1){
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    PLFLT f[nx][ny];
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    setdefined(y);
    z5=(K)0; // placeholder for plfill.
    setpltr(z7);
    plshade1(&f[0][0],nx,ny,
        mydefined?defined:NULL,
        kF(z)[0],kF(z)[1],kF(z)[2],kF(z)[3],kF(z)[4],kF(z)[5],
        kK(z4)[0]->i,// sh_cmap (PLINT)
        kK(z4)[1]->f,// sh_color (PLFLT)
        kK(z4)[2]->f,// sh_width (PLFLT)
        kK(z4)[3]->i,// min_color (PLINT)
        kK(z4)[4]->f,// min_width (PLFLT)
        kK(z4)[5]->i,// max_color (PLINT)
        kK(z4)[6]->f,// max_width (PLFLT)
        plfill,
        z6i,
        mypltr?pltr:NULL,
        (V*)0);
    unsetdefined(y); unsetpltr(z7);
    RZ;}
/*
1   a (const PLFLT*const*); nx; ny
2   defined
3   xmin; xmax; ymin; ymax (PLFLT, input); clevel; nlevel;
4   fill_width(PLFLT); cont_color(PLINT),cont_width(PLFLT)
5   fill (void (*) (PLINT, const PLFLT *,const PLFLT *), input)
6   rectangular (PLBOOL, input)
7   pltr (void (*) (PLFLT,PLFLT,PLFLT *,PLFLT *,PLPointer) , input)
8   pltr_data (PLPointer, input)
 */
// N.B. pl.shades[a; defined; (xmin; xmax; ymin; ymax; clevel); (fill_width; cont_color; cont_width); fill; rectangular; pltr] /
Z K7(shades){
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    setdefined(y);
    z5=(K)0; // placeholder for plfill.
    setpltr(z7);
    plshades((const PLFLT*const*)f,nx,ny,
        mydefined?defined:NULL,
        kK(z)[0]->f,// xmin
        kK(z)[1]->f,// xmax
        kK(z)[2]->f,// ymin
        kK(z)[3]->f,// ymax
        kF(kK(z)[4]),// clevel
        kK(z)[4]->n,// nlevel
        kK(z4)[0]->f,// fill_width
        kK(z4)[1]->i,// cont_color
        kK(z4)[2]->f,// cont_width
        plfill,
        z6i,// rectengular
        mypltr?pltr:NULL,(V*)0);
    unsetdefined(y); unsetpltr(z7);
    plFree2dGrid(f,nx,ny);
    RZ;}
// N.B. pl.shades0[a; defined; (xmin; xmax; ymin; ymax; clevel); (fill_width; cont_color; cont_width); fill; rectangular] / pltr0 setby pl.shades0[]
Z K6(shades0){
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    setdefined(y);
    z5=(K)0; // placeholder for plfill.
    plshades((const PLFLT*const*)f,nx,ny,
        mydefined?defined:NULL,
        kK(z)[0]->f,// xmin
        kK(z)[1]->f,// xmax
        kK(z)[2]->f,// ymin
        kK(z)[3]->f,// ymax
        kF(kK(z)[4]),// clevel
        kK(z)[4]->n,// nlevel
        kK(z4)[0]->f,// fill_width
        kK(z4)[1]->i,// cont_color
        kK(z4)[2]->f,// cont_width
        plfill,
        z6i,// rectangular
        pltr0,(V*)0);
    unsetdefined(y);
    plFree2dGrid(f,nx,ny);
    RZ;}
// pl.shades1[a; defined; (xmin; xmax; ymin; ymax; clevel); (fill_width; cont_color; cont_width); fill; rectangular; xg1; yg1] / pltr1 setby pl.shades1[]
Z K8(shades1){PLcGrid g;
    g.nx=z7n;
    g.ny=z8n;
    g.xg=z7F;
    g.yg=z8F;
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    setdefined(y);
    z5=(K)0; // placeholder for plfill.
    plshades((const PLFLT*const*)f,nx,ny,
        mydefined?defined:NULL,
        kK(z)[0]->f,// xmin
        kK(z)[1]->f,// xmax
        kK(z)[2]->f,// ymin
        kK(z)[3]->f,// ymax
        kF(kK(z)[4]),// clevel
        kK(z)[4]->n,// nlevel
        kK(z4)[0]->f,// fill_width
        kK(z4)[1]->i,// cont_color
        kK(z4)[2]->f,// cont_width
        plfill,
        z6i,// rectangular
        pltr1,&g);
    unsetdefined(y);
    plFree2dGrid(f,nx,ny);
    RZ;}
// N.B. pl.shades2[a; defined; (xmin; xmax; ymin; ymax; clevel); (fill_width; cont_color; cont_width); fill; rectangular; xg2; yg2] / pltr2 setby pl.shades2[]
Z K8(shades2){PLcGrid2 g;
    g.nx=z7n;
    g.ny=kK(z7)[0]->n;
    PLFLT**xg;
    PLFLT**yg;
    plAlloc2dGrid(&xg,g.nx,g.ny);
    plAlloc2dGrid(&yg,g.nx,g.ny);
    DO(g.nx,DO2(g.ny,xg[i][j]=kF(kK(z7)[i])[j]; yg[i][j]=kF(kK(z8)[i])[j]));
    g.xg=xg;
    g.yg=yg;
    PLFLT**f;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&f,nx,ny);
    DO(nx,DO2(ny,f[i][j]=kF(kK(x)[i])[j]));
    setdefined(y);
    z5=(K)0; // placeholder for plfill.
    plshades((const PLFLT*const*)f,nx,ny,
        mydefined?defined:NULL,
        kK(z)[0]->f,// xmin
        kK(z)[1]->f,// xmax
        kK(z)[2]->f,// ymin
        kK(z)[3]->f,// ymax
        kF(kK(z)[4]),// clevel
        kK(z)[4]->n,// nlevel
        kK(z4)[0]->f,// fill_width
        kK(z4)[1]->i,// cont_color
        kK(z4)[2]->f,// cont_width
        plfill,
        z6i,// rectangular
        pltr2,&g);
    unsetdefined(y);
    plFree2dGrid(f,nx,ny);
    plFree2dGrid(xg,g.nx,g.ny);
    plFree2dGrid(yg,g.nx,g.ny);
    RZ;}
Z K0(slabelfunc){R krr("nyi");}
Z K2(smaj){plsmaj(xf,yf); RZ;}
Z K0(smem){R krr("nyi");}
Z K0(smema){R krr("nyi");}
Z K2(smin){plsmin(xf,yf); RZ;}
Z K1(sori){plsori(xi); RZ;}
Z K6(spage){plspage(xf,yf,zi,z4i,z5i,z6i); RZ;}
Z K1(spal0){plspal0(xs); RZ;}
Z K2(spal1){plspal1(xs,yi); RZ;} // c_plspal1(xs,yi)??
Z K1(spause){plspause((PLBOOL)xi); RZ;}
Z K1(sstrm){plsstrm(xi); RZ;}
Z K2(ssub){plssub(xi,yi); RZ;}
Z K2(ssym){plssym(xf,yf); RZ;}
Z K2(star){plstar(xi,yi); RZ;}
Z K3(start){plstart(xs,yi,zi); RZ;}
ZK mytransform;
// Q version of transform:{[x;y;z] ... returns (tx;ty)}
ZV transform(PLFLT x,PLFLT y,PLFLT* tx,PLFLT* ty,PLPointer p){
    K z=k(0,".",r1(mytransform),r1(knk(3,kf(x),kf(y),(K)p)),(K)0);
    r1(z);
    if(zt==-128){O("transform k() error: %s\n",zs);}
    if(zt!=KF){O("type:%d\n",zt);}
    if(zn!=2){O("size:%lld\n",zn);}
    *tx=kF(z)[0]; *ty=kF(z)[1];}
Z K2(stransform){if(xt==XD+1){r1(x); mytransform=x; plstransform(transform,y);}
    else{plstransform(NULL,NULL);} RZ;}
Z K4(string){plstring(xi,yF,zF,z4s); RZ;}
Z K5(string3){plstring3(xi,yF,zF,z4F,z5s); RZ;}
Z K4(stripa){plstripa(xi,yi,zf,z4f); RZ;}
/*
N.B. id:pl.stripc[(xspec;yspec); (xmin;xmax;xjump; ymin;ymax); (xlpos;ylpos); (y_ascl;acc); (colbox;collab); (colline;styline;legline); (labx;laby;labtop)]
        autoy; acc;
        colbox; collab;
        colline; styline; legline;
        `$"t"; `$""; `$"Strip chart demo"];
*/
Z K7(stripc){PLINT id;
    plstripc(&id,
        kS(x)[0],kS(x)[1],// (xspec;yspec),
        kF(y)[0],kF(y)[1],kF(y)[2],kF(y)[3],kF(y)[4],// (xmin;xmax;xjump; ymin;ymax),
        kF(z)[0],kF(z)[1],// (xlpos;ylpos),
        kI(z4)[0],kI(z4)[1],// y_ascl; acc;
        kI(z5)[0],kI(z5)[1],// colbox; collab;
        kI(kK(z6)[0]),kI(kK(z6)[1]),(const char**) kS(kK(z6)[2]),//colline; styline; legline;
        kS(z7)[0],kS(z7)[1],kS(z7)[2]); // (labx;laby;labtop) );
    R r1(ki(id));}
Z K1(stripd){plstripd(xi); RZ;}
Z K3(styl){plstyl(xi,yI,zI); RZ;}
// N.B. pl.surf3d[x; y; z; opt; clevel]
Z K5(surf3d){
    PLFLT**f;
    I znx=zn,zny=kK(z)[0]->n;
    plAlloc2dGrid(&f,znx,zny);
    DO(znx,DO2(zny,f[i][j]=kF(kK(z)[i])[j]));
    plsurf3d(xF,yF,(const PLFLT*const*)f,znx,zny,z4i,z5F,z5n);
    plFree2dGrid(f,znx,zny);
    RZ;}
// N.B. pl.surf3dl[x; y; z; opt; clevel; (indexxmin;indexxmax); indexymin; indexymax]
Z K8(surf3dl){
    PLFLT**f;
    I znx=zn,zny=kK(z)[0]->n;
    plAlloc2dGrid(&f,znx,zny);
    DO(znx,DO2(zny,f[i][j]=kF(kK(z)[i])[j]));
    plsurf3dl(xF,yF,(const PLFLT*const*)f,znx,zny,z4i,z5F,z5n,kI(z6)[0],kI(z6)[1],kI(z7),kI(z8));
    plFree2dGrid(f,znx,zny);
    RZ;}
// N.B. pl.fsurf3d[x; y; z; opt; clevel]
Z K5(fsurf3d){
    PLFLT**f;
    I znx=zn,zny=kK(z)[0]->n;
    plAlloc2dGrid(&f,znx,zny);
    DO(znx,DO2(zny,f[i][j]=kF(kK(z)[i])[j]));
    plfsurf3d(xF,yF,plf2ops_c(),f,znx,zny,z4i,z5F,z5n);
    plFree2dGrid(f,znx,zny);
    RZ;}
Z K4(svect){plsvect(xF,yF,zi,z4i); RZ;}
Z K4(svpa){plsvpa(xf,yf,zf,z4f); RZ;}
Z K2(sxax){plsxax(xi,yi); RZ;}
Z K2(syax){plsyax(xi,yi); RZ;}
Z K4(sym){plsym(xi,yF,zF,z4i); RZ;}
Z K2(szax){plszax(xi,yi); RZ;}
Z K0(text){pltext(); RZ;}
Z K1(timefmt){pltimefmt(xs); RZ;}
Z K1(vasp){plvasp(xf); RZ;}
// N.B. pl.vect[u; v; scale; pltr]; / nx=count u; ny=count v;
Z K4(vect){
    PLFLT**u,**v;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&u,nx,ny);
    plAlloc2dGrid(&v,nx,ny);
    DO(nx,DO2(ny,u[i][j]=kF(kK(x)[i])[j]; v[i][j]=kF(kK(y)[i])[j]));
    setpltr(z4);
    plvect((const PLFLT*const*)u,(const PLFLT*const*)v,nx,ny,zf,mypltr?pltr:NULL,(V*)0);
    plFree2dGrid(u,nx,ny);
    plFree2dGrid(v,nx,ny);
    unsetpltr(z4); RZ;}
// N.B. pl.vect0[u; v; scale]; / nx=count u; ny=count v; pltr0 set by plvect.
Z K3(vect0){
    PLFLT**u,**v;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&u,nx,ny);
    plAlloc2dGrid(&v,nx,ny);
    DO(nx,DO2(ny,u[i][j]=kF(kK(x)[i])[j]; v[i][j]=kF(kK(y)[i])[j]));
    plvect((const PLFLT*const*)u,(const PLFLT*const*)v,nx,ny,zf,pltr0,(V*)0);
    plFree2dGrid(u,nx,ny);
    plFree2dGrid(v,nx,ny);
    RZ;}
#undef xg
// N.B. pl.vect1[u; v; scale; xg1; yg1]; / nx=count u; ny=count v; pltr1 set by plvect.
Z K5(vect1){PLcGrid g;
    g.xg=(PLFLT*)z4F;
    g.yg=(PLFLT*)z5F;
    g.nx=z4n;
    g.ny=z5n;
    PLFLT**u,**v;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&u,nx,ny);
    plAlloc2dGrid(&v,nx,ny);
    DO(nx,DO2(ny,u[i][j]=kF(kK(x)[i])[j]; v[i][j]=kF(kK(y)[i])[j]));
    plvect((const PLFLT*const*)u,(const PLFLT*const*)v,nx,ny,zf,pltr1,&g);
    plFree2dGrid(u,nx,ny);
    plFree2dGrid(v,nx,ny);
    RZ;}
// N.B. pl.vect2[u; v; scale; xg2; yg2]; / nx=count u; ny=count v; pltr2 set by plvect.
Z K5(vect2){PLcGrid2 g;
    g.nx=z4n;
    g.ny=kK(z4)[0]->n;
    PLFLT**xg;
    PLFLT**yg;
    plAlloc2dGrid(&xg,g.nx,g.ny);
    plAlloc2dGrid(&yg,g.nx,g.ny);
    DO(g.nx,DO2(g.ny,xg[i][j]=kF(kK(z4)[i])[j]; yg[i][j]=kF(kK(z5)[i])[j]));
    g.xg=xg;
    g.yg=yg;
    PLFLT**u,**v;
    I nx=(I)xn;
    I ny=(I)kK(x)[0]->n;
    plAlloc2dGrid(&u,nx,ny);
    plAlloc2dGrid(&v,nx,ny);
    DO(nx,DO2(ny,u[i][j]=kF(kK(x)[i])[j]; v[i][j]=kF(kK(y)[i])[j]));
    plvect((const PLFLT*const*)u,(const PLFLT*const*)v,nx,ny,zf,pltr2,&g);
    plFree2dGrid(u,nx,ny);
    plFree2dGrid(v,nx,ny);
    plFree2dGrid(xg,g.nx,g.ny);
    plFree2dGrid(yg,g.nx,g.ny);
    RZ;}
// redefine xg
#define xg TX(G,x)
Z K5(vpas){plvpas(xf,yf,zf,z4f,z5f); RZ;}
Z K4(vpor){plvpor(xf,yf,zf,z4f); RZ;}
Z K0(vsta){plvsta(); RZ;}
// N.B. pl.w3d[(basex;basey;height); (xmin;xmax;ymin;ymax;zmin;zmax); (alt;az)]
Z K3(w3d){plw3d(kF(x)[0],kF(x)[1],kF(x)[2],
    kF(y)[0],kF(y)[1],kF(y)[2],kF(y)[3],kF(y)[4],kF(y)[5],
    kF(z)[0],kF(z)[1]); RZ;}
Z K1(width){plwidth(xf); RZ;}
Z K4(wind){plwind(xf,yf,zf,z4f); RZ;}
Z K1(xormod){PLBOOL status; plxormod(xi,&status); R r1(kg(status));}
typedef struct {S apiname; S fnname; V* fn; I argc;} qzpi; // apiname because reflection is impossible.
Z qzpi plplotapi[]={
    {"pl","adv",adv,1},
    {"pl","arc",arc,8},
    {"pl","axes",axes,8},
    {"pl","bin",bin,4},
    {"pl","bop",bop,0},
    {"pl","box",box,6},
    {"pl","box3",box3,3},
    {"pl","btime",btime,1},
    {"pl","calc_world",calc_world,2},
    {"pl","clear",clear,0},
    {"pl","col0",col0,1},
    {"pl","col1",col1,1},
    {"pl","colorbar",colorbar,1},
    {"pl","configtime",configtime,6},
    {"pl","cont",cont,6},
    {"pl","cont0",cont0,4},
    {"pl","cont1",cont1,6},
    {"pl","cont2",cont2,6},
    {"pl","cpstrm",cpstrm,2},
    {"pl","ctime",ctime,6},
    {"pl","end1",end1,0},
    {"pl","end",end,0},
    {"pl","env0",env0,6},
    {"pl","env",env,6},
    {"pl","eop",eop,0},
    {"pl","errx",errx,4},
    {"pl","erry",erry,4},
    {"pl","famadv",famadv,0},
    {"pl","fill3",fill3,4},
    {"pl","fill",fill,3},
    {"pl","flush",flush,0},
    {"pl","font",font,1},
    {"pl","fontld",fontld,1},
    {"pl","gchr",gchr,1},
    {"pl","gcmap1_range",gcmap1_range,0},
    {"pl","gcol0",gcol0,1},
    {"pl","gcol0a",gcol0a,1},
    {"pl","gcolbg",gcolbg,0},
    {"pl","gcolbga",gcolbga,0},
    {"pl","gcompression",gcompression,0},
    {"pl","gdev",gdev,1},
    {"pl","gdidev",gdidev,1},
    {"pl","gdiori",gdiori,0},
    {"pl","gdiplt",gdiplt,1},
    {"pl","gdrawmode",gdrawmode,0},
    {"pl","gfam",gfam,0},
    {"pl","gfci",gfci,0},
    {"pl","gfnam",gfnam,0},
    {"pl","gfont",gfont,0},
    {"pl","glevel",glevel,0},
    {"pl","gpage",gpage,0},
    {"pl","gra",gra,0},
    {"pl","gradient",gradient,4},
    {"pl","griddata",griddata,7},
    {"pl","gspa",gspa,1},
    {"pl","gstrm",gstrm,0},
    {"pl","gver",gver,0},
    {"pl","gvpd",gvpd,0},
    {"pl","gvpw",gvpw,0},
    {"pl","gxax",gxax,0},
    {"pl","gyax",gyax,0},
    {"pl","gzax",gzax,0},
    {"pl","hist",hist,6},
    {"pl","hlsrgb",hlsrgb,3},
    {"pl","image",image,4},
    {"pl","imagefr",imagefr,0},
    {"pl","imagefr0",imagefr0,0},
    {"pl","imagefr1",imagefr1,0},
    {"pl","imagefr2",imagefr2,0},
    {"pl","init",init,0},
    {"pl","join",join,4},
    {"pl","lab",lab,3},
    {"pl","legend",legend,8},
    {"pl","lightsource",lightsource,3},
    {"pl","line3",line3,4},
    {"pl","line",line,3},
    {"pl","lsty",lsty,1},
    {"pl","map",map,0},
    {"pl","meridians",meridians,0},
    {"pl","mesh",mesh,6},
    {"pl","meshc",meshc,8},
    {"pl","mkstrm",mkstrm,0},
    {"pl","mtex3",mtex3,5},
    {"pl","mtex",mtex,5},
    {"pl","ot3d",ot3d,7},
    {"pl","ot3dc",ot3dc,8},
    {"pl","ot3dcl",ot3dcl,0},
    {"pl","parseopts",parseopts,3},
    {"pl","pat",pat,3},
    {"pl","path",path,5},
    {"pl","poin3",poin3,5},
    {"pl","poin",poin,4},
    {"pl","poly3",poly3,6},
    {"pl","prec",prec,2},
    {"pl","psty",psty,1},
    {"pl","ptex3",ptex3,0},
    {"pl","ptex",ptex,6},
    {"pl","randd",randd,0},
    {"pl","replot",replot,0},
    {"pl","rgbhls",rgbhls,0},
    {"pl","schr",schr,2},
    {"pl","scmap0",scmap0,4,},
    {"pl","scmap0a",scmap0a,5},
    {"pl","scmap0n",scmap0n,1},
    {"pl","scmap1",scmap1,4},
    {"pl","scmap1a",scmap1a,5},
    {"pl","scmap1l",scmap1l,7},
    {"pl","scmap1la",scmap1la,8},
    {"pl","scmap1n",scmap1n,1},
    {"pl","scmap1_range",scmap1_range,1},
    {"pl","scol0",scol0,4},
    {"pl","scol0a",scol0a,5},
    {"pl","scolbg",scolbg,3},
    {"pl","scolbga",scolbga,4},
    {"pl","scolor",scolor,1},
    {"pl","scompression",scompression,1},
    {"pl","sdev",sdev,1},
    {"pl","sdidev",sdidev,4},
    {"pl","sdimap",sdimap,6},
    {"pl","sdiori",sdiori,1},
    {"pl","sdiplt",sdiplt,4},
    {"pl","sdiplz",sdiplz,4},
    {"pl","sdrawmode",sdrawmode,1},
    {"pl","seed",seed,1},
    {"pl","sesc",sesc,1},
    {"pl","setopt",setopt,2},
    {"pl","setcontlabelparam",setcontlabelparam,4},
    {"pl","setcontlabelformat",setcontlabelformat,2},
    {"pl","sfci",sfci,1},
    {"pl","sfam",sfam,3},
    {"pl","sfnam",sfnam,1},
    {"pl","sfont",sfont,3},
    {"pl","shade1",shade1,7},
    {"pl","shade",shade,7},
    {"pl","shades",shades,7},
    {"pl","shades0",shades0,6},
    {"pl","shades1",shades1,8},
    {"pl","shades2",shades2,8},
    {"pl","slabelfunc",slabelfunc,0},
    {"pl","smaj",smaj,2},
    {"pl","smem",smem,0},
    {"pl","smema",smema,0},
    {"pl","smin",smin,2},
    {"pl","sori",sori,1},
    {"pl","spage",spage,6},
    {"pl","spal0",spal0,1},
    {"pl","spal1",spal1,2},
    {"pl","spause",spause,1},
    {"pl","sstrm",sstrm,1},
    {"pl","ssub",ssub,2},
    {"pl","ssym",ssym,2},
    {"pl","star",star,2},
    {"pl","start",start,3},
    {"pl","stransform",stransform,2},
    {"pl","string",string,4},
    {"pl","string3",string3,5},
    {"pl","stripa",stripa,4},
    {"pl","stripc",stripc,7},
    {"pl","stripd",stripd,1},
    {"pl","styl",styl,3},
    {"pl","fsurf3d",fsurf3d,5},
    {"pl","surf3d",surf3d,5},
    {"pl","surf3dl",surf3dl,8},
    {"pl","svect",svect,4},
    {"pl","svpa",svpa,4},
    {"pl","sxax",sxax,2},
    {"pl","syax",syax,2},
    {"pl","sym",sym,4},
    {"pl","szax",szax,2},
    {"pl","text",text,0},
    {"pl","timefmt",timefmt,1},
    {"pl","vasp",vasp,1},
    {"pl","vect",vect,4},
    {"pl","vect0",vect0,3},
    {"pl","vect1",vect1,5},
    {"pl","vect2",vect2,5},
    {"pl","vpas",vpas,5},
    {"pl","vpor",vpor,4},
    {"pl","vsta",vsta,0},
    {"pl","w3d",w3d,3},
    {"pl","width",width,1},
    {"pl","wind",wind,4},
    {"pl","xormod",xormod,1},
    {NULL,NULL,NULL,0}};

// if argc==0,set it to 1 otherwise 'rank
#define APITAB(fnname,fn,argc) xS[i]=ss(fnname);kK(y)[i]=dl(fn,argc>0?argc:1)
// notice the -1 for the NULL sentinals in *api[]
#define EXPAPI(name) K1(name){int n=tblsize(name##api)-1; K y=ktn(0,n);x=ktn(KS,n); \
    DO(n,APITAB(name##api[i].fnname,name##api[i].fn,name##api[i].argc)); \
    R xD(x,y);}

EXPAPI(plplot);
