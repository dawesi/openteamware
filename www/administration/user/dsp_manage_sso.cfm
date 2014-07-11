<!--- //

	Module:		Admin tool / users
	Action:		Manage SSO
	Description:Manage SSO mappings
	
// --->
<cfinclude template="../dsp_inc_select_company.cfm">

<!--- entrykey of user ... --->
<cfparam name="url.entrykey" type="string" default="">

<cfif Len(url.entrykey) IS 0>
	<cfabort>
</cfif>

<cfset a_cmp_customers = application.components.cmp_customer />
<cfset a_cmp_users = application.components.cmp_user>
<cfset q_select_sso_settings = application.components.cmp_security.LoadSwitchUsersData(userkey = url.entrykey)>

<h4>Single Sign On <cfoutput>#a_cmp_users.GetUsernameByEntrykey(url.entrykey)#</cfoutput></h4> 
<table class="table table-hover">
	<tr class="tbl_overview_header">
		<cfoutput>
		<td>
			#GetLangVal('cm_wd_username')#
		</td>
		<td>
			#GetLangVal('cm_wd_company')#
		</td>
		<td>
			#GetLangVal('cm_wd_action')#
		</td>
		</cfoutput>
	</tr>
	<cfoutput query="q_select_sso_settings">
			<tr>
				<td>
					#a_cmp_users.getusernamebyentrykey(q_select_sso_settings.otheruserkey)#
				</td>
				<td>
					#a_cmp_customers.GetCustomerNameByEntrykey(a_cmp_users.GetCompanyKeyOfuser(q_select_sso_settings.otheruserkey))#
				</td>
				<td>
					<a href="javascript:DeleteSSOBinding('#jsstringformat(q_select_sso_settings.entrykey)#', '#jsstringformat(q_select_sso_settings.userkey)#', '#jsstringformat(q_select_sso_settings.otheruserkey)#');">#GetLangVal('cm_wd_delete')#</a>
				</td>
			</tr>
	</cfoutput>
</table>

<b>Create a new binding</b>
<br />
<cfoutput>
<form action="user/act_do_create_sso_binding.cfm" method="post">
<input type="hidden" name="frmcompanykey" value="#url.companykey#">
<input type="hidden" name="frmresellerkey" value="#url.resellerkey#">
<input type="hidden" name="frmuserkey" value="#url.entrykey#">
	<table class="table table_details">
		<tr>
			<td class="field_name">#GetLangVal('cm_wd_username')#</td>
			<td>
				<select name="frmotheruserkey">
					
					<!--- show other company users ... --->
					<cfset SelectCompanyUsersRequest.companykey = request.q_company_admin.companykey>
					<cfinclude template="../queries/q_select_company_users.cfm">
					
					<cfquery name="q_select_company_users" dbtype="query">
					SELECT
						*
					FROM
						q_select_company_users
					WHERE
						NOT entrykey = '#url.entrykey#'
					;
					</cfquery>
					
					<cfloop query="q_select_company_users">
						<option value="#q_select_company_users.entrykey#">#q_select_company_users.username#</option>
					</cfloop>
					
					<!--- display other users ... --->
					<cfif StructKeyExists(request, 'q_select_reseller') AND
							(request.q_select_reseller.recordcount GT 0)>
						<cfinclude template="../queries/q_select_companies.cfm">
					
					<cfloop query="q_select_companies">
						<optgroup label="#htmleditformat(q_select_companies.companyname)#">
						
						<cfset SelectCompanyUsersRequest.companykey = q_select_companies.entrykey>
						<cfinclude template="../queries/q_select_company_users.cfm">
						
						<cfloop query="q_select_company_users">
							<option value="#q_select_company_users.entrykey#">#q_select_company_users.username#</option>
						</cfloop>
						
						</optgroup>
					</cfloop>
					
					</cfif>
					
				</select>
			</td>
		</tr>
		<tr>
			<td class="field_name">#GetLangVal('cm_Wd_comment')#</td>
			<td>
				<input type="text" name="frmcomment" value="" />
			</td>
		</tr>
		<tr>
			<td></td>
			<Td>
				<input class="btn btn-primary" type="submit" value="Add binding ...">
			</Td>
		</tr>
	</table>
</form>
</cfoutput>
<script type="text/javascript">
	function DeleteSSOBinding(entrykey, userkey, otheruserkey) {
		var a_simple_modal_dialog = new cSimpleModalDialog();
		a_simple_modal_dialog.type = 'confirmation';
		a_simple_modal_dialog.customcontent = '';
		a_simple_modal_dialog.executeurl = 'user/act_delete_sso_binding.cfm?entrykey=' + escape(entrykey) + '&userkey=' + escape(userkey) + '&otheruserkey=' + escape(otheruserkey);
		// show dialog
		a_simple_modal_dialog.ShowDialog();	
		}
</script>

