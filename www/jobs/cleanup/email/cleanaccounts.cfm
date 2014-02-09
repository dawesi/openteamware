<cfabort>

<cfparam name="url.confirmed" type="boolean" default="false">
<!--- 
<cfsavecontent variable="a_str_accounts">
	
</cfsavecontent>

<cfset a_index = 0 />
<table>
<cfloop list="#a_str_accounts#" delimiters="#Chr(10)#" index="a_str_account">
	<cfset a_index = a_index + 1 />
	<cfset a_str_account = Trim( a_str_account ) &  '@openTeamware.com' />
	
<cfquery name="q_select_account_exists_default" datasource="inboxccusers">
SELECT
	pop3_data.userkey,
	pop3_data.entrykey
FROM
	pop3_data
WHERE
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_account#">
;
</cfquery>

<cfquery name="q_select_account_exists_alias" datasource="inboxccusers">
SELECT
	emailaliases.userkey,
	emailaliases.destinationaddress
FROM
	emailaliases
WHERE
	aliasaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_account#">
;
</cfquery>


<tr>
	<td>
		<cfoutput><h4>#htmleditformat( a_str_account )#</h4></cfoutput>
	</td>
	<td>
		<!--- <cfdump var="#q_select_account_exists_default#">
		<cfdump var="#q_select_account_exists_alias#"> --->
	</td>
	<td>
		<cfif q_select_account_exists_default.recordcount IS 0 AND q_select_account_exists_alias.recordcount IS 0>
			<a href="deleteaccount.cfm?name=<cfoutput>#urlencodedformat( ListFirst( a_str_account, '@' ))#</cfoutput>">Delete account</a>
			
			<cfset a_str_file = '/tmp/deleteaccounts.sh' />
			<cfif FileExists( a_str_file )>
				<cffile action="read" file="#a_str_file#" variable="a_str_content">
			<cfelse>
				<cfset a_str_content = '' />
			</cfif>
			
			<cfset a_str_name = ListFirst( a_str_account, '@' ) />
			
			<cfset a_str_content = Trim( a_str_content & chr(10) & 'echo try to delete "' & a_str_name & '/"' ) />
			<cfset a_str_content = Trim( a_str_content & chr(10) & 'rm "' & a_str_name & '/" -R' ) />
			
			<cffile action="write" file="#a_str_file#" output="#a_str_content#" addnewline="false">

		</cfif>
	</td>
</tr>
	<cfif a_index GT 1000>
		<cfthrow message="getout">
	</cfif>
</cfloop>

</table> --->