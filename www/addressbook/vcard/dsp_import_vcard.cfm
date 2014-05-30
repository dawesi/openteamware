<!--- //

	Module:		
	Action:		
	Function:	
	Description:
	
	Header:		

// --->

TODO: think about implementing this feature

<cfparam name="form.frmfileupload" type="string" default="">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_import_vcard')) />

<cfif Len(form.frmfileupload) IS 0>

<form action="index.cfm?action=ImportVcard" method="post" enctype="multipart/form-data">
	<input type="file" name="frmfileupload" />
	<input type="submit" value="upload" class="btn btn-primary" />
</form>

<cfexit method="exittemplate">
</cfif>
<cfdump var="#form#">

<cffile action="upload" destination="#request.a_str_temp_directory_local#" filefield="frmfileupload" nameconflict="makeunique">

<cfset sFilename = cffile.ServerDirectory & request.a_Str_dir_separator & cffile.ServerFile />

<cfdump var="#sFilename#">

<cffile action="read" charset="iso-8859-1" file="#sFilename#" variable="a_str_output">
<pre>
<cfoutput>#a_str_output#</cfoutput>
</pre>

