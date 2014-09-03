<!--- //

	Module:        Import
	Description:   Upload file, initiate parsing and forward to field mapping


// --->

<cfsetting requesttimeout="2000">


<!--- check if the file was selected on the upload screen --->
<cfparam name="form.frm_filename" default="">
<cfparam name="form.frm_servicekey" type="string">
<cfparam name="form.frm_datatype" type="numeric" default="0">
<cfparam name="form.frmadvanced_criteria_selection" type="numeric" default="0">
<cfparam name="form.form.frm_servicekey" type="string" default="">

<cfif Len(form.frm_filename) EQ 0>
	<cflocation url="index.cfm?action=UploadFile&ibxerrorno=12504" />
</cfif>

<!--- valid servicekey provided? --->
<cfif Len(form.frm_servicekey) EQ 0>
	<cflocation url="index.cfm?action=UploadFile&ibxerrorno=12504" />
</cfif>

<!--- save the uploaded file --->
<cfset a_str_temp_file = getTempDirectory() & request.a_str_dir_separator & createUUID() & '.xls' />
<cffile action="upload" filefield="frm_filename" destination="#a_str_temp_file#">

<cfinvoke component="#application.components.cmp_import#" method="ParseUploadedFileAndReturnResult" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="servicekey" value="#form.frm_servicekey#">
	<cfinvokeargument name="datatype" value="#form.frm_datatype#">
	<cfinvokeargument name="jobkey" value="#form.frm_jobkey#">
	<cfinvokeargument name="filename" value="#a_str_temp_file#">
	<cfinvokeargument name="filetype" value="xls">
</cfinvoke>

<cfif NOT stReturn.result>
	<cflocation url="index.cfm?action=UploadFile#WriteIBXErrorURL(stReturn)#" />
</cfif>

<cflocation url="index.cfm?action=FieldMappings&jobkey=#form.frm_jobkey#&advancedcriteriaselection=#form.frmadvanced_criteria_selection#" addtoken="false" />

