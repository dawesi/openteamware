<!--- //

	Module:		Framework
	Description:Display company logo
	

// --->

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_content#" method="GetCompanyLogoImgPath" returnvariable="a_struct_logo">
	<cfinvokeargument name="companykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT a_struct_logo.result>
	<cfcontent deletefile="no" file="#request.a_str_img_1_1_pixel_location#" type="image/gif">
	<cfabort>
</cfif>

<cfset a_str_tmp_filename = request.a_str_temp_directory & request.a_str_dir_separator & 'company_logo_' & a_struct_logo.entrykey>

<!--- temo file exists? --->
<cfif FileExists(a_str_tmp_filename)>
	<cfcontent type="#a_struct_logo.contenttype#" file="#a_str_tmp_filename#" deletefile="no">
	<cfexit method="exittemplate">
</cfif>

<!--- write file ... --->
<cffile action="write" file="#a_str_tmp_filename#" output="#ToBinary(a_struct_logo.imagedata)#" addnewline="no">

<!--- and deliver ... --->
<cfcontent type="#a_struct_logo.contenttype#" file="#a_str_tmp_filename#" deletefile="no">

