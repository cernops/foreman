/*
 * noVNC: HTML5 VNC client
 * Copyright (C) 2011 Joel Martin
 * Licensed under LGPL-3 (see LICENSE.txt)
 *
 * See README.md for usage and integration instructions.
 */
function Display(e){"use strict";function t(){Util.Debug(">> Display.constructor");var e,t,i,n,s=Util.Engine;if(!l.target)throw"target must be set";if("string"==typeof l.target)throw"target must be a DOM element";if(e=l.target,!e.getContext)throw"no getContext method";if(c||(c=e.getContext("2d")),Util.Debug("User Agent: "+navigator.userAgent),s.gecko&&Util.Debug("Browser: gecko "+s.gecko),s.webkit&&Util.Debug("Browser: webkit "+s.webkit),s.trident&&Util.Debug("Browser: trident "+s.trident),s.presto&&Util.Debug("Browser: presto "+s.presto),a.clear(),!("createImageData"in c))throw"Canvas does not support createImageData";for(l.render_mode="canvas rendering",null===l.prefer_js&&(Util.Info("Prefering javascript operations"),l.prefer_js=!0),m=c.createImageData(16,16),i=[],t=0;256>t;t+=1)i.push(255);try{n=e.style.cursor,changeCursor(l.target,i,i,2,2,8,8),e.style.cursor?(null===l.cursor_uri&&(l.cursor_uri=!0),Util.Info("Data URI scheme cursor supported")):(null===l.cursor_uri&&(l.cursor_uri=!1),Util.Warn("Data URI scheme cursor not supported")),e.style.cursor=n}catch(o){Util.Error("Data URI scheme cursor test exception: "+o),l.cursor_uri=!1}return Util.Debug("<< Display.constructor"),a}var i,n,s,o,r,a={},l={},c=null,h=0,u=0,d={x:0,y:0,w:0,h:0},f={x1:0,y1:0,x2:-1,y2:-1},p="",g=null,m=null,v=0,_=0;return Util.conf_defaults(l,a,e,[["target","wo","dom",null,"Canvas element for rendering"],["context","ro","raw",null,"Canvas 2D context for rendering (read-only)"],["logo","rw","raw",null,'Logo to display when cleared: {"width": width, "height": height, "data": data}'],["true_color","rw","bool",!0,"Use true-color pixel data"],["colourMap","rw","arr",[],"Colour map array (when not true-color)"],["scale","rw","float",1,"Display area scale factor 0.0 - 1.0"],["viewport","rw","bool",!1,"Use a viewport set with viewportChange()"],["width","rw","int",null,"Display area width"],["height","rw","int",null,"Display area height"],["render_mode","ro","str","","Canvas rendering mode (read-only)"],["prefer_js","rw","str",null,"Prefer Javascript over canvas methods"],["cursor_uri","rw","raw",null,"Can we render cursor using data URI"]]),a.get_context=function(){return c},a.set_scale=function(e){r(e)},a.set_width=function(e){a.resize(e,u)},a.get_width=function(){return h},a.set_height=function(e){a.resize(h,e)},a.get_height=function(){return u},r=function(e){var t,i,n,s,o=["transform","WebkitTransform","MozTransform",null];for(t=l.target,i=o.shift();i&&"undefined"==typeof t.style[i];)i=o.shift();return null===i?(Util.Debug("No scaling support"),void 0):("undefined"==typeof e?e=l.scale:e>1?e=1:.1>e&&(e=.1),l.scale!==e&&(l.scale=e,n=t.width-t.width*e,s=t.height-t.height*e,t.style[i]="scale("+l.scale+") translate(-"+n+"px, -"+s+"px)"),void 0)},o=function(e){var t,i;t=l.true_color?e:l.colourMap[e[0]],i="rgb("+t[2]+","+t[1]+","+t[0]+")",i!==p&&(c.fillStyle=i,p=i)},a.viewportChange=function(e,t,i,n){var s,o,r,a,p,g,m,v=l.target,_=d,b=f,C=null;l.viewport||(Util.Debug("Setting viewport to full display region"),e=-_.w,t=-_.h,i=h,n=u),"undefined"==typeof e&&(e=0),"undefined"==typeof t&&(t=0),"undefined"==typeof i&&(i=_.w),"undefined"==typeof n&&(n=_.h),i>h&&(i=h),n>u&&(n=u),(_.w!==i||_.h!==n)&&(_.w>i&&b.x2>_.x+i-1&&(b.x2=_.x+i-1),_.w=i,_.h>n&&b.y2>_.y+n-1&&(b.y2=_.y+n-1),_.h=n,_.w>0&&_.h>0&&v.width>0&&v.height>0&&(C=c.getImageData(0,0,v.width<_.w?v.width:_.w,v.height<_.h?v.height:_.h)),v.width=_.w,v.height=_.h,C&&c.putImageData(C,0,0)),a=_.x+_.w-1,p=_.y+_.h-1,0>e&&0>_.x+e&&(e=-_.x),a+e>=h&&(e-=a+e-h+1),0>_.y+t&&(t=-_.y),p+t>=u&&(t-=p+t-u+1),(0!==e||0!==t)&&(Util.Debug("viewportChange deltaX: "+e+", deltaY: "+t),_.x+=e,a+=e,_.y+=t,p+=t,_.x>b.x1&&(b.x1=_.x),b.x2>a&&(b.x2=a),_.y>b.y1&&(b.y1=_.y),b.y2>p&&(b.y2=p),0>e?(o=0,g=-e):(o=_.w-e,g=e),0>t?(r=0,m=-t):(r=_.h-t,m=t),s=c.fillStyle,c.fillStyle="rgb(255,255,255)",0!==e&&(c.drawImage(v,0,0,_.w,_.h,-e,0,_.w,_.h),c.fillRect(o,0,g,_.h)),0!==t&&(c.drawImage(v,0,0,_.w,_.h,0,-t,_.w,_.h),c.fillRect(0,r,_.w,m)),c.fillStyle=s)},a.getCleanDirtyReset=function(){var e,t=d,i=f,n=[],s=t.x+t.w-1,o=t.y+t.h-1;return e={x:i.x1,y:i.y1,w:i.x2-i.x1+1,h:i.y2-i.y1+1},i.x1>=i.x2||i.y1>=i.y2?n.push({x:t.x,y:t.y,w:t.w,h:t.h}):(t.x<i.x1&&n.push({x:t.x,y:t.y,w:i.x1-t.x+1,h:t.h}),s>i.x2&&n.push({x:i.x2+1,y:t.y,w:s-i.x2,h:t.h}),t.y<i.y1&&n.push({x:i.x1,y:t.y,w:i.x2-i.x1+1,h:i.y1-t.y}),o>i.y2&&n.push({x:i.x1,y:i.y2+1,w:i.x2-i.x1+1,h:o-i.y2})),f={x1:t.x,y1:t.y,x2:t.x+t.w-1,y2:t.y+t.h-1},{cleanBox:e,dirtyBoxes:n}},a.absX=function(e){return e+d.x},a.absY=function(e){return e+d.y},a.resize=function(e,t){p="",h=e,u=t,r(l.scale),a.viewportChange()},a.clear=function(){l.logo?(a.resize(l.logo.width,l.logo.height),a.blitStringImage(l.logo.data,0,0)):(a.resize(640,20),c.clearRect(0,0,d.w,d.h))},a.fillRect=function(e,t,i,n,s){o(s),c.fillRect(e-d.x,t-d.y,i,n)},a.copyImage=function(e,t,i,n,s,o){var r=e-d.x,a=t-d.y,h=i-d.x,u=n-d.y;c.drawImage(l.target,r,a,s,o,h,u,s,o)},a.startTile=function(e,t,i,n,s){var o,r,h,u,d,f;if(v=e,_=t,g=16===i&&16===n?m:c.createImageData(i,n),o=g.data,l.prefer_js)for(r=l.true_color?s:l.colourMap[s[0]],h=r[2],u=r[1],d=r[0],f=0;4*i*n>f;f+=4)o[f]=h,o[f+1]=u,o[f+2]=d,o[f+3]=255;else a.fillRect(e,t,i,n,s)},a.subTile=function(e,t,i,n,s){var o,r,c,h,u,d,f,p,m,b,C;if(l.prefer_js)for(o=g.data,f=g.width,c=l.true_color?s:l.colourMap[s[0]],h=c[2],u=c[1],d=c[0],b=e+i,C=t+n,p=t;C>p;p+=1)for(m=e;b>m;m+=1)r=4*(m+p*f),o[r]=h,o[r+1]=u,o[r+2]=d,o[r+3]=255;else a.fillRect(v+e,_+t,i,n,s)},a.finishTile=function(){l.prefer_js&&c.putImageData(g,v-d.x,_-d.y)},i=function(e,t,i,n,s,o){var r,a,l,h,u=d;for(r=c.createImageData(i,n),h=r.data,a=0,l=o;4*i*n>a;a+=4,l+=3)h[a]=s[l],h[a+1]=s[l+1],h[a+2]=s[l+2],h[a+3]=255;c.putImageData(r,e-u.x,t-u.y)},n=function(e,t,i,n,s,o){var r,a,l,h,u=d;for(r=c.createImageData(i,n),h=r.data,a=0,l=o;4*i*n>a;a+=4,l+=4)h[a]=s[l+2],h[a+1]=s[l+1],h[a+2]=s[l],h[a+3]=255;c.putImageData(r,e-u.x,t-u.y)},s=function(e,t,i,n,s,o){var r,a,h,u,f,p;for(r=c.createImageData(i,n),u=r.data,p=l.colourMap,a=0,h=o;4*i*n>a;a+=4,h+=1)f=p[s[h]],u[a]=f[2],u[a+1]=f[1],u[a+2]=f[0],u[a+3]=255;c.putImageData(r,e-d.x,t-d.y)},a.blitImage=function(e,t,i,o,r,a){l.true_color?n(e,t,i,o,r,a):s(e,t,i,o,r,a)},a.blitRgbImage=function(e,t,n,o,r,a){l.true_color?i(e,t,n,o,r,a):s(e,t,n,o,r,a)},a.blitStringImage=function(e,t,i){var n=new Image;n.onload=function(){c.drawImage(n,t-d.x,i-d.y)},n.src=e},a.changeCursor=function(e,t,i,n,s,o){return l.cursor_uri===!1?(Util.Warn("changeCursor called but no cursor data URI support"),void 0):(l.true_color?changeCursor(l.target,e,t,i,n,s,o):changeCursor(l.target,e,t,i,n,s,o,l.colourMap),void 0)},a.defaultCursor=function(){l.target.style.cursor="default"},t()}function changeCursor(e,t,i,n,s,o,r,a){"use strict";var l,c,h,u,d,f,p,g,m,v,_=[];for(_.push16le=function(e){this.push(255&e,255&e>>8)},_.push32le=function(e){this.push(255&e,255&e>>8,255&e>>16,255&e>>24)},c=40,h=4*o*r,d=Math.ceil(o*r/8),u=Math.ceil(o*r/8),_.push16le(0),_.push16le(2),_.push16le(1),_.push(o),_.push(r),_.push(0),_.push(0),_.push16le(n),_.push16le(s),_.push32le(c+h+d+u),_.push32le(22),_.push32le(c),_.push32le(o),_.push32le(2*r),_.push16le(1),_.push16le(32),_.push32le(0),_.push32le(d+u),_.push32le(0),_.push32le(0),_.push32le(0),_.push32le(0),v=r-1;v>=0;v-=1)for(m=0;o>m;m+=1)p=v*Math.ceil(o/8)+Math.floor(m/8),g=128&i[p]<<m%8?255:0,a?(p=o*v+m,l=a[t[p]],_.push(l[2]),_.push(l[1]),_.push(l[0]),_.push(g)):(p=4*(o*v+m),_.push(t[p+2]),_.push(t[p+1]),_.push(t[p]),_.push(g));for(v=0;r>v;v+=1)for(m=0;Math.ceil(o/8)>m;m+=1)_.push(0);for(v=0;r>v;v+=1)for(m=0;Math.ceil(o/8)>m;m+=1)_.push(0);f="data:image/x-icon;base64,"+Base64.encode(_),e.style.cursor="url("+f+") "+n+" "+s+", default"}