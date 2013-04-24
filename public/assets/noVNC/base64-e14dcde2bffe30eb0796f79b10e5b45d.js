/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Mozilla XML-RPC Client component.
 *
 * The Initial Developer of the Original Code is
 * Digital Creations 2, Inc.
 * Portions created by the Initial Developer are Copyright (C) 2000
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Martijn Pieters <mj@digicool.com> (original author)
 *   Samuel Sieb <samuel@sieb.net>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */
var Base64={toBase64Table:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",base64Pad:"=",encode:function(e){"use strict";var t,i="",n=Base64.toBase64Table.split(""),s=Base64.base64Pad,o=e.length;for(t=0;o-2>t;t+=3)i+=n[e[t]>>2],i+=n[((3&e[t])<<4)+(e[t+1]>>4)],i+=n[((15&e[t+1])<<2)+(e[t+2]>>6)],i+=n[63&e[t+2]];return o%3&&(t=o-o%3,i+=n[e[t]>>2],2===o%3?(i+=n[((3&e[t])<<4)+(e[t+1]>>4)],i+=n[(15&e[t+1])<<2],i+=s):(i+=n[(3&e[t])<<4],i+=s+s)),i},toBinaryTable:[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1,63,52,53,54,55,56,57,58,59,60,61,-1,-1,-1,0,-1,-1,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,-1,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1],decode:function(e,t){"use strict";t="undefined"!=typeof t?t:0;var i,n,s,o,r,a,l=Base64.toBinaryTable,c=Base64.base64Pad,h=0,u=0,d=e.indexOf("=")-t;for(0>d&&(d=e.length-t),n=3*(d>>2)+Math.floor(d%4/1.5),i=new Array(n),s=0,o=t;e.length>o;o++)r=l[127&e.charCodeAt(o)],a=e.charAt(o)===c,-1!==r?(u=u<<6|r,h+=6,h>=8&&(h-=8,a||(i[s++]=255&u>>h),u&=(1<<h)-1)):console.error("Illegal character code "+e.charCodeAt(o)+" at position "+o);if(h)throw{name:"Base64-Error",message:"Corrupted base64 string"};return i}};