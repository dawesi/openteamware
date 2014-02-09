<cfinclude template="../../login/check_logged_in.cfm">

<cfparam name="url.objectkey" type="string" default="">

<cfinvoke component="#request.a_str_component_addressbook#" method="GetContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.objectkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif NOT StructKeyExists(stReturn, 'q_select_contact')>
	object does not exist.
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_contact = stReturn.q_select_contact>

<cfset a_str_followup = '/tools/followups/show_popup_create.cfm?objectkey='& url.objectkey & '&servicekey=52227624-9DAA-05E9-0892A27198268072&title='&urlencodedformat(trim(q_select_contact.surname&' '&q_select_contact.firstname))>

<cflocation addtoken="no" url="#a_str_followup#">		