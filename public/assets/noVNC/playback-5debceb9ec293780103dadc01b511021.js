/*
 * noVNC: HTML5 VNC client
 * Copyright (C) 2011 Joel Martin
 * Licensed under LGPL-3 (see LICENSE.LGPL-3)
 */
"use strict";var rfb,mode,test_state,frame_idx,frame_length,iteration,iterations,istart_time,send_array,next_iteration,queue_next_packet,do_packet;send_array=function(){},next_iteration=function(){if(0===iteration?(frame_length=VNC_frame_data.length,test_state="running"):rfb.disconnect(),"running"===test_state){if(iteration+=1,iteration>iterations)return finish(),void 0;frame_idx=0,istart_time=(new Date).getTime(),rfb.connect("test",0,"bogus"),queue_next_packet()}},queue_next_packet=function(){var e,t,i,n;if("running"===test_state){for(e=VNC_frame_data[frame_idx];frame_length>frame_idx&&"}"===e.charAt(0);)frame_idx+=1,e=VNC_frame_data[frame_idx];return"EOF"===e?(Util.Debug("Finished, found EOF"),next_iteration(),void 0):frame_idx>=frame_length?(Util.Debug("Finished, no more frames"),next_iteration(),void 0):("realtime"===mode?(t=e.slice(1,e.indexOf("{",1)),i=(new Date).getTime()-istart_time,n=t-i,1>n&&(n=1),setTimeout(do_packet,n)):setTimeout(do_packet,1),void 0)}},do_packet=function(){var e=VNC_frame_data[frame_idx];rfb.recv_message({data:e.slice(e.indexOf("{",1)+1)}),frame_idx+=1,queue_next_packet()};