<!--- //

	Module:		Address Book
	Action:		UploadPhotoForContact
	Description: 
	
// --->

<cfparam name="form.frmfile" type="string" default="">
<cfparam name="form.frmentrykey" type="string" default="">

<!--- remove picture ... --->
<cfif StructKeyExists(form, 'frmsubmit_removephoto')>
	
	<cfinvoke component="#application.components.cmp_Addressbook#" method="RemoveContactPhoto" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	</cfinvoke>
	
	<cflocation addtoken="false" url="default.cfm?action=ShowItem&entrykey=#form.frmentrykey#">
</cfif>

<cfif Len(form.frmfile) IS 0>
	No file entered.
	<cfexit method="exittemplate">
</cfif>

<cffile action="upload" destination="#request.a_str_temp_directory#" filefield="form.frmfile" nameconflict="makeunique">

<cfif cffile.ContentType NEQ 'image'>
	Invalid. Only images are allowed (PNG/JPG/GIF)
	<cfexit method="exittemplate">
</cfif>

<cfif Val((cffile.FileSize / 1024)) GT 120>
	File is too big (max 120kb).
	<cfexit method="exittemplate">
</cfif>

<cfset sFilename = cffile.ServerDirectory & request.a_str_dir_separator & cffile.ServerFile />

<cfinvoke component="#application.components.cmp_Addressbook#" method="StoreContactPhoto" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="contenttype" value="#cffile.ContentType#/#cffile.ContentSubType#">
	<cfinvokeargument name="filename" value="#sFilename#">
</cfinvoke>

<cflocation addtoken="false" url="default.cfm?action=ShowItem&entrykey=#form.frmentrykey#">

