<cfcontent type="text/html; charset=iso-8859-1">

<!--- ... create the session --->
<cfparam name="url.program_id" type="string" default="">
<cfparam name="url.cfid" type="string" default="">
<cfparam name="url.cftoken" type="string" default="">
<cfparam name="form.entrykeys" type="string" default="">

<cfset start = GetTickCount()>
<!---<cflog text="start #cgi.REMOTE_ADDR#" type="Information" log="Application" file="ib_olsync_re">--->
<!--- select the userkey --->

<cfif NOT StructKeyExists(session, 'stSecurityContext')>
	
	<cfquery name="q_select_session" datasource="#request.a_str_db_tools#">
	SELECT
		userkey
	FROM
		install_names
	WHERE
		program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.program_id#">
		AND
		sessionkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.cfid##url.cftoken#">
	;
	</cfquery>
	
	<cfif (q_select_session.recordcount IS 1) AND (Len(q_select_session.userkey) GT 0)>
		<cfset a_bol_logged_in = true>
		
		<!--- create the session ... --->
			<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
				<cfinvokeargument name="userkey" value="#q_select_session.userkey#">
			</cfinvoke>
			
			<cfset session.stSecurityContext = stReturn>
			
			<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
				<cfinvokeargument name="userkey" value="#q_select_session.userkey#">
			</cfinvoke>
			
			<cfset session.stUserSettings = a_struct_settings>
	<cfelse>
		<cfset a_bol_logged_in = false>
	</cfif>
		
<cfelse>
	<cfset a_bol_logged_in = true>
</cfif>

<cfif NOT a_bol_logged_in>
	<script type="text/javascript">
	window.location.href = 'mrclosenow';
	</script>
	<cfabort>
</cfif>

<cfif cgi.REQUEST_METHOD neq 'post'>
	<script type="text/javascript">
	window.location.href = 'mrclosenow';
	</script>
	<cfabort>
</cfif>

<cfif Len(form.entrykeys) IS 0>
	<script type="text/javascript">
	window.location.href = 'mrclosenow';
	</script>
	<cfabort>
</cfif>

<html>
<head>
<title>Untitled Document</title>
	<style>
		body{border:none;}
		td,p,a,input{font-family:Tahoma;font-size:11px;}
		.bb{border-bottom:silver dashed 1px;}
	</style>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="white" style="padding:0px;" marginheight="0" marginwidth="0" leftmargin="0" topmargin="0" bottommargin="0" rightmargin="0">

<!---<cflog text="getting all contacts #(GetTickCount() - start)#" type="Information" log="Application" file="ib_olsync_re">--->

<cfset a_str_program_id = form.program_id>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#session.stUserSettings#">
	<cfinvokeargument name="filter" value="#StructNew()#">
	<cfinvokeargument name="loadfulldata" value="true">
</cfinvoke>

<!---<cflog text="contacts loaded #(GetTickCount() - start)#" type="Information" log="Application" file="ib_olsync_re">--->

<cfset q_select_contacts = stReturn.q_select_contacts>

<!--- load now outlook meta data ... --->
<cfquery name="q_select_ol_meta_data" datasource="#request.a_str_db_tools#">
SELECT
	outlook_id,addressbookkey
FROM
	addressbook_outlook_data
WHERE
	(program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_program_id#">)
	AND
	(outlook_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entrykeys#" list="yes">))
;
</cfquery>

<!---<cflog text="select meta data #(GetTickCount() - start)#" type="Information" log="Application" file="ib_olsync_re">--->

<!--- ok, now map outlook_id and the real table ... --->

<cfset a_struct_ol_data = StructNew()>
<cfloop query="q_select_ol_meta_data">
	<cfset a_struct_ol_data[q_select_ol_meta_data.addressbookkey] = q_select_ol_meta_data.outlook_id>
</cfloop>

<!---<cflog text="meta data structure created #(GetTickCount() - start)#" type="Information" log="Application" file="ib_olsync_re">--->


<!--- add the column ... --->
<cfset QueryAddColumn(q_select_contacts, 'outlook_id', ArrayNew(1))>

<cfloop query="q_select_contacts">
	<cfif StructKeyExists(a_struct_ol_data, q_select_contacts.entrykey)>
		<cfset QuerySetCell(q_select_contacts, 'outlook_id', a_struct_ol_data[q_select_contacts.entrykey], q_select_contacts.currentrow)>
	<cfelse>
		<cfset QuerySetCell(q_select_contacts, 'outlook_id', 'unknown', q_select_contacts.currentrow)>
	</cfif>
</cfloop>

<!---<cflog text="setting meta data done #(GetTickCount() - start)#" type="Information" log="Application" file="ib_olsync_re">--->
	
<!---<cflog text="selecting contacts ... #(GetTickCount() - start)#" type="Information" log="Application" file="ib_olsync_re">--->

<cfquery name="q_select_contacts" dbtype="query">
SELECT
	firstname,surname,company,email_prim,entrykey
FROM
	q_select_contacts
WHERE
	outlook_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entrykeys#" list="yes">)
;
</cfquery>

<!---<cflog text="q_select_contacts done ... #(GetTickCount() - start)#" type="Information" log="Application" file="ib_olsync_re">--->


<!---<div align="right" style="padding:4px;border-bottom:silver solid 1px;background-color:white;">
	<img src="http://www.openTeamWare.com/images/img_inboxcc_logo_top.png">
</div>--->

<div align="right" style="padding:4px;">
	
</div>

<table width="100%" border="0" cellspacing="0" cellpadding="4">
<form action="action.cfm?<cfoutput>cfid=#client.CFID#&cftoken=#client.CFToken#</cfoutput>" method="post">
  <tr>
    <td valign="top">
		<img src="http://www.openTeamWare.com/images/addressbook/addressbook_remote_edit.png">
	</td>
    <td valign="top">
	
	Die <b>RemoteEdit</b> Funktionen bietet Ihren Kontakten die Moeglichkeit <b>ihre Daten selbst zu vervollstaendigen oder korrigieren</b>.
	<br><br>
	Zu diesem Zweck erhaelt der Kontakt eine kurze Verstaendigung, dass Sie ihn bitten einen kurzen Blick auf seine/ihre Daten bei Ihnen zu werfen und gegebenfalls Aenderungen vorzunehmen.
	<br><br>
	Sie werden dann via E-Mail benachrichtigt sobald ein Kontakt seine Daten aktualisiert hat.
	
<table border="0" cellspacing="0" cellpadding="4" width="100%">

	<tr>
		<td>
			<input type="button" onClick="cancelre();" value="Abbrechen">
		</td>
		<td colspan="2" align="right">
			<input type="submit" name="frmsubmit" style="padding:2px;" value="Aktion fuer die ausgewaehlten Eintrage aktivieren">
		</td>
	</tr>
	<tr>
		<td colspan="3">
		<!---<input type="checkbox" name="frmcbcheckall" value=""> Alle auswaehlen--->
		&nbsp;
		</td>
	</tr>
  <cfoutput query="q_select_contacts">
  
  <cfif Len(q_select_contacts.email_prim) GT 0>
  <tr>
    <td class="bb">
		<input type="checkbox" name="frmcb" value="#q_select_contacts.entrykey#" checked>
	</td>
    <td class="bb">
		<b>#q_select_contacts.surname#, #q_select_contacts.firstname#</b> &lt;#q_select_contacts.email_prim#&gt;
	</td>
    <td class="bb">
		#q_select_contacts.company#
	</td>
  </tr>
  </cfif>
  
  </cfoutput>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</td>
  </tr>
  </form>
</table>

<script type="text/javascript">
	function cancelre()
		{
		window.location.href = 'mrcancel';
		}
</script>

</body>
</html>
