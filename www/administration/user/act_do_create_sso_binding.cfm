<!--- //

	Module:		Admin
	Action:		Create SSO binding
	
// --->


<!--- main user --->
<cfparam name="form.frmuserkey" type="string">

<!--- other user ... --->
<cfparam name="form.frmotheruserkey" type="string">

<!--- do a security check of the other user belongs somehow to this admin ... --->
<cfset a_bol_otheruser_found = false>

<cfset SelectCompanyUsersRequest.companykey = request.q_company_admin.companykey>
<cfinclude template="../queries/q_select_company_users.cfm">

<cfquery name="q_select_other_user_valid" dbtype="query">
SELECT
	*
FROM
	q_select_company_users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmotheruserkey#">
;
</cfquery>

<cfif q_select_other_user_valid.recordcount IS 1>
	<cfset a_bol_otheruser_found = true>
</cfif>


<cfif StructKeyExists(request, 'q_select_reseller') AND
		(request.q_select_reseller.recordcount GT 0)>
		
		<cfinclude template="../queries/q_select_companies.cfm">
	
		<cfloop query="q_select_companies">
			<cfset SelectCompanyUsersRequest.companykey = q_select_companies.entrykey>
			<cfinclude template="../queries/q_select_company_users.cfm">
			
			<cfquery name="q_select_other_user_valid" dbtype="query">
			SELECT
				*
			FROM
				q_select_company_users
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmotheruserkey#">
			;
			</cfquery>
			
			<cfif q_select_other_user_valid.recordcount IS 1>
				<cfset a_bol_otheruser_found = true>
			</cfif>
			
		</cfloop>
		
</cfif>

<cfif NOT a_bol_otheruser_found>
	<h4>Invalid request. Logged and administrator notified.</h4>
	<cfabort>
</cfif>
						
<cfset q_select_user_data = application.components.cmp_user.GetUserData(userkey = form.frmotheruserkey)>

<cfinvoke component="#application.components.cmp_security#" method="AddSwitchUserRelation" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="otheruserkey" value="#form.frmotheruserkey#">
	<cfinvokeargument name="otherpassword_md5" value="#Hash(q_select_user_data.pwd)#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="comment" value="#form.frmcomment#">
</cfinvoke>

<cflocation addtoken="false" url="#ReturnRedirectURL()#">


