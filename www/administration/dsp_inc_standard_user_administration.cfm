<!--- //

	Module:		Admintool
	Action:		Useradministration
	Description: 
	
// --->

<cfparam name="useradministrationRequest.companykey" type="string" default="">

<cfparam name="url.search" type="numeric" default="0">

<cfparam name="url.startrow" type="numeric" default="1">

<cfparam name="url.frmusername" type="string" default="">
<cfparam name="url.frmfirstname" type="string" default="">
<cfparam name="url.frmsurname" type="string" default="">
<!--- //
	user administration interface for the company admin ...
	// --->

<!--- load company information ... --->

<cfset LoadCompanyData.entrykey = useradministrationRequest.companykey>
<cfinclude template="queries/q_select_company_data.cfm">

<h4 style="margin-bottom:7px;"><img src="/images/admin/img_people.png" width="32" height="32" hspace="3" vspace="3" border="0" align="absmiddle"><cfoutput>#GetLangVal('adm_ph_nav_user_administration ')#</cfoutput> <cfoutput>#htmleditformat(q_select_company_data.companyname)#</cfoutput></h4>

<cfset SelectCompanyUsersRequest.companykey = useradministrationRequest.companykey>
<cfinclude template="queries/q_select_company_users.cfm">


<table border="0" cellspacing="0" cellpadding="4">
  <form action="index.cfm" method="get">
    <input type="hidden" name="action" value="newuser">
	<input type="hidden" name="resellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
	<input type="hidden" name="companykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
      <td><input class="btn btn-primary" type="submit" value="<cfoutput>#GetLangVal('adm_ph_add_user_now')#</cfoutput>"></td>
    </tr>
  </form>
</table>
<br>
<cfoutput>#ReplaceNoCase(GetLangVal('adm_ph_accounts_found'), '%RECORDCOUNT%', q_select_company_users.recordcount)#</cfoutput>
<br>
<cfif (q_select_company_users.recordcount gt 50)>
  <!--- // search form ... // --->
  <table border="0" cellspacing="0" cellpadding="4">
    <form action="index.cfm" method="get">
    <input type="hidden" name="action" value="useradministration">
	<input type="hidden" name="search" value="1">
	<input type="hidden" name="resellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">	
	<input type="hidden" name="companykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
    <tr> 
      <td align="right"><cfoutput>#GetLangVal('cm_wd_username')#</cfoutput>:</td>
      <td><input type="text" name="frmusername" size="30" value="<cfoutput>#htmleditformat(url.frmusername)#</cfoutput>"></td>
    </tr>
    <tr> 
      <td align="right"><cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>:</td>
      <td><input type="text" name="frmfirstname" size="30" value="<cfoutput>#htmleditformat(url.frmfirstname)#</cfoutput>"></td>
    </tr>
    <tr> 
      <td align="right"><cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>:</td>
      <td><input type="text" name="frmsurname" size="30" value="<cfoutput>#htmleditformat(url.frmsurname)#</cfoutput>"></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td><input type="submit" name="frmsubmit" value="Search"></td>
    </tr>
  </form>
  </table>
  <br>
</cfif>

<cfquery name="q_select_company_users" dbtype="query">
SELECT
	*
FROM
	q_select_company_users
WHERE
	(1=1)
	<cfif Len(url.frmusername) GT 0>
	AND
	UPPER(username) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.frmusername)#%">
	</cfif>
	
	<cfif Len(url.frmsurname) GT 0>
	AND
	UPPER(surname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.frmsurname)#%">
	</cfif>
	
	<cfif Len(url.frmfirstname) GT 0>
	AND
	UPPER(firstname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.frmfirstname)#%">
	</cfif>		
;
</cfquery>

  <!--- display the corresponding users ... --->
  <cfset cmp_get_workgroup_memberships = application.components.cmp_user>
  <cfset cmp_get_workgroup_name = CreateObject("component", "/components/management/workgroups/cmp_workgroup")>
  
  <cfif q_select_company_users.recordcount GT 100>
  
  	Seite: 
  	<cfloop from="1" to="#q_select_company_users.recordcount#" step="100" index="a_int_index">
  
  	<cfoutput>#a_int_index#</cfoutput>		
	
  	</cfloop>
  </cfif>
  <table class="table table-hover" cellspacing="0">
    <tr class="tbl_overview_header"> 
      <td colspan="2"><cfoutput>#GetLangVal('adrb_wd_surname')#, #GetLangVal('adrb_wd_firstname')#</cfoutput></td>
      <td><cfoutput>#GetLangVal('cm_wd_username')#</cfoutput></td>
      <td><cfoutput>#GetLangVal('adm_ph_group_memberships')#</cfoutput></td>
      <td><cfoutput>#GetLangVal('cm_wd_Action')#</cfoutput></td>
    </tr>
    <cfoutput query="q_select_company_users"> 
      <tr>        
        <td valign="middle" align="center" class="bb">
		
		<cfif q_select_company_users.smallphotoavaliable IS 1>
			<img width="50" src="/tools/img/show_small_userphoto.cfm?entrykey=#urlencodedformat(q_select_company_users.entrykey)#&source=admintool" />
		<cfelse>
			<img src="/images/si/user.png" class="si_img" />
		</cfif>			
		</td>
		<td valign="middle" class="bb">
			<a href="index.cfm?action=userproperties&entrykey=#urlencodedformat(q_select_company_users.entrykey)##WriteURLTags()#"><b>#htmleditformat(q_select_company_users.surname)#</b>, #htmleditformat(q_select_company_users.firstname)#</a>
			<br /> 
			#htmleditformat(q_select_company_users.aposition)#
		</td>
 		<td valign="middle" class="bb">
		<a href="index.cfm?action=userproperties&entrykey=#urlencodedformat(q_select_company_users.entrykey)##WriteURLTags()#">#htmleditformat(q_select_company_users.username)#</a>
		
		<cfif q_select_company_users.allow_login IS -1>
			<font color="red">DEAKTIVIERT</font>
		</cfif> 
		</td>		
        <td valign="middle" class="bb"> 
          <!--- load group memberships ... --->
          <cfset q_select_workgroups = cmp_get_workgroup_memberships.GetWorkgroupMemberships(q_select_company_users.entrykey)>

          <cfloop query="q_select_workgroups">
            <a href="index.cfm?action=workgroupproperties&entrykey=#urlencodedformat(q_select_workgroups.workgroupkey)##WriteURLTags()#">#htmleditformat(cmp_get_workgroup_name.GetWorkgroupNameByEntryKey(q_select_workgroups.workgroupkey))#</a>*<br>
          </cfloop>
		  
		  <cfif q_select_workgroups.recordcount IS 0>&nbsp;</cfif>
		</td>
        <td nowrap valign="middle" class="bb"> <a href="index.cfm?action=userproperties&entrykey=#urlencodedformat(q_select_company_users.entrykey)##WriteURLTags()#"><img src="/images/si/pencil.png" class="si_img" /></a> 
          &nbsp;|&nbsp;
		  
		  <a href="index.cfm?action=user.delete&entrykey=#q_select_company_users.entrykey##WriteURLTags()#"><img src="/images/si/delete.png" class="si_img" /></a>
        </td>
      </tr>
    </cfoutput> 
  </table>
<br>

<table border="0" cellspacing="0" cellpadding="4">
  <form action="index.cfm" method="get">
    <input type="hidden" name="action" value="newuser">
	<input type="hidden" name="resellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
	<input type="hidden" name="companykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
      <td><input class="btn btn-primary" type="submit" value="<cfoutput>#GetLangVal('adm_ph_add_user_now')#</cfoutput>"></td>
    </tr>
  </form>
</table>
<br>
* <cfoutput>#GetLangVal('adm_ph_inherited_membership_possible')#</cfoutput>

