<!--- //

	Module:		Storage
	Description: 
	

	
	
	show a popup where a user can choose where to save an attachment from an email
	
// --->
	
<cfinclude template="/login/check_logged_in.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="url.mailbox" type="string" default="">
<cfparam name="url.contenttype" type="string" default="">
<cfparam name="url.filename" type="string" default="">
<cfparam name="url.userkey" type="string" default="">
<cfparam name="url.id" type="string" default="">
<cfparam name="url.partid" type="string" default="">

<html>
	<head>
		<title><cfoutput>#GetLangVal('cm_wd_save')#</cfoutput></title>
		<cfinclude template="/style_sheet.cfm">		
	</head>
<body>
<div class="mischeader bb" style="padding:6px;font-weight:bold; "><cfoutput>#GetLangVal('mail_ph_save_attachment_to_storage')#</cfoutput></div>

<cfflush>

<form style="margin:0px; " action="act_save_attachment_from_email_to_folder.cfm" method="post">
<input type="hidden" name="frmmailbox" value="<cfoutput>#url.mailbox#</cfoutput>">
<input type="hidden" name="frmcontenttype" value="<cfoutput>#url.contenttype#</cfoutput>">
<input type="hidden" name="frmfilename" value="<cfoutput>#url.filename#</cfoutput>">
<input type="hidden" name="frmuserkey" value="<cfoutput>#url.userkey#</cfoutput>">
<input type="hidden" name="frmid" value="<cfoutput>#url.id#</cfoutput>">
<input type="hidden" name="frmpartid" value="<cfoutput>#url.partid#</cfoutput>">

<table class="table_details table_edit_form">
	<tr>
		<td colspan="2">
		<cfoutput>#GetLangVal('sto_ph_please_chose_dest_dir_for_attachment')#</cfoutput>
		</td>
	</tr>
  <tr>
    <td class="field_name">
		<cfoutput>#GetLangVal('sto_wd_filename')#</cfoutput>:
	</td>
    <td>
		<cfoutput>#htmleditformat(url.filename)#</cfoutput>
	</td>
  </tr>
  <tr>
     <td class="field_name">
		<cfoutput>#GetLangVal('sto_wd_contenttype')#</cfoutput>:
	</td>
	<td>
		<cfoutput>#htmleditformat(url.contenttype)#</cfoutput>
	</td>
  </tr>
  <tr>
     <td class="field_name"></td>
    <td>
	<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" class="btn" />
	

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetDirectoryStructure"   
	returnVariable = "a_struct_dirs"   
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	 >
</cfinvoke>

	<cfset a_arr_dirs=ArrayNew(1)>
	<cfset a_struct_hint=Structnew()>
	
	<cfset sDirectorykey=a_struct_dirs.rootdirectorykey>
	<cfset a_struct_hint.directorykey = sDirectorykey>
	
	<cfset a_struct_hint.counter = 0>
	
	<cfset tmp=ArrayAppend(a_arr_dirs,a_struct_hint)>
	
	<cfloop  condition="arraylen(a_arr_dirs) gt 0 ">
		<cfset a_current_hint = a_arr_dirs[arraylen(a_arr_dirs)]>
		<cfset sDirectorykey=a_current_hint.directorykey>
		<cfif a_current_hint.counter lte 0>
		
			<cfset a_int_padding_left = arraylen(a_arr_dirs) * 30>
	
			<cfoutput>
			
			<div style="padding-left:#a_int_padding_left#px;padding-top:3px; ">
				<input type="radio" value="#sDirectorykey#" class="noborder" style="width:auto;" name="frmdirectorykey" /> <a target="_blank" href="/storage/default.cfm?action=ShowFiles&directorykey=#sDirectorykey#"><img src="/images/si/folder.png" class="si_img" /> #htmleditformat(a_struct_dirs.directories[sDirectorykey].name)#</a>
				<div style="padding-left:10px; ">
					<!--- files --->
				<cfset a_struct_filter = StructNew()>
				<cfset a_struct_filter.type = 'dir'>
				
				<cfinvoke   
					component = "#application.components.cmp_storage#"   
					method = "ListFilesAndDirectories"   
					returnVariable = "a_struct_files_of_current_dir"   
					directorykey = "#sDirectorykey#"
					securitycontext="#request.stSecurityContext#"
					usersettings="#request.stUserSettings#"
					filter = #a_struct_filter#>
				</cfinvoke>  
				
				
				</div>
			</div>
			

			</cfoutput>

		</cfif>
		<cfif ArrayLen(a_struct_dirs.directories[sDirectorykey].subdirectories) gt a_current_hint.counter >
			<cfset a_current_hint.counter = a_current_hint.counter + 1 >
			<cfset a_struct_hint = StructNew () >
			<cfset sDirectorykey = a_struct_dirs.directories[sDirectorykey].subdirectories[a_current_hint.counter]>
			<cfset a_struct_hint.directorykey = sDirectorykey>
			<cfset a_struct_hint.counter = 0 >
			<cfset tmp=ArrayAppend(a_arr_dirs,a_struct_hint)>
		<cfelse>
			<cfset tmp=ArrayDeleteAt (a_arr_dirs,ArrayLen(a_arr_dirs))>
		</cfif>
	</cfloop>	
	
	
	</td>
  </tr>
</table>
</form>
</body>
</html>


