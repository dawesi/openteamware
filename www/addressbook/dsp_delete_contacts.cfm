<!--- //

	Module:		Address Book
	Action:		DeleteContacts
	Description:Delete the selected contacts (confirmation)


// --->

<cfsetting requesttimeout="2000">

<cfparam name="url.confirmed" type="string" default="">
<cfparam name="url.entrykeys" type="string" default="">
<cfparam name="url.redirect_start_contacts" type="boolean" default="false">

<cfif StructKeyExists(session, 'a_struct_temp_data') AND Len(url.entrykeys) IS 0>
	<cfset url.entrykeys = session.a_struct_temp_data.addressbook_url>
</cfif>

<cfif len(url.entrykeys) IS 0>
	<cflocation addtoken="false" url="#ReturnRedirectURL()#">
</cfif>

<cfif Len(url.confirmed) IS 0>

	<br />
	<span class="glyphicon glyphicon-exclamation-sign"></span> <b><cfoutput>#GetLangVal('adrb_ph_delete_contacts_sure')#</cfoutput></b>
	<br />

	<!--- load contact data ... --->
	<br />

	<cfset a_struct_filter = StructNew() />
	<cfset a_struct_filter.entrykeys = url.entrykeys />

	<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="filter" value="#a_struct_filter#">
	</cfinvoke>

	<cfset q_select_contacts_2_delete = stReturn.q_select_contacts />

	<ul class="ul_nopoints">
	<cfloop query="q_select_contacts_2_delete">

		<cfset stReturn_rights = application.components.cmp_security.GetPermissionsForObject(servicekey = request.sCurrentServiceKey,
												object_entrykey = q_select_contacts_2_delete.entrykey,
												securitycontext = request.stSecurityContext) />

		<cfquery name="q_select_cur_contact" dbtype="query">
		SELECT
			*
		FROM
			q_select_contacts_2_delete
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_contacts_2_delete.entrykey#">
		;
		</cfquery>

		<cfif stReturn_rights.delete>
			<cfoutput>
			<li><img src="/images/si/bullet_red.png" class="si_img" />#htmleditformat(application.components.cmp_Addressbook.GetContactDisplayNameData(entrykey = q_select_cur_contact.entrykey, query_holding_data = q_select_cur_contact))#</li>
			</cfoutput>
		</cfif>

	</cfloop>
	</ul>

	<br /><br />
	<input type="button" onclick="GotoLocHref('<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>&confirmed=true');" class="btn btn-primary" value="<cfoutput>#GetLangVal('adrb_ph_delete_contacts_yes_delete_now')#</cfoutput>" />
	<br /><br />
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('adrb_ph_delete_contacts_no_go_back')#</cfoutput></a>

<cfelse>

	<!--- delete now ... --->

	<cfloop list="#url.entrykeys#" delimiters="," index="sEntrykey">

		<cfinvoke component="#application.components.cmp_addressbook#" method="DeleteContact" returnvariable="a_bol_return">
			<cfinvokeargument name="entrykey" value="#sEntrykey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>

	</cfloop>

	<cfif url.redirect_start_contacts>
		<cflocation addtoken="no" url="index.cfm">
	<cfelse>
		<b><cfoutput><img src="/images/si/accept.png" class="si_img" /> #GetLangVal('adrb_ph_delete_contacts_success')#</cfoutput></b>
		<br /><br />
		<a href="index.cfm"><cfoutput>#GetLangVal('adrb_ph_delete_contacts_goto_overview')#</cfoutput></a>
	</cfif>
</cfif>


