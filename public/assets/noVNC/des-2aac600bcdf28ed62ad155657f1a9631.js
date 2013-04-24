/*
 * Ported from Flashlight VNC ActionScript implementation:
 *     http://www.wizhelp.com/flashlight-vnc/
 *
 * Full attribution follows:
 *
 * -------------------------------------------------------------------------
 *
 * This DES class has been extracted from package Acme.Crypto for use in VNC.
 * The unnecessary odd parity code has been removed.
 *
 * These changes are:
 *  Copyright (C) 1999 AT&T Laboratories Cambridge.  All Rights Reserved.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *

 * DesCipher - the DES encryption method
 *
 * The meat of this code is by Dave Zimmerman <dzimm@widget.com>, and is:
 *
 * Copyright (c) 1996 Widget Workshop, Inc. All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * and its documentation for NON-COMMERCIAL or COMMERCIAL purposes and
 * without fee is hereby granted, provided that this copyright notice is kept 
 * intact. 
 * 
 * WIDGET WORKSHOP MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
 * OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 * TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE, OR NON-INFRINGEMENT. WIDGET WORKSHOP SHALL NOT BE LIABLE
 * FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR
 * DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
 * 
 * THIS SOFTWARE IS NOT DESIGNED OR INTENDED FOR USE OR RESALE AS ON-LINE
 * CONTROL EQUIPMENT IN HAZARDOUS ENVIRONMENTS REQUIRING FAIL-SAFE
 * PERFORMANCE, SUCH AS IN THE OPERATION OF NUCLEAR FACILITIES, AIRCRAFT
 * NAVIGATION OR COMMUNICATION SYSTEMS, AIR TRAFFIC CONTROL, DIRECT LIFE
 * SUPPORT MACHINES, OR WEAPONS SYSTEMS, IN WHICH THE FAILURE OF THE
 * SOFTWARE COULD LEAD DIRECTLY TO DEATH, PERSONAL INJURY, OR SEVERE
 * PHYSICAL OR ENVIRONMENTAL DAMAGE ("HIGH RISK ACTIVITIES").  WIDGET WORKSHOP
 * SPECIFICALLY DISCLAIMS ANY EXPRESS OR IMPLIED WARRANTY OF FITNESS FOR
 * HIGH RISK ACTIVITIES.
 *
 *
 * The rest is:
 *
 * Copyright (C) 1996 by Jef Poskanzer <jef@acme.com>.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * Visit the ACME Labs Java page for up-to-date versions of this and other
 * fine Java utilities: http://www.acme.com/java/
 */
"use strict";function DES(e){function t(e){var t,i,n,s,o,r,a,l,c,h,u=[],d=[],f=[];for(i=0,n=56;56>i;++i,n-=8)n+=-5>n?65:-3>n?31:-1>n?63:27===n?35:0,s=7&n,u[i]=0!==(e[n>>>3]&1<<s)?1:0;for(t=0;16>t;++t){for(s=t<<1,o=s+1,f[s]=f[o]=0,r=28;59>r;r+=28)for(i=r-28;r>i;++i)n=i+b[t],d[i]=r>n?u[n]:u[n-28];for(i=0;24>i;++i)0!==d[_[i]]&&(f[s]|=1<<23-i),0!==d[_[i+24]]&&(f[o]|=1<<23-i)}for(t=0,c=0,h=0;16>t;++t)a=f[c++],l=f[c++],y[h]=(16515072&a)<<6,y[h]|=(4032&a)<<10,y[h]|=(16515072&l)>>>10,y[h]|=(4032&l)>>>6,++h,y[h]=(258048&a)<<12,y[h]|=(63&a)<<16,y[h]|=(258048&l)>>>4,y[h]|=63&l,++h}function i(e){var t,i,n,s,o=0,r=e.slice(),a=0;for(i=r[o++]<<24|r[o++]<<16|r[o++]<<8|r[o++],n=r[o++]<<24|r[o++]<<16|r[o++]<<8|r[o++],s=252645135&(i>>>4^n),n^=s,i^=s<<4,s=65535&(i>>>16^n),n^=s,i^=s<<16,s=858993459&(n>>>2^i),i^=s,n^=s<<2,s=16711935&(n>>>8^i),i^=s,n^=s<<8,n=n<<1|1&n>>>31,s=2863311530&(i^n),i^=s,n^=s,i=i<<1|1&i>>>31,o=0;8>o;++o)s=n<<28|n>>>4,s^=y[a++],t=m[63&s],t|=p[63&s>>>8],t|=d[63&s>>>16],t|=h[63&s>>>24],s=n^y[a++],t|=v[63&s],t|=g[63&s>>>8],t|=f[63&s>>>16],t|=u[63&s>>>24],i^=t,s=i<<28|i>>>4,s^=y[a++],t=m[63&s],t|=p[63&s>>>8],t|=d[63&s>>>16],t|=h[63&s>>>24],s=i^y[a++],t|=v[63&s],t|=g[63&s>>>8],t|=f[63&s>>>16],t|=u[63&s>>>24],n^=t;for(n=n<<31|n>>>1,s=2863311530&(i^n),i^=s,n^=s,i=i<<31|i>>>1,s=16711935&(i>>>8^n),n^=s,i^=s<<8,s=858993459&(i>>>2^n),n^=s,i^=s<<2,s=65535&(n>>>16^i),i^=s,n^=s<<16,s=252645135&(n>>>4^i),i^=s,n^=s<<4,s=[n,i],o=0;8>o;o++)r[o]=(s[o>>>2]>>>8*(3-o%4))%256,0>r[o]&&(r[o]+=256);return r}function n(e){return i(e.slice(0,8)).concat(i(e.slice(8,16)))}var s,o,r,a,l,c,h,u,d,f,p,g,m,v,_=[13,16,10,23,0,4,2,27,14,5,20,9,22,18,11,3,25,7,15,6,26,19,12,1,40,51,30,36,46,54,29,39,50,44,32,47,43,48,38,55,33,52,45,41,49,35,28,31],b=[1,2,4,6,8,10,12,14,15,17,19,21,23,25,27,28],C=0,y=[];return s=65536,o=1<<24,r=s|o,a=4,l=1024,c=a|l,h=[r|l,C|C,s|C,r|c,r|a,s|c,C|a,s|C,C|l,r|l,r|c,C|l,o|c,r|a,o|C,C|a,C|c,o|l,o|l,s|l,s|l,r|C,r|C,o|c,s|a,o|a,o|a,s|a,C|C,C|c,s|c,o|C,s|C,r|c,C|a,r|C,r|l,o|C,o|C,C|l,r|a,s|C,s|l,o|a,C|l,C|a,o|c,s|c,r|c,s|a,r|C,o|c,o|a,C|c,s|c,r|l,C|c,o|l,o|l,C|C,s|a,s|l,C|C,r|a],s=1<<20,o=1<<31,r=s|o,a=32,l=32768,c=a|l,u=[r|c,o|l,C|l,s|c,s|C,C|a,r|a,o|c,o|a,r|c,r|l,o|C,o|l,s|C,C|a,r|a,s|l,s|a,o|c,C|C,o|C,C|l,s|c,r|C,s|a,o|a,C|C,s|l,C|c,r|l,r|C,C|c,C|C,s|c,r|a,s|C,o|c,r|C,r|l,C|l,r|C,o|l,C|a,r|c,s|c,C|a,C|l,o|C,C|c,r|l,s|C,o|a,s|a,o|c,o|a,s|a,s|l,C|C,o|l,C|c,o|C,r|a,r|c,s|l],s=1<<17,o=1<<27,r=s|o,a=8,l=512,c=a|l,d=[C|c,r|l,C|C,r|a,o|l,C|C,s|c,o|l,s|a,o|a,o|a,s|C,r|c,s|a,r|C,C|c,o|C,C|a,r|l,C|l,s|l,r|C,r|a,s|c,o|c,s|l,s|C,o|c,C|a,r|c,C|l,o|C,r|l,o|C,s|a,C|c,s|C,r|l,o|l,C|C,C|l,s|a,r|c,o|l,o|a,C|l,C|C,r|a,o|c,s|C,o|C,r|c,C|a,s|c,s|l,o|a,r|C,o|c,C|c,r|C,s|c,C|a,r|a,s|l],s=8192,o=1<<23,r=s|o,a=1,l=128,c=a|l,f=[r|a,s|c,s|c,C|l,r|l,o|c,o|a,s|a,C|C,r|C,r|C,r|c,C|c,C|C,o|l,o|a,C|a,s|C,o|C,r|a,C|l,o|C,s|a,s|l,o|c,C|a,s|l,o|l,s|C,r|l,r|c,C|c,o|l,o|a,r|C,r|c,C|c,C|C,C|C,r|C,s|l,o|l,o|c,C|a,r|a,s|c,s|c,C|l,r|c,C|c,C|a,s|C,o|a,s|a,r|l,o|c,s|a,s|l,o|C,r|a,C|l,o|C,s|C,r|l],s=1<<25,o=1<<30,r=s|o,a=256,l=1<<19,c=a|l,p=[C|a,s|c,s|l,r|a,C|l,C|a,o|C,s|l,o|c,C|l,s|a,o|c,r|a,r|l,C|c,o|C,s|C,o|l,o|l,C|C,o|a,r|c,r|c,s|a,r|l,o|a,C|C,r|C,s|c,s|C,r|C,C|c,C|l,r|a,C|a,s|C,o|C,s|l,r|a,o|c,s|a,o|C,r|l,s|c,o|c,C|a,s|C,r|l,r|c,C|c,r|C,r|c,s|l,C|C,o|l,r|C,C|c,s|a,o|a,C|l,C|C,o|l,s|c,o|a],s=1<<22,o=1<<29,r=s|o,a=16,l=16384,c=a|l,g=[o|a,r|C,C|l,r|c,r|C,C|a,r|c,s|C,o|l,s|c,s|C,o|a,s|a,o|l,o|C,C|c,C|C,s|a,o|c,C|l,s|l,o|c,C|a,r|a,r|a,C|C,s|c,r|l,C|c,s|l,r|l,o|C,o|l,C|a,r|a,s|l,r|c,s|C,C|c,o|a,s|C,o|l,o|C,C|c,o|a,r|c,s|l,r|C,s|c,r|l,C|C,r|a,C|a,C|l,r|C,s|c,C|l,s|a,o|c,C|C,r|l,o|C,s|a,o|c],s=1<<21,o=1<<26,r=s|o,a=2,l=2048,c=a|l,m=[s|C,r|a,o|c,C|C,C|l,o|c,s|c,r|l,r|c,s|C,C|C,o|a,C|a,o|C,r|a,C|c,o|l,s|c,s|a,o|l,o|a,r|C,r|l,s|a,r|C,C|l,C|c,r|c,s|l,C|a,o|C,s|l,o|C,s|l,s|C,o|c,o|c,r|a,r|a,C|a,s|a,o|C,o|l,s|C,r|l,C|c,s|c,r|l,C|c,o|a,r|c,r|C,s|l,C|C,C|a,r|c,C|C,s|c,r|C,C|l,o|a,o|l,C|l,s|a],s=1<<18,o=1<<28,r=s|o,a=64,l=4096,c=a|l,v=[o|c,C|l,s|C,r|c,o|C,o|c,C|a,o|C,s|a,r|C,r|c,s|l,r|l,s|c,C|l,C|a,r|C,o|a,o|l,C|c,s|l,s|a,r|a,r|l,C|c,C|C,C|C,r|a,o|a,o|l,s|c,s|C,s|c,s|C,r|l,C|l,C|a,r|a,C|l,s|c,o|l,C|a,o|a,r|C,r|a,o|C,s|C,o|c,C|C,r|c,s|a,o|a,r|C,o|l,o|c,C|C,r|c,s|l,s|l,C|c,C|c,s|a,o|C,r|l],t(e),{encrypt:n}}