<cfparam name="form.frmactivitystatus" type="numeric" default="1">

<cfquery name="q_update_user">
UPDATE
	users
SET
	firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmfirstname#">,
	surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmsurname#">,
	department = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdepartment#">,
	aposition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmposition#">,
	sex = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmsex#">,
	address1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmstreet#">,
	plz = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmzipcode#">,
	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcity#">,
	utcdiff = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmtimeZone#">,
	daylightsavinghours = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmdaylightsavinghours#">,
	mobilenr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmmobilrnr#">,
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmexternalemail#">,
	identificationcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.frm_identification_code)#">,
	defaultlanguage = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmlanguage#">,
	activitystatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmactivitystatus#">
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">)
	AND
	(companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">)
;
</cfquery>

<html>
	<head>
	</head>
	<body onLoad="history.go(-2);">
		Updated.
	</body>
</html>