<!--- //

	update account types corresponding to the actions the user has set
	
	// --->
	

<cfquery name="q_select_trialendaccountaction" datasource="#request.a_str_db_users#">
SELECT
	userkeys,productkey
FROM
	trialendaccountaction
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>

<!--- select groupware --->
<cfquery name="q_select_groupware" dbtype="query">
SELECT
	userkeys
FROM
	q_select_trialendaccountaction
WHERE
	productkey = 'AE79D26D-D86D-E073-B9648D735D84F319'
;
</cfquery>

<cfif Len(q_select_groupware.userkeys) GT 0>
	<cfloop list="#q_select_groupware.userkeys#" delimiters="," index="a_str_userkey">
		<!---<h1>Groupware: <cfoutput>#a_str_userkey#</cfoutput></h1>--->
		
		<cfinvoke component="#request.a_str_component_licence#" method="UpdateUserProductKey" returnvariable="stReturn">
			<cfinvokeargument name="userkey" value="#a_str_userkey#">
			<cfinvokeargument name="companykey" value="#url.companykey#">
			<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
			<cfinvokeargument name="wastrialaccount" value="1">
		</cfinvoke>
		
		<!---<cfdump var="#stReturn#">--->
		
	</cfloop>
</cfif>

<!--- select professional --->
<cfquery name="q_select_professional" dbtype="query">
SELECT
	userkeys
FROM
	q_select_trialendaccountaction
WHERE
	productkey = 'AD4262D0-98D5-D611-4763153818C89190'
;
</cfquery>

<cfif Len(q_select_professional.userkeys) GT 0>
	<cfloop list="#q_select_professional.userkeys#" delimiters="," index="a_str_userkey">
		<!---<h1>professional: <cfoutput>#a_str_userkey#</cfoutput></h1>--->
		
		<cfinvoke component="#request.a_str_component_licence#" method="UpdateUserProductKey" returnvariable="stReturn">
			<cfinvokeargument name="userkey" value="#a_str_userkey#">
			<cfinvokeargument name="companykey" value="#url.companykey#">			
			<cfinvokeargument name="productkey" value="AD4262D0-98D5-D611-4763153818C89190">
			<cfinvokeargument name="wastrialaccount" value="1">
		</cfinvoke>
		
		<!---<cfdump var="#stReturn#">--->
		
	</cfloop>
</cfif>

<!--- select accounts to delete ... --->
<cfquery name="q_select_delete" dbtype="query">
SELECT
	userkeys
FROM
	q_select_trialendaccountaction
WHERE
	productkey = 'delete'
;
</cfquery>

<cfif Len(q_select_delete.userkeys) GT 0>
	<cfloop list="#q_select_delete.userkeys#" delimiters="," index="a_str_userkey">
		<!---<h1>delete: <cfoutput>#a_str_userkey#</cfoutput></h1>--->
		
		<!--- delete this user now ... --->
		<cfinvoke component="#application.components.cmp_user#" method="DeleteUser" returnvariable="a_bol_return">
			<cfinvokeargument name="entrykey" value="#a_str_userkey#">
			<cfinvokeargument name="companykey" value="#url.companykey#">
			<cfinvokeargument name="makebackup" value="true">
			<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
		</cfinvoke>
		
	</cfloop>
</cfif>