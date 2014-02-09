
<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfif request.stSecurityContext.q_select_workgroup_permissions.recordcount IS 0>
	<b><cfoutput>#GetLangVal('cm_ph_alert_no_workgroup_member_at_all')#</cfoutput></b>
	<cfabort>
</cfif>

<cfinclude template="/common/scripts/script_utils.cfm">

<!--- entrykey of object ... --->
<cfparam name="url.entrykey" type="string" default="">

<cfif Len(url.entrykey) IS 0>
	<cfabort>
</cfif>

<!--- the action ... --->
<cfparam name="url.action" type="string" default="ShowOverview">

<!--- title of entry ... ---->
<cfparam name="url.objectname" type="string" default="">
<!--- entrykey of service ... --->
<cfparam name="url.servicekey" type="string" default="">
<!--- sectionkey ... --->
<cfparam name="url.sectionkey" type="string" default="">

<cfif Len(url.servicekey) IS 0>
	<cfabort>
</cfif>


<!--- optional ... for the real action here ;-) --->
	<cfparam name="url.workgroupkey" type="string" default="">
	<!--- user or role? --->
	<cfparam name="url.entrytarget" type="string" default="user">
	<!--- the userkey ... --->
	<cfparam name="url.userkey" type="string" default="">
	<!--- the rolekey ... --->
	<cfparam name="url.rolekey" type="string" default="">


<!--- load all workgroups where this user has write access ... --->
<cfinvoke component="#application.components.cmp_security#" method="LoadPossibleWorkgroupsForAction" returnvariable="q_select_workgroups">
	<cfinvokeargument name="desiredactions" value="write">
	<cfinvokeargument name="q_workgroup_permissions" value="#request.stSecurityContext.q_select_workgroup_permissions#">
</cfinvoke>

<!--- load the existing permissions ... --->
<cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="servicekey" value="#url.servicekey#">
</cfinvoke>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	<script type="text/javascript" src="/common/js/display.js"></script>
	<title><cfoutput>#GetLangVal('adrb_ph_shares_and_details')#</cfoutput></title>
</head>

<body>
<!---<div class="mischeader contrasttext bb" style="padding:6px;">
<b><cfoutput>#GetLangVal('adrb_ph_shares_and_details')#</cfoutput></b>
</div>--->

<table  cellpadding="6" cellspacing="0" border="0" width="100%" class="bb" >
	<tr class="mischeader">
		<td width="100%">
		
		<cfoutput>#GetLangVal('cm_wd_subject')#</cfoutput>: <b><cfoutput>#htmleditformat(checkzerostring(url.objectname))#</cfoutput></b>&nbsp;
		<!---
		(	
		<cfswitch expression="#url.servicekey#">
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
			<cfoutput>#GetLangVal('cm_wd_addressbook')#</cfoutput>
			</cfcase>
			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
			Aufgabenverwaltung
			</cfcase>
			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
			Terminverwaltung
			</cfcase>
			<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
			Dateiablage
			</cfcase>
			<cfcase value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
			E-Mail
			</cfcase>
			<cfcase value="5084CF0A-0DAE-09E6-3C5171B204B4B26E">
			Eigene Datenbanken
			</cfcase>
		</cfswitch>
		)--->
		</td>
		<!---<td width="50%">
			
		</td>--->
	</tr>
</table>
<br>
<div style="padding:4px;">
<table width="98%" border="0" cellspacing="0" cellpadding="4">
<tr>
	<td class="bb" style="padding:0px;padding-left:10px;">
	
	<table border="0" cellspacing="0" cellpadding="4" class="bt br bl">
	<tr>
		<td width="50%" class="mischeader br">
			<cfoutput>#GetLangVal('cm_wd_workgroups')#</cfoutput>
		</td>
		<td width="50%" class="addinfotext">
			<cfoutput>#GetLangVal('cm_ph_workgroups_specials_permissions')#</cfoutput>
		</td>
	</tr>
	</table>

	</td>
</tr>


<!---<tr>
	<td align="right" class="br bl">
	<input type="Button" name="frmbtnsave" value="Speichern">
	</td>
</tr>--->
<form action="save_permissions.cfm" method="post">
<input type="hidden" name="frmservicekey" value="<cfoutput>#url.servicekey#</cfoutput>">
<input type="hidden" name="frmsectionkey" value="<cfoutput>#url.sectionkey#</cfoutput>">
<input type="hidden" name="frmentrykey" value="<cfoutput>#url.entrykey#</cfoutput>">
<tr>
	<td class="br bl bb">
	<cfswitch expression="#url.action#">
		<cfcase value="ShowOverview">
		<cfinclude template="dsp_overview.cfm">
		</cfcase>
		
		<cfcase value="addworkgroup">
		<!--- add a workgroup ... --->
		<cfinclude template="dsp_add_workgroup.cfm">
		
		</cfcase>
	
	</cfswitch>
	
	<!--- content ... --->
	
	
	

	
	</td>
</tr>
</form>
<!--- check if we already have current permissions ... if we create a new item this is not possible ... therefore hide this part --->
<!---
<tr>
	<td class="bl br bt"><b>Aktuelle Berechtigungen</b></td>
</tr>
<tr>
	<td class="bl br bb">
	keine definiert/privater Eintrag
	</td>
</tr>
--->
</table>



</div>	
<!---<cfdump var="#q_select_workgroups#">--->
</body>
</html>
