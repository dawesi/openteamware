<!--- //

	update outlook meta information
	
	scopes: SetOlMetaDataInfo, request
	
	// --->
<cfparam name="SetOlMetaDataInfo.id" default="0" type="numeric">
<cfparam name="SetOlMetaDataInfo.userid" type="numeric" default="0">

<!--- update outlook sync information --->
<cfquery name="q_update_outlook_id">
UPDATE notepad_outlook_id
SET lastupdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetUTCTime(now())#">
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#SetOlMetaDataInfo.userid#">
AND notepad_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SetOlMetaDataInfo.id#">;
</cfquery>

<!--- is this user the owner of this record? --->
<cfquery name="q_select_owner_userid">
SELECT userid FROM notepad
WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SetOlMetaDataInfo.id#">;
</cfquery>

<cfif val(q_select_owner_userid.userid) is request.stSecurityContext.myuserid>
	<!--- update the outlook sync information of all users --->
	<cfquery name="q_update_outlook_id">
	UPDATE notepad_outlook_id
	SET lastupdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetUTCTime(now())#">
	WHERE notepad_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SetOlMetaDataInfo.id#">;
	</cfquery>
</cfif>