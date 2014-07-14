<!--- //

	Module:		Storage
	Action.		CreatenewFile
	Description: 
	

// --->

<cfparam name="form.frmfilename" type="string">
<cfparam name="form.frmdescription" type="string">

<!--- save tmp file ... --->
<cfset sFilename = request.a_Str_temp_directory & createuuid() & '.html'>
<cffile action="write" addnewline="no" charset="utf-8" file="#sFilename#" output="#form.frmfilecontent#">

<cfif FindNoCase('.htm', form.frmfilename) IS 0>
	<cfset form.frmfilename = form.frmfilename & '.html' />
</cfif>

<cfinvoke component="#application.components.cmp_storage#" method="AddFile" returnVariable = "a_struct_addfile">
	<cfinvokeargument name="filename" value="#form.frmfilename#">
	<cfinvokeargument name="location" value="#sFilename#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="contenttype" value="text/html">
	<cfinvokeargument name="directorykey" value="#form.frmdirectorykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filesize" value="#fileSize(sFilename)#">
	<cfinvokeargument name="forceoverwrite" value="true">
</cfinvoke>
			
<cflocation addtoken="no" url="index.cfm?action=ShowFiles&directorykey=#form.frmdirectorykey#">

