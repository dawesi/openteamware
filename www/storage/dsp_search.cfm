<!--- //

	Module:		Storage
	Action:		Search
	Description: 
	

// --->

<cfparam name="url.frm_searchstring" default="" type="string">
<cfparam name="url.ordertype" type="string" default="">
<cfparam name="url.orderby" type="string" default="">			  
<cfparam name="url.a_int_page" default="0" type="numeric">
<cfparam name="url.a_int_matchesperpage" default="50" type="numeric">
<cfparam name="url.frm_fulltext" type="boolean" default="false">
<cfparam name="url.frmtype" type="string" default="file">

<cfif url.action IS 'search'>
	<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_search'))>
</cfif>

<cfif Len(url.frmtype) IS 0>
	<cfset url.frmtype = 'file' />
</cfif>

<form action="index.cfm" method="get" style="margin:0px; ">
<input type="hidden" name="action" value="search">

<table class="table_details table_edit_form">
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_ph_searchterm')#</cfoutput>
		</td>
		<cfoutput>
		<td>
			<input name="frm_searchstring" value="#htmleditformat(url.frm_searchstring)#" size="20" />
			
		</td>
		</cfoutput>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_type')#</cfoutput>
		</td>
		<td>
			<input type="checkbox" name="frmtype" value="file" class="noborder" <cfif ListFindNoCase(url.frmtype, 'file') GT 0>checked="true"</cfif> /> <cfoutput>#GetLangVal('sto_wd_file')#</cfoutput>
			<input type="checkbox" name="frmtype" value="directory" class="noborder" <cfif ListFindNoCase(url.frmtype, 'directory') GT 0>checked="true"</cfif> /> <cfoutput>#GetLangVal('sto_wd_directory')#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name"></td>
		<td><input type="submit" value="<cfoutput>#getlangval('sto_ph_startsearch')#</cfoutput>" class="btn btn-primary" /></td>
	</tr>
	<!--- <tr>
		<td class="field_name">
		</td>
		<td>
			<input type="checkbox" name="frm_fulltext" value="true" class="noborder" <cfif url.frm_fulltext>checked</cfif>> <cfoutput>#getlangval('sto_ph_fulltext')#</cfoutput>
		</td>
	</tr> --->
	<!--- <cfif url.action IS 'search'>
		<tr>
			<td></td>
			<td class="addinfotext">
				<cfoutput>#GetLangVal('sto_ph_hint_fullindex')#</cfoutput>
			</td>
		</tr>
	</cfif> --->
</table>
</form>

<!--- execute search ... --->
<cfif Len(Trim(url.frm_searchstring)) GT 0>

	<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "Search"   
		returnVariable = "a_struct_search"   
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
		searchstring="#url.frm_searchstring#"
		fulltext="#url.frm_fulltext#"
		types="#url.frmtype#"
		includeshareddirectories="true">
	</cfinvoke>
	
	<cfset a_query_displayfiles=a_struct_search.expanded_query />
	
	<cfset request.a_bool_disable_search=true>
	<cfinclude template="dsp_display_files.cfm">
	
</cfif>



