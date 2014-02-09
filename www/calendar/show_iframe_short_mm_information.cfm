<!---

	display meeting member information
	
	--->
	
<cfparam name="url.eventkey" type="string" default="">
<cfparam name="url.meetingmemberkey" type="string" default="">
<cfparam name="url.type" type="numeric" default="0">

<cfinclude template="../login/check_logged_in.cfm">


<html>
<head>
	<cfinclude template="../style_sheet.cfm">
	<title>Meeting Member Information</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" marginwidth="0" marginheight="0" style="padding:0px;">

<!--- load data ... --->

<cfif url.type is 0>

<!--- TODO: check security ... --->

<cfquery name="q_select" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	meetingmembers
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.eventkey#">
AND
	parameter  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.meetingmemberkey#">
;
</cfquery>

<cfif q_select.count_id IS 1>
		
		<!--- display photo ... --->
		<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_userdata">
			<cfinvokeargument name="entrykey" value="#url.meetingmemberkey#">
		</cfinvoke>
		
		<table border="0" cellspacing="0" cellpadding="6">
		  <tr>
			<td valign="top">
			<cfif a_struct_load_userdata.query.smallphotoavaliable IS 1>				
				<img height="60" src="../tools/img/show_small_userphoto.cfm?entrykey=<cfoutput>#urlencodedformat(url.meetingmemberkey)#</cfoutput>" border="0" align="absmiddle">
			<cfelse>	
				<cfoutput>#si_img('user')#</cfoutput>&nbsp;						
			</cfif>
			</td>
			<td valign="top">
			<b><cfoutput>#GetLangVal('cal_wd_participants')#</cfoutput></b><br>
			<cfoutput query="a_struct_load_userdata.query">
			#a_struct_load_userdata.query.firstname# #a_struct_load_userdata.query.surname#
			<br>
			#a_struct_load_userdata.query.username#
			</cfoutput>
			
			</td>
		  </tr>
		</table>

		
		
</cfif>

</cfif>

</body>
</html>
