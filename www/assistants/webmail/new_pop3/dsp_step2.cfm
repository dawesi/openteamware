<cfset ADisplayName = trim(request.a_struct_personal_properties.myfirstname&' '&request.a_struct_personal_properties.mysurname)>

<cfset ADisplayName = htmleditformat(ADisplayName)>

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_userdata">
	<cfinvokeargument name="entrykey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>


<cfset a_str_email = ''>
<cfif a_struct_userdata.query.email NEQ ''>

	<cfinvoke component="/components/email/cmp_accounts" method="GetEmailAccounts" returnvariable="q_select_accounts">
		<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	</cfinvoke>

	<cfquery name="q_select_external_address" dbtype="query">
	SELECT
		*
	FROM
		q_select_accounts
	WHERE
		UPPER(emailadr) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(a_struct_userdata.query.email)#">
	;
	</cfquery>
	
	<cfif q_select_external_address.recordcount IS 0>
		<!--- not yet included --->
		<cfset a_str_email = a_struct_userdata.query.email>
	</cfif>
</cfif>

<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="4">

<form action="index.cfm?action=step3" method="POST">

<tr>

	<td colspan="2" height="45" style="font-size:15px;font-weight:bold;color:white;" bgcolor="#004080">

	&nbsp;&nbsp;<cfoutput>#GetLangVal('ass_ph_pop3_email_address_data')#</cfoutput>&nbsp;</td>

</tr>

<tr>

	<td colspan="2" bgcolor="#ffffff">



	

		<table border="0" cellspacing="0" cellpadding="6" align="center">

		<tr>

			<td colspan="2" style="line-height:16px;">
			<cfif Len(a_str_email)>
				<cfset a_str_text = GetLangVal('ass_ph_pop3_recommended_first_address')>
				<cfset a_str_text = ReplaceNoCase(a_str_text, '%ADDRESS%', a_str_email)>
				<b>
					<cfoutput>#a_str_text#</cfoutput>
				</b>
				<br><br>
			</cfif>
			
			
			<cfoutput>#GetLangVal('ass_ph_pop3_from_name')#</cfoutput>
			</td>

		</tr>

		<tr>

			<td align="right">
				<cfoutput>#GetLangVal('ass_ph_pop3_displayed_name')#</cfoutput>
			</td>

			<td>
				<input tabindex="1" type="text" name="frmDisplayName" size="25" maxlength="50" value="<cfoutput>#ADisplayName#</cfoutput>">
			</td>

		</tr>

		<tr>

			<td align="right"><cfoutput>#GetLangVal('ass_ph_pop3_email_address')#</cfoutput></td>

			<td><input tabindex="2" type="text" name="frmEmailAdr" size="25" value="<cfoutput>#htmleditformat(a_str_email)#</cfoutput>" maxlength="50"></td>

		</tr>

		</table>



	

	</td>

</tr>



<tr>

	<td align="35" bgcolor="silver" style="border-top:gray solid 1px;">

	<input type="button" value="Abbrechen" onclick="javascript:CancelAssistant();">

	</td>

	<td  height="35" bgcolor="silver" align="right" style="border-top:gray solid 1px;">

	<input type="button" value="zur&uuml;ck" onclick="javascript:history.go(-1);">

	&nbsp;

	<input tabindex="3" type="Submit" style="font-weight:bold;" value="<cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput>">

	

	</td>

</tr>

</form>

</table>