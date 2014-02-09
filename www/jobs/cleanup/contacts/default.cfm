<!---

	clean up address book

--->

<!--- 

SELECT COUNT(addressbook.id) FROM addressbook  LEFT JOIN myusers.users AS users ON (addressbook.userkey = users.entrykey) WHERE  users.username IS NULL ORDER BY dt_created LIMIT 1000;

--->

<!--- <cfquery name="q_select_invalid_entrykeys" datasource="mysqladdressbook" maxrows="1000">
SELECT firstname,surname,entrykey,userkey,id from addressbook WHERE length(entrykey) < 35;
</cfquery>

<cfoutput query="q_select_invalid_entrykeys">
#htmleditformat( q_select_invalid_entrykeys.surname )#<br />

<cfset sEntrykey = CreateUUID() />

<cfquery name="q_update" datasource="mysqladdressbook">
UPDATE
	addressbook
SET
	p_fax = entrykey,
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_invalid_entrykeys.id#">
LIMIT
	1
;
</cfquery>

</cfoutput> --->