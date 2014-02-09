<!--- //

	Module:		Address Book
	Action:		DoMultiSelectAction
	Description:Compose a new mail to all selected addresses
	
// --->

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.entrykeys = form.frmcbselect />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">			
	<cfinvokeargument name="fieldlist" value="entrykey,email_prim">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts />

<cfset a_str_to = '' />

<cfoutput query="q_select_contacts">
	
	<cfset a_str_email_Adr = ExtractEmailAdr(q_select_contacts.email_prim) />
	
	<cfif (Len(a_str_email_Adr) GT 0) AND (ListFindNoCase(a_str_to, a_str_email_adr) IS 0)>
		<cfset a_str_to = ListAppend(a_str_to, a_str_email_Adr) />
	</cfif>
	
</cfoutput>

<cfdump var="#a_str_to#">
