function nfs_section_visibility(e){$(".inputs-list :checkbox").each(function(){$(this).change(e,toggle_nfs_section)}),$("input:submit").each(function(){$(this).change(e,check_nfs_section)})}function count_checked_nfs(e){var t=0;return $(".inputs-list :checkbox").each(function(n){1==e[n]&&this.checked&&t++}),t}function toggle_nfs_section(e){var t=e.data;count_checked_nfs(t)>=1?$("#nfs-section").show():$("#nfs-section").hide()}function check_nfs_section(e){var t=e.data;0==count_checked_nfs(t)&&($("#medium_media_path").attr("value",""),$("#medium_config_path").attr("value",""),$("#medium_image_path").attr("value",""))}