<!--- //

	edit assignments ...

	// --->
	
<cfinclude template="/login/check_logged_in.cfm">

<cfinclude template="/common/scripts/script_utils.cfm">

<!--- entrykey of source object --->
<cfparam name="url.entrykeys" type="string" default="">

<!--- servicekey of source element --->
<cfparam name="url.servicekey" type="string" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	
	<cfinclude template="/common/js/inc_js.cfm">
	<script type="text/javascript" src="/common/js/addressbook.js"></script>
	<script type="text/javascript" src="/common/js/crm_ext.js"></script>
	
	<cfinclude template="../../../render/inc_html_header.cfm">
	<title><cfoutput>#GetLangVal('crm_wd_assignments')#</cfoutput></title>
</head>

<body class="body_popup">


<fieldset class="bg_fieldset">
	<legend>
		<cfoutput>#GetLangVal('crm_wd_assignments')#</cfoutput>
	</legend>
	<div>
	
<cfinvoke component="#application.components.cmp_crmsales#" method="DisplayAssignmentsToContact" returnvariable="a_str_assignments">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkeys" value="#url.entrykeys#">
	<cfinvokeargument name="managemode" value="true">
	<cfinvokeargument name="rights" value="read,write,delete,edit">
</cfinvoke>

<cfoutput>#a_str_assignments#</cfoutput>

	</div>
</fieldset>


<fieldset class="bg_fieldset">
	<legend>
		<cfoutput>#GetLangVal('crm_ph_create_new_assignment')#</cfoutput>
	</legend>
	<div>
<!--- load all users ... --->
<cfset variables.a_cmp_customers = CreateObject('component', '/components/management/customers/cmp_customer')>

<cfinvoke component="#variables.a_cmp_customers#" method="GetAllCompanyUsers" returnvariable="q_select_users">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<br>
<form action="act_new_assignment.cfm" method="post" style="margin:0px; ">
<input type="hidden" name="frmservicekey" value="<cfoutput>#htmleditformat(url.servicekey)#</cfoutput>">
<input type="hidden" name="frmentrykeys" value="<cfoutput>#htmleditformat(url.entrykeys)#</cfoutput>">

<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>:</td>
    <td>
	<select name="frmuserkey">
		<option value=""><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
		<cfoutput query="q_select_users">
			<option value="#q_select_users.entrykey#">#q_select_users.surname#, #q_select_users.firstname# (#q_select_users.username#) #q_select_users.aposition#</option>
		</cfoutput>
	</select>
	</td>
  </tr>
  <tr>
    <td><cfoutput>#GetLangVal('adm_wd_comment')#</cfoutput></td>
    <td>
		<input type="text" name="frmcomment" value="" size="25">
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input class="btn" type="submit" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
	</td>
  </tr>
</table>


</form>
</div>
</fieldset>
</body>
</html>
	