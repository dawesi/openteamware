<!--- //

	create a new reseller user
	
	// --->
	
<cfparam name="url.userkey" type="string" default="">

<!--- for which resellers is this company responsible? --->

<cfquery name="q_select_companykey">
SELECT
	companykey,username
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.userkey#">
;
</cfquery>

<cfoutput><h4>#q_select_companykey.username#</h4></cfoutput>


<cfquery name="q_select_reseller">
SELECT
	companyname,entrykey,description
FROM
	reseller
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companykey.companykey#">
;
</cfquery>


<cfinclude template="dsp_inc_create_edit_reseller_user.cfm">