<!--- //

	Module:		Preferences
	Action:		Password
	Description: 
	

// --->
<cfif IsDefined("form.frmCurrentPassword")>
<cfset SetHeaderTopInfoString(GetLangVal('prf_ph_change_password')) />


<cfif len(trim(form.frmCurrentPassword)) is 0>
	<b><cfoutput>#GetLangVal('prf_ph_pwd_change_enter_current_pwd')#</cfoutput></b><cfabort>
</cfif>

<cfquery name="q_select_pwd">
SELECT
	pwd
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<cfif CompareNoCase(form.frmCurrentPassword, q_select_pwd.pwd) neq 0>
	<b><cfoutput>#GetLangVal('prf_ph_pwd_invalid_pwd')#</cfoutput></b>
	<cfabort>
</cfif> 

<cfif trim(form.frmNewPassword1) is "" or trim(form.frmNewPassword2) is "">
	<b><cfoutput>#GetLangVal('prf_ph_pwd_enter_twice')#</cfoutput></b><cfabort>
</cfif>

<cfif form.frmNewPassword1 neq form.frmNewPassword2>
	<b><cfoutput>#GetLangVal('prf_ph_pwd_do_not_match')#</cfoutput></b><cfabort>
</cfif>

<cfif form.frmNewPassword1 is form.frmCurrentPassword>
	<b><cfoutput>#GetLangVal('prf_ph_pwd_old_new_same')#</cfoutput></b><cfabort>
</cfif>


<!--- in der db &auml;ndern --->
<!---<cfquery name="q_update_pwd" dbtype="ODBC">
update users
set pwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmNewPassword1#">
where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>--->

<cfinvoke component="#application.components.cmp_user#" method="UpdatePassword" returnvariable="a_bol_change_pwd">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
	<cfinvokeargument name="password" value="#form.frmNewPassword1#">
	<cfinvokeargument name="updatepop3password" value="true">
	<cfinvokeargument name="updateimpassword" value="true">
</cfinvoke>

<b><cfoutput>#GetLangVal('prf_ph_pwd_success')#</cfoutput></b>



<cfelse>
<!--- // passwort&auml;nderungsformular anzeigen // --->
<cfset SetHeaderTopInfoString(GetLangVal('prf_ph_change_password')) />
<br><br>
<cfoutput>#GetLangVal('prf_ph_pwd_intro')#</cfoutput>
<br>
<br>
<form action="index.cfm?action=Password" method="POST">
<table class="table table_details table_edit_form">
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('prf_ph_pwd_current_pwd')#</cfoutput>:</td>
	<td><input type="Password" name="frmCurrentPassword" required="Yes" size="25" maxlength="50"></td>
</tr>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('prf_ph_pwd_new_pwd')#</cfoutput>:</td>
	<td><input type="Password" name="frmNewPassword1" required="Yes" size="25" maxlength="50"></td>
</tr>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('cm_wd_confirmation')#</cfoutput>:</td>
	<td><input type="Password" name="frmNewPassword2" required="Yes" size="25" maxlength="50"></td>
</tr>
<tr>
	<td class="field_name"></td>
	<td><input type="Submit" name="frmSubmit" value="<cfoutput>#GetLangVal('prf_ph_pwd_change_now')#</cfoutput>" class="btn btn-primary" /></td>
</tr>
</table>
</form>
</cfif>


