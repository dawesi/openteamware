<!--- sms code anfordern --->
<cfif isdefined("form.frmsmscode")>
<!--- // benutzer hat formular abgeschickt // --->

<!--- pr&uuml;fen --->
<cfquery name="q_Select" datasource="inboxccusers" dbtype="ODBC">
select smscode from users
where userid = #request.stSecurityContext.myuserid#
</cfquery>

<cfif q_select.smscode is form.frmsmscode>
	<!--- // code stimmt &uuml;berein // --->
	<cfquery name="q_Select" datasource="inboxccusers" dbtype="ODBC">
	update users set wirelessstatus = 1
	where userid = #request.stSecurityContext.myuserid#
	</cfquery>

<cfelse>
	<!--- // code stimmt nicht &uuml;berein // --->
	<cf_disp_navigation mytextleft="Fehler">
	<br><br>
	
	Der Code stimmt leider nicht &uuml;berein - bitte pr&uuml;fen Sie nochmals die Zeichenfolge!
</cfif>

<cfelse>
<!--- // code wird erst angefordert // --->

<cf_disp_navigation mytextleft="SMS Code anfordern">

<!--- sms code generieren --->
<cfset acode = "">

<cfloop index="ii" from="1" to="5">
	<cfset jj = randrange(1,9)>
	<cfset acode = acode & "#jj#">
</cfloop>

<cfquery debug name="q_select_status" datasource="inboxccusers" dbtype="ODBC">
update users set smscode = '#acode#',
wirelessstatus = -1
where userid = #request.stSecurityContext.myuserid#
and ((wirelessstatus = 0) or (wirelessstatus is null))
</cfquery>

<!--- status auf angefordert &auml;ndern --->
<cfset aSMS_nr = request.a_struct_personal_properties.mymobiletelnr>

<cfset asms_nr = trim(asms_nr)>
<cfset asms_nr = ReplaceNoCase(asms_nr, ",", "", "ALL")>
<cfset asms_nr = ReplaceNoCase(asms_nr, " ", "", "ALL")>
<cfset asms_nr = ReplaceNoCase(asms_nr, "-", "", "ALL")>
<cfset asms_nr = ReplaceNoCase(asms_nr, "/", "", "ALL")>	
<cfset asms_nr = ReplaceNoCase(asms_nr, "+", "", "ALL")>
<cfset asms_nr = ReplaceNoCase(asms_nr, "00", "", "ONE")>

<cfquery name="q_firstname" datasource="myUsers" dbtype="ODBC">
select firstname from users where userid = #request.stSecurityContext.myuserid#;
</cfquery>

<cfif request.a_struct_personal_properties.mySex is 0><cfset asex = "Frau"><cfelse><cfset asex = "Herr"></cfif>

<cfset AMsg = "Guten Tag #asex# #request.a_struct_personal_properties.mysurname#! Bitte geben Sie den folgenden Best&auml;tigungscode nun auf openTeamWare ein: #ACode#">



<cfhttp url="url=http://195.58.160.168:3006/?1=2&3=#aSMS_nr#&4=#urlencodedformat(AMsg)#&9=23zb5zsuberfu&10=openTeamWare" method="GET" resolveurl="false">
<br>
<br>
Der Code wurde an Ihr Mobiltelefon geschickt und sollte in den n&auml;chsten Minuten eintreffen.<br>
<br>
<br>
Geben Sie den erhaltenen Code dann bitte hier ein:
<form action="index.cfm?action=requestsmscode" method="POST" enablecab="No">
Code: <input type="Text" name="frmsmscode" required="No" size="8" maxlength="8">&nbsp;<input type="Submit" name="frmSubmit" value="Jetzt freischalten">

</form>

</cfif>