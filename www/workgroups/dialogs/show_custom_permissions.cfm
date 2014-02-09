<!--- 

	let the user set or edit special permissions for an object/section
	
	1) check if user is logged in
	
	2) check if the security rule exists or not ... if not, it is just a temporary entry
	   that will receive the real rule after posting the entry
	   than the new entrykey is fix
	   
	   --->

<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.workgroupkey" type="string" default="">
<!--- user or role? --->
<cfparam name="url.entrytarget" type="string" default="user">
<!--- title of entry ... ---->
<cfparam name="url.objectname" type="string" default="">
<!--- entrykey of session ... --->
<cfparam name="url.servicekey" type="string" default="">
<!--- the userkey ... --->
<cfparam name="url.userkey" type="string" default="">
<!--- the rolekey ... --->
<cfparam name="url.rolekey" type="string" default="">

<cfinclude template="/common/scripts/script_utils.cfm">

<cfif len(url.servicekey) is 0>
	<cfabort>
<cfelse>

	<cfinvoke component="#application.components.cmp_security#" method="LoadAvaliableActionsofService" returnvariable="q_select_avaliable_service_actions">
		<cfinvokeargument name="entrykey" value="#url.servicekey#">
	</cfinvoke>

</cfif>
	   
<cfif NOT CheckSimpleLoggedIn()>
	<cfabort>
</cfif>



<html>
<head>
	<cfinclude template="../../style_sheet.cfm">
	<title><cfoutput>#htmleditformat(GetLangVal("sec_ph_set_permissions"))#</cfoutput></title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>


<table width="100%" border="0" cellspacing="0" cellpadding="8">
<form action="act_save_permission.cfm" method="post">
<input type="hidden" name="frmentrytarget" value="<cfoutput>#url.entrytarget#</cfoutput>">

  <tr class="mischeader">
    <td  class="contrasttext">&nbsp;<b><cfoutput>#htmleditformat(GetLangVal("sec_ph_set_permissions"))#</cfoutput></b> (Objekt: <cfoutput>#htmleditformat(url.objectname)#</cfoutput>)</td>
  </tr>
  <tr>
  	<td>Arbeitsgruppe:<br>
	Object:</td>
  </tr>
  
  <cfif len(url.workgroupkey) is 0>
  	<!--- user has to select the workgroup for which he wants to set the permissions ... --->
	<tr>
		<td>
		SELECT WORKGROUP
		</td>
	</tr>	
	<cfexit method="exittemplate">
  <cfelse>
  	<!--- check if user is members of this workgroup ... --->
	
	<!--- has the user got the right to edit permissions? --->
  
  	<!--- load workgroup members ... --->
	
	<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupMembers" returnvariable="q_select_members">
		<cfinvokeargument name="workgroupkey" value="#url.workgroupkey#">
	</cfinvoke>
	
  </cfif>
  
  <tr>
    <td>
	<b><img src="/images/icon/icon_star.gif" width="12" height="12" vspace="3" hspace="2" align="absmiddle"> Neue Berechtigung setzen f&uuml;r ...</b>
	</td>
  </tr>
  <tr>
  	<td>
	
	<table border="0" cellspacing="0" cellpadding="4" class="b_all">
	  <tr>
	  	<cfif url.entrytarget is "user">
		<td class="mischeader br">einen Benutzer</td>
		<td><a href="#">eine Rolle</a></td>
		<cfelse>
		<td class="mischeader br">einen Benutzer</td>
		<td>eine Rolle</td>		
		</cfif>
	  </tr>
	</table>

	
	</td>
  </tr>
  
  <!--- start set user ... --->
  
  <cfif q_select_members.recordcount is 0>
	  <tr>
		<td>
		<b>Diese Gruppe hat keine weiteren Mitglieder</b>
		</td>
	  </tr>
	  <cfexit method="exittemplate">
  </cfif>
  <tr>
  	<td>
	
	
	<table border="0" cellspacing="0" cellpadding="4">
	  <tr>
		<td align="right">Betroffene(r):</td>
		<td>
			<select name="" onChange="LoadStandardPermissionsForUser(this.value);">
				<option value="Benutzer">bitte Benutzer ausw&auml;hlen</option>
				<cfoutput query="q_select_members">
				<option #writeselectedelement(q_select_members.userkey, url.userkey)# value="#htmleditformat(q_select_members.userkey)#">#htmleditformat(q_select_members.fullname)# (#htmleditformat(q_select_members.username)#)</option>
				</cfoutput>
			</select>
			
			<cfset a_str_location = RemoveURLParameter(cgi.QUERY_STRING, "userkey", "")>
			
			<script type="text/javascript">
				function LoadStandardPermissionsForUser(userkey)
					{
					// load the standard permissions for this userkey ...
					location.href = 'show_custom_permissions.cfm?<cfoutput>#a_str_location#</cfoutput>&userkey='+escape(userkey);
					}
			</script>
			
		</td>
	  </tr>
	  <tr>
		<td align="right" valign="top">
		Rechte:
		</td>
		<td valign="top">
		<!--- get avaliable actions for this service ... --->
		
		<!--- load the security context of the specified user --->
		
		<!--- load the standard permissions and display them ... --->
		
		<cfoutput query="q_select_avaliable_service_actions">
		<!--- translate action name ... !--->
		<input class="noborder" type="checkbox" name="frmcheckpermissions" value="#htmleditformat(q_select_avaliable_service_actions.entrykey)#"> #htmleditformat(q_select_avaliable_service_actions.actionname)#
		<br>
		</cfoutput>
		
		
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="frmSubmit" value="Speichern ..."></td>
	  </tr>
	</table>

	

	

	
	
	<!---&nbsp;
	oder
	&nbsp;
	<select name="">
		<option value="Rolle">Rolle</option>
	</select>
	&nbsp;--->
	
	
	</td>
  </tr>
  <tr>
  	<td class="bt">
	<b>Bestehende Berechtigungen</b><br>
	keine
	<img src="/images/del.gif">
	</td>
  </tr>
</form>
</table>


</body>
</html>
