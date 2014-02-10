<cfset sEntrykey_of_sig = ''>

<cfif Len(arguments.email_adr) GT 0>
	<!--- we're looking for the signature of a certain 
		email address ... so check if a signature for this
		address exists --->
	
	<cfquery name="q_select_signature_count_for_certain_address" datasource="#request.a_str_db_tools#">
	SELECT
		entrykey
	FROM
		email_signatures
	WHERE
		userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
		AND
		(UPPER(email_adr) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(arguments.email_adr)#%">)
				
		<cfif arguments.format GT -1>
			AND
			sig_type = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.format#">
		</cfif>
	ORDER BY
		default_sig DESC
	;
	</cfquery>
	
	<cfif q_select_signature_count_for_certain_address.recordcount IS 1>
		<cfset sEntrykey_of_sig = q_select_signature_count_for_certain_address.entrykey>
	</cfif>
	
	<!---
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="q_select_signature_count_for_certain_address" type="html">
	<cfdump var="#q_select_signature_count_for_certain_address#">
	<cfdump var="#arguments#">
	</cfmail>
	--->
	
</cfif>


<cfquery name="q_select_signatures" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,userkey,email_adr,sig_type,sig_data,dt_created,title,default_sig
FROM
	email_signatures
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	
	<!--- do we have to select a signature specified above? --->
	<cfif Len(sEntrykey_of_sig) GT 0>
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey_of_sig#">
	<cfelse>
	
		<!--- use the simple way --->
		<cfif arguments.format GT -1>
		AND
		sig_type = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.format#">
		</cfif>
		
		<!--- a certain email address given? --->
		<cfif Len(arguments.email_adr) GT 0>
		AND
			(
				(UPPER(email_adr) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(arguments.email_adr)#%">)
				OR
				(email_adr = '')
			)
		</cfif>
	</cfif>
ORDER BY
	default_sig DESC
;
</cfquery>