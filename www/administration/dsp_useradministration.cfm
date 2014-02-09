<!--- //

	Module:		Admintool
	Action:		Useradministration
	Description: 
	
// --->

<cfparam name="url.companykey" type="string" default="">


<cfinclude template="dsp_inc_select_company.cfm">

<cfset useradministrationRequest.companykey = url.companykey>
<cfinclude template="dsp_inc_standard_user_administration.cfm">

