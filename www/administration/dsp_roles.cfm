<!--- //

	rollen-management
	
	// --->
	
<cfinclude template="dsp_inc_select_company.cfm">
	
<cfparam name="url.workgroupkey" type="string" default="">

<cfinclude template="queries/q_select_workgroups.cfm">

<h4><img src="/images/img_security_key.png" width="32" height="32" border="0" align="absmiddle"><cfoutput>#GetLangVal("adm_wd_roles")#</cfoutput></h4>


<cfquery name="q_select_workgroups" dbtype="query">
SELECT * FROM q_select_workgroups ORDER BY companykey;
</cfquery>

<cfoutput>#GetLangVal("adm_ph_roles_information")#</cfoutput><br><br>

<cfif len(url.workgroupkey) is 0>
	<!--- select now ... --->
	<table border="0" cellspacing="0" cellpadding="4">
	<form action="default.cfm" method="get">
	<input type="hidden" name="action" value="roles">
	<input type="hidden" name="companykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
	<input type="hidden" name="resellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
	  <tr>
		<td align="right">Gruppe:</td>
		<td>
		
		<cfset a_str_company_key = "">
		
		<select name="workgroupkey">
		<cfoutput query="q_select_workgroups">
			
			<cfif a_str_company_key neq q_select_workgroups.companykey>
			
				<cfset a_str_company_key = q_select_workgroups.companykey>
			
				<cfquery name="q_select_company_name" dbtype="query">
				SELECT companyname FROM request.q_company_admin
				WHERE companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_company_key#">;
				</cfquery>
			
				<option value="">--- #q_select_company_name.companyname# ---</option>
				
			</cfif>
			
			<option value="#q_select_workgroups.entrykey#">#q_select_workgroups.groupname#</option>
		</cfoutput>
		</select>		
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td><input type="submit" value="Anzeigen ..."></td>
	  </tr>
	</form>	  
	</table>
	
	<cfexit method="exittemplate">
</cfif>

<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupnamebyentrykey" returnvariable="sReturn">
	<cfinvokeargument name="entrykey" value="#url.workgroupkey#">
</cfinvoke>

<b>Arbeitsgruppe: <cfoutput><a href="default.cfm?action=workgroupproperties&entrykey=#urlencodedformat(url.workgroupkey)##writeurltags()#">#htmleditformat(sReturn)#</a></cfoutput></b><br><br>

<!--- // display roles ... // --->
<cfset SelectWorkgroupRoles.workgroupkey = url.workgroupkey>
<cfinclude template="queries/q_select_roles.cfm">

<table border="0" cellspacing="0" cellpadding="4">
  <tr class="lightbg">
    <td><b><cfoutput>#GetLangVal("cm_wd_name")#</cfoutput></b></td>
    <td><cfoutput>#GetLangVal("cm_wd_description")#</cfoutput></td>
    <td><cfoutput>#GetLangVal("cm_wd_created")#</cfoutput></td>
    <td><cfoutput>#GetLangVal("cm_wd_accounts")#</cfoutput></td>
    <td><cfoutput>#GetLangVal("cm_wd_action")#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_roles">
  <tr>
    <td>
	<a href="default.cfm?action=roleproperties&entrykey=#urlencodedformat(q_select_roles.entrykey)##writeurltags()#"><b>#q_select_roles.rolename#</b></a>
	</td>
    <td>
	#htmleditformat(q_select_roles.description)#
	</td>
    <td>#lsdateformat(q_select_roles.dt_created, "dd.mm.yy")#</td>
    <td>
	
	
	</td>
    <td>
	
	<cfif q_select_roles.standardtype is 0>
	Copy | <img src="/images/editicon.gif" align="absmiddle"> | <img src="/images/del.gif" align="absmiddle">
	<cfelse>
	n/a
	</cfif>
	
	</td>
  </tr>
  </cfoutput>
</table>

<br><br>
<a href="default.cfm?action=newrole&workgroupkey=<cfoutput>#urlencodedformat(url.workgroupkey)#</cfoutput>"><b><cfoutput>#GetLangVal("adm_ph_create_new_role")#</cfoutput></b></a>