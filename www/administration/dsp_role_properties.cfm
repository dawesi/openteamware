<!--- //

	role properties
	
	// --->
	
<cfinclude template="dsp_inc_select_company.cfm">
	
<cfparam name="url.entrykey" type="string" default="">

<!--- load role ... --->
<cfset SelectRoleRequest.entrykey = url.entrykey>
<cfinclude template="queries/q_select_role.cfm">

<!--- select role permissions ... --->
<cfset SelectRolePermissionsRequest.entrykey = url.entrykey>
<cfinclude template="queries/q_select_role_permissions.cfm">

<!--- select all services ... --->
<cfinclude template="queries/q_select_services.cfm">


<h4><img src="/images/img_security_key.png" width="32" height="32" hspace="3" vspace="3" border="0" align="absmiddle"> Rollen-Eigenschaften</h4>


<cfif q_select_role.recordcount is 0>
	<h4>no such role found</h4>
	<cfexit method="exittemplate">
</cfif>

<table cellpadding="4" cellspacing="0" border="0">
	<tr>
		<td valign="top">

		<table border="0" cellspacing="0" cellpadding="4">
		<cfoutput query="q_select_role">
		  <tr>
			<td align="right">#GetLangVal('cm_wd_name')#:</td>
			<td>
			#q_select_role.rolename#
			</td>
		  </tr>
		  <tr>
			<td align="right">#GetLangVal('cm_wd_description')#:</td>
			<td>
			#q_select_role.description#
			</td>
		  </tr>
		  <tr>
			<td align="right">Gruppe:</td>
			<td>
			#q_select_role.workgroupkey#
			</td>
		  </tr>
		  <tr>
			<td align="right" valign="top">
			Zugeordnete Mitglieder:
			</td>
			<td valign="top">
			
			
			</td>
		  </tr>
		  <tr>
			<td align="right">Standard-Typ:</td>
			<td>
			#q_select_role.standardtype#
			</td>
		  </tr>
		  <tr>
			<td align="right">#GetLangVal('cm_wd_created')#:</td>
			<td>#lsdateformat(q_select_role.dt_created, "dd.mm.yy")#</td>
		  </tr>
		</cfoutput>
		
		<!--- display role properties ... --->
		<tr>
			
		</tr>
		
		<cfif q_select_role.standardtype is 0>
		<tr>
			<td></td>
			<td>
			<b><a href="index.cfm?action=editrole&entrykey=<cfoutput>#urlencodedformat(url.entrykey)##writeurltags()#</cfoutput>"><img src="/images/editicon.gif" align="absmiddle" vspace="3" hspace="3" border="0">&nbsp; editieren</a></b>
			</td>
		</tr>
		</cfif>
		</table>
		
		

		</td>
		<td valign="top">
		
		<!--- display the actions and permissions ... --->
		<table border="0" cellspacing="0" cellpadding="4">
		<cfoutput query="q_select_services">
		
		<cfquery name="q_select_actions" dbtype="query">
		SELECT allowedactions FROM q_select_role_permissions
		WHERE servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_services.entrykey#">;
		</cfquery>
		
		  <tr>
			<td class="bb">
			<cfif q_select_actions.recordcount is 0>
			<font style="color:red;">
			<cfelse>
			<font style="color:darkgreen;">
			</cfif>			
			
			<b>#GetLangVal("cm_wd_servicename_"&q_select_services.entrykey)#</b></td>
		  </tr>
		  <tr>
		  	<td style="padding-left:20px;">
			<cfloop index="a_str_action" list="#q_select_actions.allowedactions#" delimiters=",">
			#GetLangVal("cm_wd_action_"&a_str_action)#<br>
			</cfloop>
			
			<cfif q_select_actions.recordcount is 0>
			kein Zugriff
			</cfif>
			</td>
		  </tr>
		</cfoutput>
		</table>

		
		
		
		</td>
	</tr>
</table>