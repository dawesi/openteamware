<!--- //

	Module:		Email
	Action:		ShowSearch
	Description: 
	

	
	
	display search operation
	
	- search targets
	- search value
	- search folders
	
// --->

<!--- default search string? --->
<cfparam name="url.search" default="" type="string">
<cfparam name="url.mailbox" default="INBOX" type="string">


<cfset tmp = SetHeaderTopInfoString(GetLangVal('mail_wd_search')) />

<form action="index.cfm" method="get" name="formsearch">
<input type="Hidden" name="Action" value="DoSearch">
<table class="table_details table_edit_form" >
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal("mail_ph_searchfor")#</cfoutput></td>
	<td><input type="Text" name="search" value="<cfoutput>#htmleditformat(url.search)#</cfoutput>" size="25" /></td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal("mail_ph_searchfolder")#</cfoutput>
	</td>
	<td>
	<select name="mailbox">
	<option value=""><cfoutput>#GetLangVal("mail_ph_searchfoldersall")#</cfoutput>
	<cfoutput query="request.q_select_folders">
	<option #WriteSelectedElement(url.mailbox, request.q_select_folders.fullfoldername)# value="#htmleditformat(request.q_select_folders.fullfoldername)#">#htmleditformat(request.q_select_folders.foldername)#
	</cfoutput>
	</select>
	</td>
</tr>
<tr>
	<td class="field_name"><input disabled checked type="checkbox" name="frmcbrecursive" value="1" class="noborder" /></td>
	<td class="addinfotext">
	<cfoutput>#GetLangVal('mail_ph_search_include_subfolders')#</cfoutput>
	</td>
</tr>
<!---<tr>
	<td align="right" valign="top"><cfoutput>#GetLangVal("mail_ph_searchtargets")#</cfoutput></td>
	<td>
	<input class="noborder" type="checkbox" name="search_subject" value="subject" checked>&nbsp;<cfoutput>#GetLangVal("mail_wd_searchsubject")#</cfoutput><br />
	<input class="noborder"  type="checkbox" name="search_body" value="text">&nbsp;<cfoutput>#GetLangVal("mail_wd_searchbody")#</cfoutput><br />
	<input class="noborder"  type="checkbox" name="search_header" checked value="header">&nbsp;<cfoutput>#GetLangVal("mail_ph_searchfullheader")#</cfoutput>
	</td>
</tr>--->
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('cm_wd_extras')#</cfoutput></td>
	<td valign="top">
	<input type="checkbox" class="noborder" name="attachments" value="1" /> <cfoutput>#GetLangVal('mail_ph_search_attachments_needed')#</cfoutput><br />
	<input type="checkbox" class="noborder" name="isflagged" value="1" /> <cfoutput>#GetLangVal('mail_ph_search_flagged_needed')#</cfoutput><br />
	<input type="checkbox" class="noborder" value="1" name="fulltextsearch" /> <cfoutput>#GetLangVal('mail_ph_search_fulltextsearch')#</cfoutput>
	
	</td>
</tr>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('cm_wd_age')#</cfoutput></td>
	<td>
		<cfset a_str_max_age_days = GetLangVal('mail_wd_search_age_max_days') />
		
		<select name="frmage">
			<option value="0" selected><cfoutput>#GetLangVal('mail_wd_search_age_unlimited')#</cfoutput></option>
			<option value="5"><cfoutput>#ReplaceNoCase(a_str_max_age_days, '%NUMBEROFDAYS%', 5)#</cfoutput></option>
			<option value="15"><cfoutput>#ReplaceNoCase(a_str_max_age_days, '%NUMBEROFDAYS%', 15)#</cfoutput></option>
			<option value="21"><cfoutput>#ReplaceNoCase(a_str_max_age_days, '%NUMBEROFDAYS%', 21)#</cfoutput></option>
			<option value="60"><cfoutput>#ReplaceNoCase(a_str_max_age_days, '%NUMBEROFDAYS%', 60)#</cfoutput>e</option>
		</select>
	</td>
</tr>
<tr>
	<td class="field_name"></td>
	<td><input type="submit" value="<cfoutput>#GetLangVal("mail_ph_startsearch")#</cfoutput>" class="btn" /></td>
</tr>
</table>
</form>

