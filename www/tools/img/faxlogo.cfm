<cfparam name="url.source" type="string" default="">

<cfif CheckSimpleLoggedIn() IS FALSE AND Len(url.source) IS 0>
	<cfabort>
</cfif>



<!--- the userkey ... --->
<cfparam name="url.entrykey" type="string" default="">

<cfinclude template="queries/q_select_faxlogo.cfm">

<cfif q_select_faxlogo.recordcount is 0>	
	<!--- no photo avaliable ... return space_1_1 --->
	<cfcontent deletefile="no" file="#request.a_str_img_1_1_pixel_location#" type="image/gif">
	<cfabort>
</cfif>

<cfset a_str_filedata = q_select_faxlogo.imagedata>

<!--- write file ... --->
<cfset a_str_tmp_filename = request.a_str_temp_directory&request.a_str_dir_separator&CreateUUID()>
<cffile action="write" file="#a_str_tmp_filename#" output="#ToBinary(a_str_filedata)#" addnewline="no">

<!--- and deliver ... --->
<cfcontent type="#q_select_faxlogo.contenttype#" file="#a_str_tmp_filename#" deletefile="no">