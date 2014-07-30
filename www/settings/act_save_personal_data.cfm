<!--- update durchf�hren --->
<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="form.frmSex" type="numeric" default="0">


<!-- checken ob sich die rufnummer ge�ndert hat - dann auf stautus 0 setzen --->
<cfquery name="q_insert">
INSERT INTO users_saved_data
(userid,username,dt,ip,firstname,surname,sex,address1,plz,city)
VALUES
('#request.stSecurityContext.myuserid#', '#request.stSecurityContext.myusername#', current_timestamp, '#cgi.REMOTE_ADDR#','#request.a_struct_personal_properties.myfirstname#','#request.a_struct_personal_properties.mysurname#','#val(request.a_struct_personal_properties.mysex)#','#request.a_struct_personal_properties.mystreet#','#request.a_struct_personal_properties.myplz#','#request.a_struct_personal_properties.mycity#');
</cfquery>

<!--- //

	migrate to cmp_user.UpdateData!! 
	
	
	--->

<!--- update database --->
<cfquery name="q_update">
UPDATE
	users
SET
	account_checked = 0,
	organization = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmorganization#">,
	firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmfirstname#">,
	surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmsurname#">,
	plz = #val(form.frmplz)#,
	zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmplz#">,
	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcity#">,
	country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcountry#">,
	address1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmAddress#">,
	sex = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmSex)#">,
	defaultlanguage = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmDefaultLanguage)#">,
	SubscrNewsletter = <cfif isDefined("form.frmSubScrNewsletter")>1<cfelse>0</cfif>,
	SubscrNewsletterAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmSubscrNewsletterAddress#">,
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmEmail#">
WHERE
	(entrykey= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
;
</cfquery>

<cflock timeout="3" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
	<!--- // set the session vars // --->
	<cfset session.a_struct_personal_properties.myplz = val(form.frmplz)>
	<cfset session.a_struct_personal_properties.myfirstname = form.frmFirstname>
	<cfset session.a_struct_personal_properties.mysurname = form.frmSurname>
	<cfset session.a_struct_personal_properties.mycity = form.frmCity>
	<cfset session.a_struct_personal_properties.mycountry = form.frmCountry>
	<cfset session.a_struct_personal_properties.mystreet = form.frmAddress>
	<cfset session.a_struct_personal_properties.mySex = val(form.frmSex)>
	<cfset session.a_struct_personal_properties.myDefaultLanguage = val(form.frmDefaultLanguage)>
</cflock>

<cfset Client.Langno = request.a_struct_personal_properties.mydefaultlanguage>

<cflocation addtoken="no" url="index.cfm?action=PersonalData&message=#urlencodedformat("Daten wurden upgedatet")#">