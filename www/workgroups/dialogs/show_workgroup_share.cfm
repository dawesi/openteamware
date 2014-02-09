
<!--- entrykey of object ... --->
<cfparam name="url.entrykey" type="string" default="">

<!--- the action ... --->
<cfparam name="url.action" type="string" default="ShowOverview">

<!--- title of entry ... ---->
<cfparam name="url.objectname" type="string" default="">
<!--- entrykey of session ... --->
<cfparam name="url.servicekey" type="string" default="">

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



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<cfinclude template="../../style_sheet.cfm">
	<title>Freigaben &amp; Berechtigungen</title>
</head>

<body>




<table width="100%" border="0" cellspacing="0" cellpadding="8">
<tr>
	<td>
	
	<table border="0" cellspacing="0" cellpadding="4" class="b_all">
	<tr>
		<td width="50%" class="mischeader br">
			Arbeitsgruppenfreigabe
		</td>
		<td width="50%">
			Spezielle Berechtigungen
		</td>
	</tr>
	</table>

	
	
	</td>
</tr>
<tr>
	<td align="right">
	<input type="Button" name="frmbtnsave" value="Speichern">
	</td>
</tr>
<tr>
	<td>
	<cfswitch expression="#url.action#">
		<cfcase value="ShowOverview">
			<cfoutput query="q_select_workgroups">
	<a href="show_workgroup_share.cfm?action=addworkgroup&workgroupkey=#urlencodedformat(q_select_workgroups.workgroup_key)#">Gruppe #q_select_workgroups.workgroup_name# hinzuf&uuml;gen ...</a><br>
	</cfoutput>
		</cfcase>
		
		<cfcase value="addworkgroup">
		<!--- add a workgroup ... --->
		<cfinclude template="dsp_add_"
		
		</cfcase>
	
	</cfswitch>
	
	<!--- content ... --->
	
	
	

	
	</td>
</tr>
</table>



	
<!---<cfdump var="#q_select_workgroups#">--->

</body>
</html>
