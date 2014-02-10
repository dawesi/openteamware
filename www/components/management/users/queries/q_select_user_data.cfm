<!--- //

	Component:	Users
	Function:	Load user data
	Description:Load user data by entrykey
	

// --->

<cfquery name="q_select_user_data" datasource="#request.a_str_db_users#">
SELECT
	city,firstname,title,surname,zipcode,username,email,address1,entrykey,companykey,
	date_subscr,mobilenr,utcdiff,country,userid,allow_login,plz,defaultlanguage,style,
	customheader,sessiontimeout,daylightsavinghours,sex,mobilenr,wirelessstatus,MailboxSizeLimit,
	autologinkey,NotProperlyLoggedOut,smallphotoavaliable,bigphotoavaliable
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>

