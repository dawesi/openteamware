<cfparam name="attributes.query" type="query">

<cfinclude template="/common/scripts/script_utils.cfm">

<cfset q_select_user = attributes.query>

<cfset cmp_get_workgroup_memberships = CreateObject("component", "/components/management/users/cmp_user")>
<cfset cmp_get_workgroup_name = CreateObject("component", "/components/management/workgroups/cmp_workgroup")>


<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td>
	<cfif Len(q_select_user.companykey) GT 0>
		<!--- load company data ... --->
		<cfinvoke component="/components/management/customers/cmp_customer" method="GetCustomerNameByEntrykey" returnvariable="a_str_companyname">
			<cfinvokeargument name="entrykey" value="#q_select_user.companykey#">	  
		</cfinvoke>
	
		<b><img src="http://localhost/images/calendar/img_documents_folder_32x32.png" align="absmiddle">&nbsp;&nbsp;#GetLangVal('adm_ph_datasheet_for')# "#htmleditformat(a_str_companyname)#"</b><br><br>
	</cfif>

	<font size="5"><b>#htmleditformat(q_select_user.surname)#, #htmleditformat(q_select_user.firstname)#</b></font>
	<table border="0" cellspacing="0" cellpadding="4">
	  <tr>
		<td align="right">#GetLangVal('cm_wd_username')#:</td>
		<td><b>#q_select_user.username#</b></td>
	  </tr>
	  <tr>
		<td align="right">#GetLangVal('cm_wd_password')#:</td>
		<td>#q_select_user.pwd#</td>
	  </tr>
	  <cfif isDate(q_select_user.date_subscr)>
	  <tr>
	  	<td align="right">#GetLangVal('cm_wd_created')#:</td>
		<td>#dateformat(q_select_user.date_subscr, 'dd.mm.yyyy')#</td>
	  </tr>
	  </cfif>
	</table>
	 
	</td>
    <td align="right" width="150">
	<cfif q_select_user.bigphotoavaliable IS 1>
			<img src="http://localhost/tools/img/show_big_userphoto.cfm?source=datasheet&entrykey=<cfoutput>#urlencodedformat(q_select_user.entrykey)#</cfoutput>" border="0" align="absmiddle">
	<cfelseif q_select_user.smallphotoavaliable IS 1>
		<img src="http://localhost/tools/img/show_small_userphoto.cfm?source=datasheet&entrykey=<cfoutput>#urlencodedformat(q_select_user.entrykey)#</cfoutput>" border="0" align="absmiddle">
	<cfelse>
		&nbsp;
	</cfif>
	</td>
  </tr>
</table>
<hr size="1" noshade>

<table width="100%" border="0" cellspacing="0" cellpadding="6">
  <tr>
    <td valign="top">

<h4><img src="http://localhost/images/img_email_hand.png" align="absmiddle"> #GetLangVal('prf_ph_email_addresses')#</h4>

<cfinvoke component="/components/email/cmp_accounts" method="GetEmailAccounts" returnvariable="q_select_pop3_data">
	<cfinvokeargument name="userkey" value="#q_select_user.entrykey#">
</cfinvoke>

<cfquery name="q_select_external_addresses" dbtype="query">
SELECT
	*
FROM
	q_select_pop3_data
WHERE
	origin = 1
;	
</cfquery>

<cfquery name="q_select_standard_addresses" dbtype="query">
SELECT
	*
FROM
	q_select_pop3_data
WHERE
	origin = 0
;	
</cfquery>
  
<cfinvoke component="/components/email/cmp_accounts" method="GetAliasAddresses" returnvariable="q_select_alias_addresses">
	<cfinvokeargument name="userkey" value="#q_select_user.entrykey#">
</cfinvoke>
<blockquote>
<table border="0" cellspacing="0" cellpadding="4">
  <cfloop query="q_select_standard_addresses">
  <tr bgcolor="##EEEEEE">
  	<td colspan="2"><b>#q_select_standard_addresses.emailadr#</b> (#GetLangVal('adm_ph_email_address_default')#)</td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('cm_wd_server')#:</td>
    <td>#q_select_standard_addresses.pop3server#</td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('cm_wd_username')#:</td>
    <td>#q_select_standard_addresses.pop3username#</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('cm_wd_password')#:</td>
	<td>#q_select_standard_addresses.pop3password#</td>
  </tr>
  </cfloop>
  <tr>
  	<td colspan="2">
		#GetLangVal('adm_ph_pop3_collector_addresses')#: #q_select_external_addresses.recordcount#
	</td>
  </tr>
  <cfloop query="q_select_external_addresses">
  <tr bgcolor="##EEEEEE">
  	<td colspan="2"><b>#q_select_external_addresses.emailadr#</b></td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('cm_wd_server')#:</td>
    <td>#q_select_external_addresses.pop3server#</td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('cm_wd_username')#:</td>
    <td>#q_select_external_addresses.pop3username#</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('cm_wd_password')#:</td>
	<td>#q_select_external_addresses.pop3password#</td>
  </tr>
  <tr>
  	<td align="right">#htmleditformat(GetLangVal('adm_ph_email_address_delete_on_server'))#:</td>
	<td>
	<cfif q_select_external_addresses.deletemsgonserver IS 1>#GetLangVal('cm_wd_yes')#<cfelse>#GetLangVal('cm_wd_no')#</cfif>
	</td>
  </tr>
  </cfloop>  
  <tr>
  	<td colspan="2">#GetLangVal('adm_ph_alias_addresses')#: #q_select_alias_addresses.recordcount#</td>
  </tr>
  <cfloop query="q_select_alias_addresses">
  <tr>
  	<td align="right">###q_select_alias_addresses.currentrow#</td>
	<td>
	#q_select_alias_addresses.aliasaddress#
	</td>
  </tr>
  </cfloop>
</table>
</blockquote>

	</td>
    <td valign="top">
	<h4><img src="http://localhost/images/admin/img_people.png" align="absmiddle"> #GetLangVal('adm_ph_group_memberships')#</h4>
	
	 <cfset q_select_workgroups = cmp_get_workgroup_memberships.GetWorkgroupMemberships(q_select_user.entrykey)>
	 
	 <blockquote>
	 	<cfif q_select_workgroups.recordcount is 0>
		#GetLangVal('adm_ph_group_memberships_none')#
		</cfif>
	 	<table border="0" cellpadding="4" cellspacing="0">
	   	<cfloop query="q_select_workgroups">
            <tr> 
              <td valign="top" align="right">###q_select_workgroups.currentrow#</td>
              <td valign="top"> 
              #htmleditformat(checkzerostring(cmp_get_workgroup_name.GetWorkgroupNameByEntryKey(q_select_workgroups.workgroupkey)))#
				<br>
				#GetLangVal('adm_wd_roles')#:
				 <cfloop index="a_str_role_key" list="#q_select_workgroups.roles#" delimiters=",">
                  <cfset a_str_rolename = cmp_get_workgroup_name.getrolenamebyentrykey(a_str_role_key)>
                  #a_str_rolename# </cfloop>
				
				<hr size="1" noshade>
				</td>
            </tr>
          </cfloop>
		  </table>
		</blockquote>
	</td>
  </tr>
</table>
</cfoutput>