<!--- //

	Module:		E-Mail
	Action:		ShowFolderOverviewLeft
	
// --->

<div class="divleftnavigation_center" style="border-left:0px;">
<div class="divleftnavpanelheader"><a style="text-transform:lowercase;font-weight:normal;" href="#" onclick="SetPersonalPreferenceValue('email', 'showfoldersleft', 0);$('#id_div_email_folders_left').hide();"><cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput></a></div>

<cfquery name="q_select_folder_list" dbtype="query">
SELECT
	*
FROM
	request.q_select_folders
ORDER BY
	fullfoldername
;
</cfquery>

<!--- init values ... --->
<cfset a_int_next_len = 2 />
<cfset a_int_old_len = 2 />

 <ul id="id_ul_folder_list_sel">
<cfoutput query="q_select_folder_list">
	
	<cfif q_select_folder_list.currentrow NEQ q_select_folder_list.recordcount>
		<cfset a_int_next_len = ListLen(q_select_folder_list['fullfoldername'][q_select_folder_list.currentrow + 1], '.') />
	</cfif>
	
	<li>
		<img src="/images/si/folder.png" class="si_img" style="padding:0px;margin:1px;" /> <a onclick="DisplayMBoxContentASync('#JSStringFormat(q_select_folder_list.fullfoldername)#');return false;" href="index.cfm?action=ShowMailbox&Mailbox=#urlencodedformat(q_select_folder_list.fullfoldername)#" <cfif q_select_folder_list.unreadmessagescount GT 0>style="font-weight:bold;"</cfif>>#htmleditformat(q_select_folder_list.foldername)#</a>
		
		<cfif a_int_next_len GT a_int_old_len>
			<ul>
		<cfelseif a_int_old_len GT a_int_next_len>
			</ul>
		<cfelse>
			</li>
		</cfif>
	
	
	<cfset a_int_old_len = a_int_next_len />
</cfoutput>
</ul>

</div>