<cfquery name="q_select_open_dunningletters">
SELECT
	invoicenumber,entrykey,dt_created,dunninglevel
FROM
	invoices
WHERE
	<!--- the company --->
	(companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">)
	AND
	<!--- not paid --->
	(paid = 0)
	AND
	<!--- not cancelled --->
	(cancelled = 0)
	AND
	<!--- reminder sent --->
	<cfif arguments.dunningminlevel IS -1>
	(dunninglevel > 0)
	<cfelse>
	(dunninglevel >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dunningminlevel#">)
	</cfif>
;
</cfquery>