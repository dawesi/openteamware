<!--- //



	edit a role

	

	// --->

<cfinclude template="dsp_inc_select_company.cfm">
	

<cfparam name="url.entrykey" type="string" default="">



<!--- select the role ... --->

<cfset SelectRoleRequest.entrykey = url.entrykey>

<cfinclude template="queries/q_select_role.cfm">



<!--- select role permissions ... --->

<cfset SelectRolePermissionsRequest.entrykey = url.entrykey>

<cfinclude template="queries/q_select_role_permissions.cfm">



<!--- select all services ... --->

<cfinclude template="queries/q_select_services.cfm">



<cfset cmp_security = application.components.cmp_security>



<h4><img src="/images/img_security_key.png" width="32" height="32" hspace="3" vspace="3" border="0" align="absmiddle"> Rolle editieren</h4>

Hinweis: Die Rollen-Berechtigungen wirken sich nur auf die Gruppen-Daten aus - private Daten sind davon nicht betroffen!

<br><br>

<table border="0" cellspacing="0" cellpadding="6">

<form action="act_edit_role.cfm" method="post" name="formeditrole">

<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">



<cfoutput query="q_select_role">

<tr>

	<td colspan="2" class="bb"><b>Eigenschaften</b></td>

</tr>

  <tr>

    <td align="right">Name:</td>

    <td>

	<input type="text" name="frmname" value="#htmleditformat(q_select_role.rolename)#" size="30">

	</td>

  </tr>

  <tr>

    <td align="right">Beschreibung:</td>

    <td>

	<input type="text" name="frmdescription" value="#htmleditformat(q_select_role.description)#" size="30">

	</td>

  </tr>

</cfoutput>  

<tr>

	<td colspan="2" class="bb"><b>Dienste</b></td>

</tr>

<tr>

	<td colspan="2">

	

	<table cellpadding="8" border="0">

		<tr>

			

	

			<cfoutput query="q_select_services">

			<td valign="top">

			

			

			<!--- load avaliable actions ... --->

			<cfset Variables.q_select_actions = cmp_security.LoadAvaliableActionsofService(q_select_services.entrykey)>

			

			<cfquery name="q_select_actions" dbtype="query">

			SELECT * FROM Variables.q_select_actions

			ORDER BY parentkey;

			</cfquery>

			

			<!--- select saved data ... --->

			<cfquery name="q_select_saved_actions" dbtype="query">

			SELECT allowedactions FROM q_select_role_permissions

			WHERE servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_services.entrykey#">;

			</cfquery>

			

			<cfset a_str_saved_actions = "">

			

			<cfloop index="a_str_action" list="#q_select_saved_actions.allowedactions#" delimiters=",">

				<cfset a_str_saved_actions = a_str_saved_actions&","&a_str_action>

			</cfloop>

			

			

			  <table width="150" border="0" cellpadding="4" cellspacing="0" class="b_all">

			  <tr>

				<td>&nbsp;</td>

				<td><b>#GetLangVal("cm_wd_servicename_"&q_select_services.entrykey)#</b></td>

			  </tr>

			  <cfloop query="Variables.q_select_actions">

			  <tr>

				<td></td>    

				<td>

				<cfif Len(q_select_actions.parentkey) gt 0>&nbsp;&nbsp;&nbsp;&nbsp;</cfif>

				<input <cfif ListFindNoCase(a_str_saved_actions,q_select_actions.actionname) gt 0>checked</cfif> <cfif Len(q_select_actions.parentkey) gt 0>onClick="CheckChecked('#q_select_actions.parentkey#', this);"</cfif> type="checkbox" name="frmcbpermissions" value="#htmleditformat(Variables.q_select_actions.entrykey)#"> #GetLangVal("cm_wd_action_"&Variables.q_select_actions.actionname)#

				</td>

			  </tr>

			  </cfloop>

			  </table>



			  </td>

			  

			  <cfif q_select_services.currentrow mod 3 is 0>

			  	<!--- new row ... --->

			  	</tr><tr>

			  </cfif>

			  

			  </cfoutput>

	  

	  		</td>

		</tr>

	</table>

	

	</td>

</tr>

  <tr>

  	<td>&nbsp;</td>

	<td>

	<input type="submit" name="frmsubmit" value="Speichern ...">

	</td>

  </tr>

</form>

</table>



<script type="text/javascript">

	function CheckChecked(parentkey, sender)

		{

		

		var x,i;

		

		if (sender.parentkey == '') return;

		

		if (sender.checked == true)

			{

			// check if parent box has been checked

			

			for (i = 0; i<document.formeditrole.length; i++)

				{

				

				x=document.formeditrole[i];

				

				if (x.value == parentkey)

					{

					

					if (x.checked == false)

						{

						alert('Sie muessen das "Lesen" von Eintraegen zulassen um diese Aktion aktivieren zu koennen');

						sender.checked = false;

						}

				

					}

				

				}

			

			

			}

		}

</script>