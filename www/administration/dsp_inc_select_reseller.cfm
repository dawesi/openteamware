<!--- //

	Component:	Admintool
	Description: If it is a reseller, display the selection ...
		Header:	

// --->

<cfif NOT StructKeyExists(url, 'resellerkey') OR Len(url.resellerkey) IS 0>

		<cfif request.q_select_reseller.recordcount is 1>
			<!--- only one reseller definied ... use this one --->
			<cfset url.resellerkey = request.q_select_reseller.entrykey />
			<cfset form.frmresellerkey = request.q_select_reseller.entrykey />
			<cfexit method="exittemplate">
		<cfelse>
			
		
		<form method="get" action="<cfoutput>#cgi.SCRIPT_NAME#</cfoutput>">
		<table class="table table_details table_edit_form">

			<cfloop collection="#url#" item="F">
			
				<cfif ListFindNoCase('companykey', f) IS 0>
					<cfoutput>
					<input type="hidden" name="#lcase(f)#" value="#structFind(url, F)#" />
					</cfoutput>
				</cfif>
			
			</cfloop>	
		
			<tr>
				<td class="field_name"><cfoutput>#GetLangVal('adm_wd_partner')#</cfoutput>:</td>
				<td>
				<select name="resellerkey">
					<cfoutput query="request.q_select_reseller">
					<option value="#htmleditformat(request.q_select_reseller.entrykey)#"><cfloop from="1" to="#request.q_select_reseller.resellerlevel#" index="ii">&nbsp;&nbsp;</cfloop>#htmleditformat(request.q_select_reseller.companyname)#</option>
					</cfoutput>
				</select>
				</td>
			</tr>	
			  <tr>
				<td class="field_name">&nbsp;</td>
				<td>
					<input type="submit" class="btn btn-primary" value="<cfoutput>#GetLangVal('adm_ph_btn_search_filter')#</cfoutput>" />
				</td>
			  </tr>
			</table>
			</form>
			
		<cfthrow errorcode="abortpageprocessing">
	</cfif>
</cfif>

<!--- check if access is allowed ... --->
<!---<cfquery name="q_select_access_allowed" dbtype="query">
SELECT
	*
FROM
	q_select_reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
;
</cfquery>

<cfif q_select_access_allowed.recordcount IS 0>
	<h4>405 - not allowed ...</h4>
	<cfabort>
</cfif>--->

