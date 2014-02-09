<!--- //

	Module:		Address Book
	Description:Update Last contact
	
// --->

<cfset stUpdate = StructNew() />
<cfset stUpdate.dt_lastcontact = GetUTCTimeFromUserTime(now()) />
		
<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#a_struct_parse.data.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="newvalues" value="#stUpdate#">
	<cfinvokeargument name="updatelastmodified" value="false">
</cfinvoke>
