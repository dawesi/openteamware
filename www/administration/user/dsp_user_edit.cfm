

<cfinclude template="../dsp_inc_select_company.cfm">

<cfparam name="url.section" type="string" default="">
<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
  <cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfset q_userdata = stReturn.query>

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="../queries/q_select_company_data.cfm">
<br>

<fieldset class="default_fieldset">
	<legend><cfoutput>#GetLangVal('cm_wd_edit')#: #stReturn.query.username#</cfoutput></legend>
<!--- display username ... --->

<cfswitch expression="#url.section#">

	<cfcase value="data">
	<cfinclude template="dsp_edit_data.cfm">
	</cfcase>
	
	<cfcase value="emailaddresses">
	<cfinclude template="dsp_edit_email_addresses.cfm">
	</cfcase>
	
	<cfcase value="workgroups">
	<cfinclude template="dsp_edit_workgroups.cfm">
	</cfcase>
	
	<cfcase value="security">
	<cfinclude template="dsp_edit_security.cfm">
	</cfcase>
	
	<cfcase value="quota">
	<cfinclude template="dsp_edit_quota.cfm">
	</cfcase>
</cfswitch>

</fieldset>