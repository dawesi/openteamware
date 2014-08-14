<!--- //

	Module:		Display
	Description:Show small userphoto


// --->

<cfparam name="url.source" type="string" default="">

<cfabort>
<!--- ignore feature for now --->

<cfif CheckSimpleLoggedIn() IS FALSE AND Len(url.source) IS 0>
	<cfabort>
</cfif>

<!--- the userkey ... --->
<cfparam name="url.entrykey" type="string" default="">

<!--- type (0 = small; 1 = big) --->
<cfparam name="url.type" type="numeric" default="0">

<cfset a_str_tmp_filename = request.a_str_temp_directory & request.a_str_dir_separator & 'photo_small_' & url.entrykey />

<!--- temo file exists? --->
<cfif FileExists(a_str_tmp_filename)>
	<cfcontent type="image/jpeg" file="#a_str_tmp_filename#" deletefile="yes">
	<cfexit method="exittemplate">
</cfif>

<cfset SelectPhotoRequest.userkey = url.entrykey>
<cfset SelectPhotoRequest.type = url.type>
<cfinclude template="queries/q_select_photodata.cfm">

<cfif q_select_photodata.recordcount is 0>
	<!--- no photo avaliable ... return space_1_1 --->
	<cfcontent deletefile="no" file="#request.a_str_img_1_1_pixel_location#" type="image/gif">
	<cfexit method="exittemplate">
</cfif>

<cfset a_str_filedata = q_select_photodata.photodata />

<!--- write file ... --->
<cffile action="write" file="#a_str_tmp_filename#" output="#ToBinary(a_str_filedata)#" addnewline="no">

<!--- and deliver ... --->
<cfcontent type="#q_select_photodata.contenttype#" file="#a_str_tmp_filename#" deletefile="yes">

