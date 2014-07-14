<!--- display the html version of a message



	the message is displayed in an iframe (IE), otherwise a link is presented

	

	<io>

		<in>

			<param name="id" scope="url" type="string">

			the file name

			</param>

			

			<param name="charset" scope="url" type="string">

			charset

			</param>

			

			<param name="secure" scope="url" type="numeric" default=1>

			secure ... disable forms and scripts

			</param>

			

			<param name="privacyguardenabled" scope="url" type="numeric" default=1>

			do not load images/web bugs from the web

			</param>

			

		

		</in>	

	</io>

	



	--->

<cfinclude template="../login/check_logged_in.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">


<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">

<cfparam name="url.id" type="string" default="">

<cfparam name="url.charset" type="string" default="">

<cfparam name="url.secure" type="numeric" default="1">

<cfparam name="url.privacyguardenabled" type="numeric" default="1">



<cfif len(url.charset) is 0>

	<cfset a_str_charset = "ISO-8859-1">

<cfelse>

	<cfset a_str_charset = url.charset>

</cfif>



<cfset sFilename = request.a_str_temp_directory_local&url.id>



<cfif FileExists(sFilename) is false>

	<h5>The requested file does not exist - please reload the message</h5>

	<h4>Bitte laden Sie die Nachricht erneut!</h4>

	<cfabort>

</cfif>

<cftry>
<cffile action="read" file="#sFilename#" variable="a_Str_file" charset=#a_str_charset#>
<cfcatch type="any">
	<!--- wrong charset information provided - use none (default) --->
	<cffile action="read" file="#sFilename#" variable="a_Str_file">
</cfcatch>
</cftry>







<cfif url.secure is 1>

	<!--- disable scripts, forms, external links and so on ... --->

	<cfset a_str_file = ReplaceNoCase(a_str_file, "<script", 	"<!--<__s_c_r_i_p_t", "ALL")>
	<cfset a_str_file = ReplaceNoCase(a_str_file, "</script>", 	"</__s_c_r_t_i_p>-->", "ALL")>	

	<cfsavecontent variable="a_str_css">
		<style media="all" type="text/css">
			body {border:#EEEEEE solid 1px;margin:4px;padding:4px;}
		</style>
	</cfsavecontent>

	<cfset a_str_file = ReplaceNoCase(a_str_file, "<body", '<base target=""_blank"">' & a_str_css & '<body', "ONE")>

	<cfset a_Str_file = safetext(a_str_file, true)>

	

	<cfset a_str_file = ReplaceNoCase(a_str_file, "href=""mailto:", "href=""index.cfm?action=composemail&type=0&to=", "ALL")>

	<cfset a_str_file = ReplaceNoCase(a_str_file, "?subject=", "&subject=", "ALL")>
	
	<cfset a_str_file = ReplaceNoCase(a_str_file, '<a ', '<a target="_blank"', 'ALL')>

</cfif>



<cfif url.privacyguardenabled is 1>

	<!--- replace all image links ... --->

	<cfset a_str_file = ReplaceNoCase(a_str_file, "src=""", "src=""about:blank/", "ALL")>

<cfelse>

	<!--- look for cids ... --->

	<!--- example: cid:734292615@28052003-3119 --->

	<cfif (FindNoCase("cid:", a_str_file) gt 0) AND (IsDefined("session.q_msg_attachments"))>
	
	<cfloop query="session.q_msg_attachments">
		<cfif Len(session.q_msg_attachments.cid) GT 0>
			
			<cfset a_str_cid = ReplaceNoCase(ReplaceNoCase(session.q_msg_attachments.cid, '<', ''), '>', '')>
			
			<cfset a_str_tmp_filename = GetFileFromPath(session.q_msg_attachments.tempfilename)>
			
			<cfset a_str_img_link = 'show_load_saved_att_img.cfm?src='&a_str_tmp_filename&'&contenttype='&session.q_msg_attachments.contenttype&'&userkey='&url.userkey>
			
			<cfset a_str_file = ReplaceNoCase(a_str_file, 'cid:'&a_str_cid, a_str_img_link, 'ALL')>
			
		</cfif>
	</cfloop>
	

	<!---<cfset q_msg_attachments = session.q_msg_attachments>

	

	<cfset a_int_cid_pos = 1>



	<cfset ii = 1>

	<cfloop condition="a_int_cid_pos LTE Len(a_str_file)">

	<cfset a_arr_pos = ReFindNoCase("cid[:,a-z,A-Z,0-9,_,@,-]*", a_str_file, a_int_cid_pos, true)>

	

	<!---<cfdump var="#a_arr_pos#">--->

	<cfset a_int_cid_pos = a_arr_pos.pos[1]+a_arr_pos.len[1]+1>



	<cfif a_arr_pos.pos[1] gt 0>

		<cfset a_str_cid = Mid(a_str_file, a_arr_pos.pos[1], a_arr_pos.len[1])> 

		<cfoutput>#a_str_cid#</cfoutput>

		

		<cftry>

		<cfif len(a_str_cid) gt 0>

		<cfquery name="q_select_cid" dbtype="query">

		SELECT tempfilename FROM q_msg_attachments

		WHERE cid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_cid#">;	

		</cfquery>

		<cfdump var="#q_select_cid#">

		</cfif>

		<cfcatch type="any">

		<cfdump var="#cfcatch.Detail#">

		</cfcatch>

		</cftry>

	</cfif>

	

	

	<cfif a_int_cid_pos is 1>

		<cfset a_int_cid_pos = len(a_str_file)+100>

	</cfif>

	

	<cfset ii = ii + 1>

	

	<cfif ii gt 100>

		<cfbreak>

	</cfif>

	

	

	</cfloop>--->

	

	

	</cfif>

</cfif>

<!--- quick hack ... --->
<cfloop from="0" to="100" index="ii">
	<cfset a_str_file = ReplaceNoCase(a_str_file, 'http://192.168.0.1/att'&ii&'.jpg', '/images/space_1_1.gif')>
</cfloop>



<cfoutput>#a_str_file#</cfoutput>



<!---<cffile action="delete" file="#sFilename#">--->