/* ***** BEGIN LICENSE BLOCK *****
 * Distributed under the BSD license:
 *
 * Copyright (c) 2010, Ajax.org B.V.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Ajax.org B.V. nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL AJAX.ORG B.V. BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ***** END LICENSE BLOCK ***** */
define("ace/mode/diff",["require","exports","module","ace/lib/oop","ace/mode/text","ace/tokenizer","ace/mode/diff_highlight_rules","ace/mode/folding/diff"],function(e,t){var i=e("../lib/oop"),n=e("./text").Mode,s=e("../tokenizer").Tokenizer,o=e("./diff_highlight_rules").DiffHighlightRules,r=e("./folding/diff").FoldMode,a=function(){this.$tokenizer=new s((new o).getRules(),"i"),this.foldingRules=new r(["diff","index","\\+{3}","@@|\\*{5}"],"i")};i.inherits(a,n),function(){}.call(a.prototype),t.Mode=a}),define("ace/mode/diff_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(e,t){var i=e("../lib/oop"),n=e("./text_highlight_rules").TextHighlightRules,s=function(){this.$rules={start:[{regex:"^(?:\\*{15}|={67}|-{3}|\\+{3})$",token:"punctuation.definition.separator.diff",name:"keyword"},{regex:"^(@@)(\\s*.+?\\s*)(@@)(.*)$",token:["constant","constant.numeric","constant","comment.doc.tag"]},{regex:"^(\\d+)([,\\d]+)(a|d|c)(\\d+)([,\\d]+)(.*)$",token:["constant.numeric","punctuation.definition.range.diff","constant.function","constant.numeric","punctuation.definition.range.diff","invalid"],name:"meta."},{regex:"^(?:(\\-{3}|\\+{3}|\\*{3})( .+))$",token:["constant.numeric","meta.tag"]},{regex:"^([!+>])(.*?)(\\s*)$",token:["constant.numeric","constant.numeric","invalid"]},{regex:"^([<\\-])(.*?)(\\s*)$",token:["support.function","support.function","invalid"]},{regex:"^(diff)(\\s+--\\w+)?(.+?)( .+)?$",token:["variable","variable","keyword","variable"]},{regex:"^Index.+$",token:"variable"},{regex:"^(.*?)(\\s*)$",token:["invisible","invalid"]}]}};i.inherits(s,n),t.DiffHighlightRules=s}),define("ace/mode/folding/diff",["require","exports","module","ace/lib/oop","ace/mode/folding/fold_mode","ace/range"],function(e,t){var i=e("../../lib/oop"),n=e("./fold_mode").FoldMode,s=e("../../range").Range,o=t.FoldMode=function(e,t){this.regExpList=e,this.flag=t,this.foldingStartMarker=RegExp("^("+e.join("|")+")",this.flag)};i.inherits(o,n),function(){this.getFoldWidgetRange=function(e,t,i){for(var n=e.getLine(i),o={row:i,column:n.length},r=this.regExpList,a=1;r.length>=a;a++){var l=RegExp("^("+r.slice(0,a).join("|")+")",this.flag);if(l.test(n))break}for(var c=e.getLength();c>++i&&(n=e.getLine(i),!l.test(n)););return i!=o.row+1?s.fromPoints(o,{row:i-1,column:n.length}):void 0}}.call(o.prototype)});