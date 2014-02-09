<!--- //

	// --->
	
<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>
	
<cfparam name="url.company" type="string" default="">
<cfparam name="url.surname" type="string" default="">
<cfparam name="url.firstname" type="string" default="">
<cfparam name="url.email" type="string" default="">
<cfparam name="url.remoteedit" type="string" default="false">


<!--- // add to address book // --->
<cfinvoke component="#application.components.cmp_addressbook#" method="CreateContact" returnvariable="a_struct_create_contact">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="firstname" value="#url.firstname#">
	<cfinvokeargument name="surname" value="#url.surname#">
	<cfinvokeargument name="company" value="#url.company#">
	<cfinvokeargument name="email_prim" value="#url.email#">
</cfinvoke>		

<!--- // activate remote edit? --->
<cfif url.remoteedit IS true>

		<cfinvoke component="#application.components.cmp_addressbook#" method="ActivateRemoteEdit" returnvariable="stReturn">
			<cfinvokeargument name="entrykey" value="#a_struct_create_contact.entrykey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">		
		</cfinvoke>

</cfif>