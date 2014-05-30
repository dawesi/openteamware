<cfparam name="url.entrykey" type="string" default="">
<cfparam name="form.frmdeleteaction" type="string" default="ignore">

<cfsetting requesttimeout="20000">

<cfif Len(url.entrykey) IS 0>
	<cfabort>
</cfif>

<cfinclude template="../dsp_inc_select_company.cfm">

<br><br>

<!--- check if entrykey is a user of this company --->

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif StructKeyExists(url, 'confirmed')>

	<cfswitch expression="#form.frmdeleteaction#">
		<cfcase value="export">
			<!--- save export of data in user XY --->
			<cfset a_str_action_for_data_userkey = form.frmuserkey_export>
		</cfcase>
		<cfcase value="move">
			<!--- move data to user XY --->
			<cfset a_str_action_for_data_userkey = form.frmuserkey_move>
		</cfcase>
		<cfdefaultcase>
			<cfset a_str_action_for_data_userkey = ''>
		</cfdefaultcase>
	</cfswitch>
	

<cfinvoke component="#application.components.cmp_user#" method="DeleteUser" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="makebackup" value="true">
	<!--- what to do with data? --->
	<cfinvokeargument name="actionfordata" value="#form.frmdeleteaction#">
	
	<!--- if export or something like that ... which user to use? --->
	<cfinvokeargument name="actionfordata_userkey" value="#a_str_action_for_data_userkey#">
</cfinvoke>



<cfoutput>#GetLangVal('adm_ph_user_has_been_deleted')#</cfoutput>.
<br><br><br>

<br><br><br>
<a href="index.cfm?action=useradministration&<cfoutput>#url.entrykey##writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>

<cfelse>

<cfset a_str_text = GetLangVal('adm_ph_user_delete_are_you_sure')>
<cfset a_str_text = ReplaceNoCase(a_str_text, '%USER%', "<b>#stReturn.query.username# (#stReturn.query.surname#, #stReturn.query.firstname#)</b>")>

<cfoutput>#a_str_text#</cfoutput>
<br><br>

<form  method="post" action="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>&confirmed=true">
<b><cfoutput>#GetLangVal('adm_ph_user_delete_action_for_data')#</cfoutput></b>

<br><br>

<table border="0" cellspacing="0" cellpadding="6">
  <tr>
    <td>
		<input checked type="radio" name="frmdeleteaction" value="ignore" class="noborder">
	</td>
    <td>
		<cfoutput>#GetLangVal('adm_ph_user_delete_action_for_data_ignore')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td>
		<input type="radio" name="frmdeleteaction" value="export" class="noborder">
	</td>
    <td>
		<cfoutput>#GetLangVal('adm_ph_user_delete_action_for_data_export')#</cfoutput>
		
		<!--- select all administrator accounts --->
		<cfset SelectCustomerContacts.entrykey = url.companykey>
		<cfinclude template="../queries/q_select_customer_contacts.cfm">
		
		
		<select name="frmuserkey_export">
		
			<cfoutput query="q_select_customer_contacts">
			  <cfinvoke component="#application.components.cmp_user#" method="Getusernamebyentrykey" returnvariable="a_str_username">
				<cfinvokeargument name="entrykey" value="#q_select_customer_contacts.userkey#">
			  </cfinvoke>
			  <option value="#q_select_customer_contacts.userkey#">#a_str_username#</option>
			 </cfoutput>
		  
		 </select>		
	</td>
  </tr>
  <tr>
    <td>
		<input type="radio" name="frmdeleteaction" value="move" class="noborder">
	</td>
    <td>
		<cfoutput>#GetLangVal('adm_ph_user_delete_action_for_data_move')#</cfoutput>
		
		<!--- select all accounts --->
		<cfset SelectCompanyUsersRequest.companykey = url.companykey>
		<cfinclude template="../queries/q_select_company_users.cfm">
		
		<select name="frmuserkey_move">
			
			<cfoutput query="q_select_company_users">
			
				<cfif q_select_company_users.allow_login IS 1 AND CompareNoCase(q_select_company_users.username, stReturn.query.username) NEQ 0>
					  <cfinvoke component="/components/management/users/cmp_user" method="Getusernamebyentrykey" returnvariable="a_str_username">
						<cfinvokeargument name="entrykey" value="#q_select_company_users.entrykey#">
					  </cfinvoke>
					  <option value="#q_select_company_users.entrykey#">#a_str_username#</option>
				</cfif>
			 </cfoutput>	
			 
		</select>*		
	</td>
  </tr>
  <tr>
  	<td></td>
	<td>
		<input class="btn btn-primary" type="submit" value="<cfoutput>#htmleditformat(GetLangVal('adm_ph_user_delete_sure'))#</cfoutput>">
	</td>
  </tr>
</table>
</form>
<br><br><br>
<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('adm_ph_user_delete_not_sure')#</cfoutput></a>
<br><br><br>
* <cfoutput>#GetLangVal('adm_ph_user_delete_action_hint_move_data')#</cfoutput>.
</cfif>
