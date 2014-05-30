<!--- //

	Module:        Settings
	Action:		   ManageSSO
	Description:   Let the user manage Single Sign on Data ...
	
	Parameters

// --->

<cfset a_cmp_customers = application.components.cmp_customer />
<cfset a_cmp_users = application.components.cmp_user />
<cfset q_select_sso_settings = application.components.cmp_security.LoadSwitchUsersData(userkey = request.stSecurityContext.myuserkey) />

<cfset tmp = SetHeaderTopInfoString('Single Sign On')>

Currently, the followings bindings are defined:
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
			#GetLangVal('cm_wd_created')#
		</td>
		<td>
			#GetLangVal('cm_wd_action')#
		</td>
		</cfoutput>
	</tr>
	<cfloop query="q_select_sso_settings">
		
			<cfoutput>
			<tr>
				<td>
					#a_cmp_users.getusernamebyentrykey(q_select_sso_settings.otheruserkey)#
				</td>
				<td>
					#a_cmp_customers.GetCustomerNameByEntrykey(a_cmp_users.GetCompanyKeyOfuser(q_select_sso_settings.otheruserkey))#
				</td>
				<td>
					#LSDateFormat(q_select_sso_settings.dt_created, request.stUserSettings.default_dateformat)#
				</td>
				<td>
					<a href="javascript:DeleteSSOBinding('#jsstringformat(q_select_sso_settings.entrykey)#', '#jsstringformat(q_select_sso_settings.userkey)#', '#jsstringformat(q_select_sso_settings.otheruserkey)#');"><img src="/images/si/delete.png" align="absmiddle" border="0" alt="#GetLangVal('cm_wd_delete')#" /></a>
				</td>
			</tr>
			</cfoutput>
		
	</cfloop>
</table>

<br /><br />
<b>Create a new binding</b>
<br />
<cfoutput>
<form action="index.cfm?action=CreateSSOBinding" method="post">
	<table class="table_details">
		<tr>
			<td class="field_name">#GetLangVal('cm_wd_username')#</td>
			<td>
				<input  type="text" name="frmusername" value=""/>
			</td>
		</tr>

		<tr>
			<td class="field_name">#GetLangVal('cm_wd_password')#</td>
			<td>
				<input type="password" name="frmpassword" value=""/>
			</td>
		</tr>	
		<tr style="display:none;">
			<td class="field_name">#GetLangVal('cm_wd_comment')#</td>
			<td>
				<input type="text" name="frmcomment" value=""/>
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

<!--- TODO: ADD ACTION DeleteSSOBinding --->

<cfsavecontent variable="a_str_js">
	function DeleteSSOBinding(entrykey, userkey, otheruserkey) {
		var a_simple_modal_dialog = new cSimpleModalDialog();
		a_simple_modal_dialog.type = 'confirmation';
		a_simple_modal_dialog.customcontent = '';
		a_simple_modal_dialog.executeurl = 'index.cfm?action=DeleteSSOBinding&entrykey=' + escape(entrykey) + '&userkey=' + escape(userkey) + '&otheruserkey=' + escape(otheruserkey);
		// show dialog
		a_simple_modal_dialog.ShowDialog();	
		}
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js)>

