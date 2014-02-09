<!--- Die POP3 Einstellungen darstellung gleich Mails abholen ---->

<!--- should all addresses be checked --->
<cfparam name="url.DoCheckAll" default="0">

<cfinclude template="queries/q_select_external_emailaccounts.cfm">



<cfif IsDefined("form.frmid")>

	<!--- check now these accounts --->

	Die ausgew&auml;hlten Konten werden nun auf neue Nachrichten &uuml;berpr&uuml;ft ...<br />

	Bitte werfen Sie in wenigen Minuten einen Blick in den <a href="default.cfm?action=ShowMailbox&Mailbox=INBOX">Posteingang</a> bzw<br />

	in das <a href="default.cfm?action=logbookexternalaccounts">&Uuml;berpr&uuml;fungs-Logbuch</a>!

	<br /><br />

	

	<!--- check if autocheck is enabled ... if yes, update NEXTFETCH to now

		otherwise create a temporary entry --->		

	<cfloop index="a_str_id" list="#form.frmid#" delimiters=",">

		

		<cfquery name="q_select_autocheck_enabled" dbtype="query">

		SELECT

			COUNT(id) AS count_id

		FROM

			q_select_external_emailaccounts

		WHERE

			(accountid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_str_id#">)

		;

		</cfquery>

		

		<cfquery name="q_select_email_properties" dbtype="query">

		SELECT

			*

		FROM

			q_select_all_pop3_data

		WHERE

			(id = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_str_id#">)

		;

		</cfquery>

			

		<cfif q_select_autocheck_enabled.count_id is 1>

			<!--- yes ... just set nextfetch to now ... --->

			<cfset UpdateCheckNowRequest.id = a_str_id>

			<cfinclude template="queries/q_update_check_now.cfm">

		<cfelse>

			<!--- insert into email accounts AND auto-delete ... --->

			<cfset InsertCheckAndDelete.id = a_str_id>

			<cfset InsertCheckAndDelete.query = q_select_email_properties>

			<cfinclude template="queries/q_insert_check_and_delete.cfm">

		</cfif>

	

	</cfloop>

	 



</cfif>



<cfquery name="q_select_all_pop3_data" dbtype="query">

SELECT

	*

FROM

	q_select_all_pop3_data

WHERE

	origin = 1

;

</cfquery>



<table border="0" cellspacing="0" cellpadding="4">

  <form action="default.cfm?action=Pop3Check" method="POST">

  <tr class="mischeader">

    <td class="bb">&nbsp;</td>

    <td class="bb"><b>E-Mail Adresse</b></td>

    <td class="bb">Server</td>

	<td class="bb">Automatische &Uuml;berpr&uuml;fung</td>

  </tr>

  <cfoutput query="q_select_all_pop3_data">

  <tr>

    <td><input checked type="checkbox" name="frmid" value="#q_select_all_pop3_data.id#" class="noborder"></td>

    <td>

	<img src="/images/icon/letter_yellow.gif" width="12" height="12" hspace="4" vspace="4" border="0" align="absmiddle">#htmleditformat(q_select_all_pop3_data.emailadr)#

	</td>

    <td>

	#q_select_all_pop3_data.pop3server#

	</td>

	<td>

	<cfif val(q_select_all_pop3_data.autocheckminutes) gt 0>

	alle #q_select_all_pop3_data.autocheckminutes# Minuten

	

		  <cfquery name="q_select_lastcheck" dbtype="query">

		  SELECT

		  	nextfetch,minterval

		  FROM

		  	q_select_external_emailaccounts

		  WHERE

		  	(accountid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(q_select_all_pop3_data.id)#">)

		  ;

		  </cfquery>

		  

		  <cfif q_select_lastcheck.recordcount is 1>

		  	<!--- display last check ... --->			

			<cfset a_dt_nextcheck = q_select_lastcheck.nextfetch>

			<cfset a_dt_nextcheck = DateAdd("n", -#val(q_select_lastcheck.minterval)#, a_dt_nextcheck)>			  

			<br />

			zuletzt #LsDateFormat(a_dt_nextcheck, "ddd, dd.mm.yy")# #TimeFormat(a_dt_nextcheck, "HH:mm")#

		  </cfif>

	

	<cfelse>

	nie

	</cfif>

	</td>

  </tr>

  </cfoutput>

  <tr>

    <td class="bt" colspan="4">

	<input type="submit" name="frmsubmit" value="Konten jetzt &uuml;berpr&uuml;fen ...">

	</td>

  </tr>

  </form>

</table>



<br /><br />

<a href="default.cfm?action=logbookexternalaccounts" class="simplelink"><b>&Uuml;berpr&uuml;fungs-Logbuch anzeigen</b></a><br />

Ergebnisse der letzten E-Mail Checks anzeigen (z.B. um einen Fehler herauszufinden)

<br />

<br />

<a href="../settings/default.cfm?action=emailaccounts" class="simplelink"><b>Einstellungen anzeigen</b></a><br />

Neue E-Mail Adressen einbinden und Daten (z.B. Zugangsdaten) editeren.

<cfexit method="exittemplate">



<script type="text/javascript">

	function Add2Pop3Check(id)

		{

		window.open("show_pop3_check.cfm?status=1&id="+id, "pop3check"+id,config="width=320,height=190,scrollbars=yes,resizable=yes,toolbar=no,location=no,status=no,menubar=no,");		

		location.reload();

		}

</script>





<cfif url.DoCheckAll is "1">

	<br /><br />

	<div style="padding:5px;border:#CC0000 solid 2px;width:400px;background-color:#EEEEEE;">

	<b>Hinweis</b>

	<br />

	<br />Die �berpr�fung aller externen Adressen wurde aktiviert.

	<br />

	</div>

</cfif>



<cfif (isdefined("form.frmID2Check")) OR (url.DoCheckAll is "1")>

	<!--- user will adressen checken lassen --->

	

		<!--- hinzuf�gen ... --->

		<cfquery name="q_update" datasource="#request.a_str_db_users#">

		UPDATE

			pop3_data

		SET

			docheck = 1

		WHERE

			(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">)

		<cfif url.DoCheckAll neq 1>

		AND (id IN (0

			<cfloop index="singleid" list="#form.frmID2Check#" delimiters=",">

			,#val(singleid)#

			</cfloop>));

		</cfif>

		</cfquery>



</cfif>



<!--- // select all user-defined (origin = 1) addresses // --->

<cfquery name="q_select" datasource="#request.a_str_db_users#">

SELECT

	*

FROM

	pop3_data

WHERE

	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">)

	AND

	(origin = 1)

;

</cfquery>





<p>Mit dieser Funktion k�nnen Sie andere eMail Adressen einbinden<br />

und die Nachrichten dieser Adresse bequem hier bearbeiten.</p>



<cfif q_select.recordcount gt 0>

<form action="default.cfm?action=Pop3Check" method="POST" enablecab="No">

<table border="0" cellspacing="0" cellpadding="4">

<tr class="spaltenkoepfe">

	<td>&nbsp;</td>

	<td>eMail Adresse</td>

	<td>Server</td>

	<td>Aktion</td>

	<td>Letzte �berpr�fung</td>

	<td>Letzte Antwort</td>

</tr>

<cfoutput query="q_select">

<tr>

	<td valign="middle"><input checked="Yes" class="noborder" type="Checkbox" name="frmID2Check" value="#q_select.id#"></td>

	<td valign="middle">#q_select.emailadr#</td>

	<td valign="middle">#q_select.pop3server#</td>

	<td valign="middle">

	[<a href="javascript:Add2Pop3Check('#q_select.id#');">email checken</a>]

	</td>

	<td valign="middle">

	#lsdateformat(q_select.lastcheck, "ddd, dd.mm.yyyy")# #timeformat(q_select.lastcheck, "HH:mm")#

	

	

	</td>

	<td valign="middle">

	<!---<cfif q_select.docheck is 1>

		<!--- adresse wird gepruft --->

		<b style="color:darkgreen;">wird abgefragt</b>

	<cfelse>

		<!--- inaktiv --->

		<cfif val(q_select.lasterror) neq "0">

		<font color="red"><b>Fehler #q_select.lasterror#</b></font>

		<cfelse>OK</cfif>	

	</cfif>

	

	--->

	<iframe src="pop3checkstatus/iframe_pop3check.cfm?id=#q_select.id#" width="170" marginwidth="0" height="15" marginheight="0" scrolling="no" frameborder="0"></iframe>

	</td>

</tr>

</cfoutput>

<tr>

	<td colspan="6" style="border:silver solid 1px;padding:3px;">

	

	<input type="submit" value="Ausgew�hlte Adressen jetzt pr�fen">

	</td>

</tr>

</table>

</form>

<cfinclude template="../content/static/webmail/#GetLangNo()#pop3checker_errormessages.html">

<cfelse>

<p><b>Derzeit haben Sie leider noch keine externen E-Mail Adressen eingebunden.</b></p>

</cfif>

<br />

<br />

<p><b><a href="../settings/default.cfm?action=emailaccounts">Einstellungen t�tigen, Accounts hinzuf�gen und l�schen</a></p></b>

