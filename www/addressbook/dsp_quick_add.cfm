

<!--- vom adressbuch her schnell eintr&auml;ge hinzuf&uuml;gen --->

<cfif isdefined("form.frmAddAddressbook") is false>
	<cflocation addtoken="No" url="../email/">
</cfif>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_quickadd')) />


<form action="act_quicksave.cfm" method="POST" enablecab="No">

<table border="0" cellspacing="0" cellpadding="5">

<cfset aindex = 0>



<!--- nun die einzelnen adressen listen --->

<cfloop list="#form.frmAddAddressbook#" index="emailadr" delimiters=",">

<cfset aindex = aindex +1>



<cfoutput>

<input type="Hidden" name="email_#aindex#" value="#emailadr#">

</cfoutput>

<tr>

	<td valign="top" colspan="2" class="bb">

	<input type="Checkbox" name="check_<cfoutput>#aindex#</cfoutput>" value="on" checked="Yes" class="noborder">&nbsp;<b><cfoutput>#GetLangVal("adrb_wd_email_address")#</cfoutput> <cfoutput>#urldecode(emailadr)#</cfoutput></b></td>

</tr>

<tr>

	<td align="right"><cfoutput>#GetLangVal("adrb_wd_firstname")#</cfoutput>:</td>

	<td>

	<input type="Text" name="frmFirstname_<cfoutput>#aindex#</cfoutput>" required="No">

	</td>

</tr>

<tr>

	<td align="right"><cfoutput>#GetLangVal("adrb_wd_surname")#</cfoutput>:</td>

	<td>

	<input type="Text" name="frmSurname_<cfoutput>#aindex#</cfoutput>" required="No">

	</td>

</tr>

<tr>

	<td align="right"><cfoutput>#GetLangVal("adrb_wd_company")#</cfoutput>:</td>

	<td>

	<input type="Text" name="frmCompany_<cfoutput>#aindex#</cfoutput>" required="No">

	</td>

</tr>

<tr>

	<td align="right">

	<input class="noborder" checked type="checkbox" name="frmRemoteEdit_<cfoutput>#aindex#</cfoutput>">

	</td>

	<td>

	<cfoutput>#GetLangVal('adrb_ph_quickadd_enable_remotedit')#</cfoutput> [ <a href="/help/index.cfm?action=faq&id=46" target="_blank">FAQt</a> ]

	</td>

</tr>

</cfloop>

<tr class="mischeader">

	<td>&nbsp;</td>

	<td><input type="submit" value="<cfoutput>#GetLangVal("cm_wd_save")#</cfoutput>" name="frmSubmit"></td>

</tr>

</table>

</form>

