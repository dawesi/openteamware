<cfparam name="url.contactkey" type="string" default="">

<!--- name of div where content will be written to --->
<cfparam name="url.divname" type="string" default="">

<!--- rights the user calling this script has on this contact ... maybe do NOT offer possibility to delete something ... --->
<cfparam name="url.rights" type="string" default="read">

<!--- if empty, take root directory --->
<cfparam name="url.directorykey" type="string" default="">

<!--- in manager mode, so that we offer methods to add / edit / delete files? --->
<cfparam name="url.managemode" type="boolean" default="false">

<cfif Len(url.contactkey) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset url.managemode = true>

<cfinvoke component="#application.components.cmp_crmsales#" method="DisplayFilesAttachedToUser" returnvariable="a_str_output_files">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkey" value="#url.contactkey#">
	<cfinvokeargument name="directorykey" value="#url.directorykey#">
	<cfinvokeargument name="divname" value="#url.divname#">
	<cfinvokeargument name="managemode" value="#url.managemode#">
</cfinvoke>

<cfoutput>#a_str_output_files#</cfoutput>