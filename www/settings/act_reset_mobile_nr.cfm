<cfinclude template="/login/check_logged_in.cfm">

<!--- debit four points --->
<cfinvoke component="#application.components.cmp_licence#" method="GetAvailablePoints" returnvariable="a_int_points">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<cfif a_int_points LT 4>
	<h4><cfoutput>#GetLangVal('prf_ph_wireless_not_enough_points')#</cfoutput></h4>
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	<cfabort>
</cfif>

<!--- calculate points and debit --->
<cfinvoke component="#request.a_str_component_licence#" method="DebitPointsAccount" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="points" value="4">
</cfinvoke>

<!--- update status --->
<cfinclude template="queries/q_update_wireless_status.cfm">

<cflocation addtoken="no" url="default.cfm?action=wireless">