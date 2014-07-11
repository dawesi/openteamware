<!--- //

	let the user active remote edit
	
	// --->
<cfparam name="url.entrykeys" type="string" default="">
<cfparam name="url.force" type="boolean" default="false">

<cfif url.entrykeys IS 'session'>
	<!--- use session var ... --->
	<cfset url.entrykeys = session.a_struct_temp_data.addressbook_selected_entrykeys />
</cfif>
	

<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_action_remoteedit')) />

<cfif NOT StructKeyExists(url, 'confirmed')>

	<form method="post" action="index.cfm?action=remoteedit&confirmed=true&force=<cfoutput>#url.force#</cfoutput>&entrykeys=session" style="margin:0px; ">

	<cfif Len(url.entrykeys) GT 0>
		
	<cfset a_struct_filter = StructNew() />
	<cfset a_struct_filter.entrykeys = url.entrykeys />
	
	<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="fieldlist" value="company,surname,firstname,b_telephone,p_telephone,email_prim,username,b_mobile,lastemailcontact,p_mobile,reupdateavaliable,categories,company,lastsmssent,archiveentry">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="filter" value="#a_struct_filter#">		
	</cfinvoke>
	
	<cfset q_select_contacts = stReturn.q_select_contacts />
	
	<cfquery name="q_select_contacts" dbtype="query">
	SELECT
		firstname,surname,email_prim,entrykey,company,birthday,categories
	FROM
		q_select_contacts
	WHERE
		(
			(email_prim IS NOT NULL)
			AND NOT
			(email_prim = '')
		)
	;
	</cfquery>	

	<cfoutput>#GetLangVal('adrb_ph_selected_contacts')#</cfoutput>
	
	<table class="table table_details table_edit_form">
		<cfoutput query="q_select_contacts">
		<tr>
			<td class="field_name">###q_select_contacts.currentrow#</td>
			<td>
				#q_select_contacts.firstname# #checkzerostring(q_select_contacts.surname)# &lt;#q_select_contacts.email_prim#&gt;
			</td>
		</tr>
		</cfoutput>
		<tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('cm_wd_text')#</cfoutput>
			</td>
			<td>
				<textarea name="frmmsg" rows="6" cols="40" style="width:400px;"><cfoutput>#htmleditformat(GetLangVal('adrb_ph_remote_edit_mail_text'))#</cfoutput></textarea>
			</td>
		</tr>
		<tr>
			<td class="field_name"></td>
			<td>
				<input type="submit" class="btn btn-primary" value="<cfoutput>#GetLangVal('adrb_ph_re_send_invitations')#</cfoutput>" />
			</td>
		</tr>

	</table>
		
		<!--- submit the REAL entrykeys here --->
		<cfset session.a_struct_temp_data.addressbook_selected_entrykeys = url.entrykeys>
	
		
	<!--- <cfoutput>#GetLangVal('adrb_ph_re_yes_allow_contacts_to_edit_data')#</cfoutput><br> --->
	
	</form>

	<cfelse>
	<ul>
		<li><a href="index.cfm"><b><cfoutput>#GetLangVal('adrb_ph_re_select_contacts_now')#</cfoutput></b></a></li>

		<li><a href="index.cfm?action=remoteeditstatus"><cfoutput>#GetLangVal('adrb_ph_show_re_invitations_status')#</cfoutput></a>
	</ul>
	</cfif>

	<br /><br />  	
	<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
		<cfinvokeargument name="section" value="addressbook">
		<cfinvokeargument name="langno" value="#client.langno#">
		<cfinvokeargument name="template_name" value="activate_remote_edit">
	</cfinvoke>
	
	<cfinclude template="#a_str_page_include#">	
	</ul>
	</p>

<br /><br />  
<cfelse>

<!--- activate --->

<cfloop list="#session.a_struct_temp_data.addressbook_selected_entrykeys#" delimiters="," index="sEntrykey">

	<cfinvoke component="#application.components.cmp_addressbook#" method="ActivateRemoteEdit" returnvariable="stReturn">
		<cfinvokeargument name="entrykey" value="#sEntrykey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">		
		<cfinvokeargument name="forcenewsend" value="#url.force#">
		<cfinvokeargument name="ownintromsg" value="#form.frmmsg#">
	</cfinvoke>
	
</cfloop>


<cfset tmp = StructClear(session.a_struct_temp_data) />

<br /><br />  

<b><cfoutput>#GetLangVal('adrb_ph_re_invitations_sent')#</cfoutput></b>

<br /><br />  

<a href="index.cfm"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
</cfif>