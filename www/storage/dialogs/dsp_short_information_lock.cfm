<!--- //

	Module:		Storage
	Action:		DisplayShortLockInformation
	Description:Inpage popup lock info
	

	
	
	Display information about possible lock
	
// --->

<cfparam name="url.filekey" type="string">

<cfinvoke component="#application.components.cmp_locks#" method="ExclusiveLockExistsForObject" returnvariable="a_struct_lock">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="objectkey" value="#url.filekey#">
</cfinvoke>

<cfif NOT a_struct_lock.lock_exists>
	<img src="/images/si/information.png" class="si_img" /> <b><cfoutput>#GetLangVal('cm_ph_locks_none_exists_for_object')#</cfoutput></b>
	<br /><br />
	<a href="#" onclick="ShowCreateExlusiveLock('<cfoutput>#JsStringFormat(url.filekey)#</cfoutput>');"><img src="/images/si/lock.png" class="si_img" /> <cfoutput>#GetLangVal('cm_ph_lock_create_exclusive_lock_now')# ...</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_user_data = application.components.cmp_user.GetuserData(a_struct_lock.userkey) />

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file_info"   
	entrykey = "#url.filekey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>	 

<cfoutput>
<table class="table table_details">
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_file')#
		</td>
		<td>
			#htmleditformat(a_struct_file_info.q_select_file_info.filename)#
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_user')#
		</td>
		<td>
			<cfif q_select_user_data.smallphotoavaliable IS 1>
				<img src="/tools/img/show_small_userphoto.cfm?entrykey=#q_select_user_data.entrykey#" align="absmiddle" /> 
			</cfif>
			<a href="/workgroups/?action=ShowUser&entrykey=#a_struct_lock.userkey#">#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(a_struct_lock.userkey)#</a>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_created')#
		</td>
		<td>
			#FormatDateTimeAccordingToUserSettings(a_struct_lock.dt_created)#
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_comment')#
		</td>
		<td>
			#htmleditformat(a_struct_lock.comment)#
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('adm_ph_company_news_valid_until')#
		</td>
		<td>
			#FormatDateTimeAccordingToUserSettings(a_struct_lock.dt_timeout)#
		</td>
	</tr>
	<tr>
		<td class="field_name"></td>
		<td>
			<cfif a_struct_lock.userkey IS request.stSecurityContext.myuserkey>
				<input onclick="DeleteExclusiveLock('#url.filekey#');" class="btn" type="button" value="Objekt-Sperre aufheben ..." />
			</cfif>
		</td>
	</tr>
</table>
</cfoutput>

