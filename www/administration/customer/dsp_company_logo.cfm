<!--- //

	Module:		Administrationtool
	Action:		Companylogo
	Description:Let the user set / delete the company logo
	
// --->

<!--- TODO: ADD TRANSLATION --->

<cfparam name="url.subaction" type="string" default="">

<cfinclude template="../dsp_inc_select_company.cfm">


<form action="default.cfm?action=companylogo&subaction=upload<cfoutput>#WriteURLTags()#</cfoutput>" method="post" enctype="multipart/form-data">
	<input type="file" name="frmfile">
	<input type="submit">
</form>

<cfswitch expression="#url.subaction#">
	<cfcase value="delete">
	<!--- remove the current logo --->
	<cfinvoke component="#application.components.cmp_content#" method="DeleteCompanyLogo" returnvariable="ab">
		<cfinvokeargument name="companykey" value="#url.companykey#">
	</cfinvoke>
	
	done.
	</cfcase>
	<cfcase value="upload">
	<!--- uploaded a new image? --->
	<cfif (cgi.REQUEST_METHOD IS 'POST') AND (Len(form.frmfile) GT 0)>
	
		<cfset sFilename = request.a_str_temp_directory & request.a_str_dir_separator & CreateUUID()>
		<cffile action="upload" destination="#sFilename#" filefield="form.frmfile" nameconflict="makeunique">	
	
		<cffile action="readbinary" file="#sFilename#" variable="a_str_data">
	
		<cfinvoke component="#request.a_Str_component_content#" method="UpdateCompanyLogo" returnvariable="stUpdate">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="companykey" value="#url.companykey#">
			<cfinvokeargument name="imagedata" value="#a_str_data#">
			<cfinvokeargument name="contenttype" value="#cffile.ContentType#/#cffile.ContentSubType#">
		</cfinvoke>
	
	</cfif>
	</cfcase>
</cfswitch>


<cfset a_struct_logo = CreateObject('component', request.a_str_component_content).GetCompanyLogoImgPath(companykey = url.companykey)>

<cfif a_struct_logo.result>
<div class="b_all" style="padding:10px;">
<cfoutput >
<img src="/tools/img/show_company_logo.cfm?entrykey=#url.companykey#">
</cfoutput>
</div>

<a href="default.cfm?action=companylogo&subaction=delete<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_delete')#</cfoutput></a>
</cfif>