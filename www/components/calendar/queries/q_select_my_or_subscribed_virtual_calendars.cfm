<!--- //
	Module:		Calendar
	Description:Selects all virtual calendars of the current user + virtual calendar the users is subscribed in.
// --->

<cfquery name="q_select_my_or_subscribed_virtual_calendars">
<!--- select user's calendars --->
SELECT
	vc.entrykey,
    vc.userkey,
    vc.createdbyuserkey,
    vc.title,
    vc.description,
    vc.companykey,
    vc.public,
    vc.dt_created,
    vc.language,
    vc.colour
FROM virtualcalendars vc
WHERE vc.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">

UNION

<!--- select calendars the user is subsribed into --->
SELECT
	vc.entrykey,
    vc.userkey,
    vc.createdbyuserkey,
    vc.title,
    vc.description,
    vc.companykey,
    vc.public,
    vc.dt_created,
    vc.language,
    vc.colour
FROM virtualcalendars vc
LEFT JOIN virtualcalendarsubscriptions vcs ON vcs.virtualcalendarkey = vc.entrykey 
WHERE
    vcs.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>

