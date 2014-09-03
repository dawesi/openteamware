<cfparam name="form.frmfileupload" type="string" default="">

<cfif Len(form.frmfileupload) IS 0>

<form action="index.cfm?action=ImportVcard" method="post" enctype="multipart/form-data">
	<input type="file" name="frmfileupload" />
	<input type="submit" value="upload" class="btn btn-primary" />
</form>

<cfexit method="exittemplate">
</cfif>
<cfdump var="#form#">

<cffile action="upload" destination="#getTempDirectory()#" filefield="frmfileupload" nameconflict="makeunique">

<cfset sFilename = cffile.ServerDirectory & request.a_Str_dir_separator & cffile.ServerFile />

<cfdump var="#sFilename#">

<cffile action="read" charset="iso-8859-1" file="#sFilename#" variable="a_str_output">
<pre>
<cfoutput>#a_str_output#</cfoutput>
</pre>

