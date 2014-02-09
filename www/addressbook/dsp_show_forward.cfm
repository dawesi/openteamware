<!--- //

	Module:		Address Book
	Action:		Forward
	Description:Forward items
	

// --->

<cfparam name="url.entrykeys" type="string" default="">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_actions_forward')) />

<cfif Len(url.entrykeys) IS 0>
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message='Keine Auswahl getroffen.'>
	<cfexit method="exittemplate">
</cfif>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.entrykeys = url.entrykeys />

<!--- load all contacts --->
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts />

<form action="default.cfm?action=DoForwardContacts" method="POST" name="frmForward">
<input type="Hidden" name="frmcheckedentrykey" value="<cfoutput>#htmleditformat(url.entrykeys)#</cfoutput>">

<b>Die folgenden Eintr&auml;ge weiterleiten:<br></b>
<br>

<table class="table_overview">
<tr class="tbl_overview_header">
	<td></td>
	<td>
		<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
	</td>
</tr>
<cfoutput query="q_select_contacts">
<tr>
	<td>###q_select_contacts.currentrow#</td>
	<td>
		#htmleditformat(q_select_contacts.surname)#, #htmleditformat(q_select_contacts.firstname)# <cfif Len(q_select_contacts.company) GT 0>(#q_select_contacts.company#)</cfif>
	</td>
</tr>
</cfoutput>
</table>



<br>
<table border="0" cellspacing="0" cellpadding="4">
<tr>
	<td valign="top" bgcolor="#EEEEEE"><img src="/images/addressbook/adressbook_forward_email.png" hspace="3" vspace="3" border="0" alt=""></td>
	<td valign="top" style="line-height:17px;border-left: dashed silver 1px;"><b>Eintr&auml;ge per E-Mail weiterleiten</b><br>
	In diesem Fall werden Standard-VCards weitergeleitet. Der Empf&auml;nger kann<br>
	die Kontakte dann mit einem Klick in sein Adressbuch importieren.
	<br><br>	
	
	<table border="0" cellspacing="0" cellpadding="3">
	<tr>
		<td align="right">Empf&auml;nger:</td>
		<td>
			<input type="text" name="frmEmailTo" value="" size="40" maxlength="150">

			&nbsp;

		
			<script type="text/javascript">
			function SetEmailAdr(frmAddressbookEmail)
				{
				var EmailAdr = frmAddressbookEmail.options[frmAddressbookEmail.selectedIndex].value;
				document.frmForward.frmEmailTo.value = EmailAdr;
				}
			</script>
		

		<!--- <select name="frmAddressbookEmail" onChange="SetEmailAdr(this)">
			<option value="">- Adressbuch -</option>
			<cfoutput query="q_select_all_contacts">
				<cfif Len(q_select_all_contacts.email_prim) GT 0>
					<option value="#htmleditformat(q_select_all_contacts.email_prim)#">#trim(q_select_all_contacts.firstname&" "&q_select_all_contacts.surname)# (#htmleditformat(shortenstring(q_select_all_contacts.email_prim, 20))#)</option>
				</cfif>
			</cfoutput>
		</select> --->
		</td>
	</tr>
	<tr>
		<td align="right"><font style="color:#CC0000;font-weight:bold;">&#187;</font></td>
		<td colspan="2"><input type="Submit" name="frmSubmitEmail" class="btn" value="E-Mail jetzt verschicken"></td>
	</tr>
	</table>

	</td>
</tr>
<tr>
	<td valign="top" bgcolor="#EEEEEE" style="border-top: dashed silver 1px;"><img src="/images/addressbook/adressbook_forward_email.png" hspace="3" vspace="3" border="0" alt=""></td>
	<td valign="top" style="line-height:17px;border-left: dashed silver 1px;border-top: dashed silver 1px;"><b>Eintr&auml;ge per SMS an ein Handy weiterleiten</b><br>
	Sie k&ouml;nnen diese Kontakte auch an beliebige Mobiltelefone schicken - und<br>
	damit bequem Nummern und Daten mit Arbeitskollegen und Freunden austauschen.<br>
	<br>
	Bestimmte Nokia und Ericsson-Mobiltelefone bieten sogar die M&ouml;glichkeit die Nummer mit<br>
	einem Klick in das Adressbuch zu &uuml;bernehmen.
	<br>
	<br>
	Bitte w&auml;hlen Sie nun den Typ des Empf&auml;nger-Handys aus:
	<br>
	<br>
	<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><input  class="noborder" type="Radio" name="frmMobileType" value="0"></td>
		<td>Ich wei&szlig; es nicht, normale Standard-SMS schicken</td>
	</tr>
	<tr>
		<td><input class="noborder" type="Radio" name="frmMobileType" value="1" checked></td>
		<td>Ericsson/Nokia-Ger&auml;t mit einem Nummernspeicher pro Kontakt, z.B.: 33xx, 30xx, 7110, 8210</td>
	</tr>
	<tr>
		<td><input class="noborder" type="Radio" name="frmMobileType" value="2"></td>
		<td>Ericsson/Nokia-Ger&auml;t mit <i>mehreren</i> Nummernspeichern pro Kontakt, z.B.: Bsp.: 6210, 6310, 9210</td>
	</tr>
	</table>

	<script type="text/javascript">
		function SetMobileNr(frmMobileAddressbook)
			{
			var MobileNr = frmMobileAddressbook.options[frmMobileAddressbook.selectedIndex].value;
			document.frmForward.frmMobileNr.value = MobileNr;
			}
	</script>
	<br>
	<table border="0" cellspacing="0" cellpadding="3">
	<tr>
		<td align="right">Empf&auml;nger-Nummer:</td>
		<td><input type="text" name="frmMobileNr" value="" size="20">
		&nbsp;
		

		

		

		<select name="frmMobileAddressbook" onchange="SetMobileNr(this);">
			<option value="">- Adressbuch -
			<cfoutput><option value="+#request.a_struct_personal_properties.mymobiletelnr#">+#request.a_struct_personal_properties.mymobiletelnr# (ihre eigene Rufnummer)</cfoutput>

			<!--- <cfoutput query="q_select_all_contacts">

			<cfif trim(q_select_all_contacts.b_mobile) neq "">
			<option value="#BeautifyNumber(q_select_all_contacts.b_mobile)#">#q_select_all_contacts.firstname# #q_select_all_contacts.surname# (#BeautifyNumber(q_select_all_contacts.b_mobile)#)
			</cfif>

			<cfif (trim(q_select_all_contacts.p_mobile) neq "") AND (q_select_all_contacts.p_mobile neq q_select_all_contacts.b_mobile)>
			<option value="#BeautifyNumber(q_select_all_contacts.p_mobile)#">#q_select_all_contacts.firstname# #q_select_all_contacts.surname# (#BeautifyNumber(q_select_all_contacts.p_mobile)#)
			</cfif>		

			</cfoutput>--->

		</select>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="2" style="font-size:10px;color:Gray;">Format: +Landesvorwahl Netzvorwahl Rufnummer, also z.B. +49 171 1234567</td>
	</tr>
	<tr>
		<td align="right"><font style="color:#CC0000;font-weight:bold;">&#187;</font></td>
		<td><input type="Submit" name="frmSubmitMobile" class="btn2" value="Kontakte per SMS weiterleiten"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
		<li>Den Tarif pro Kontaktweiterleitung abh&auml;ngig vom Zielnetz finden Sie <a href="/account/default.cfm?action=tarife">hier</a></li>

		<li>Pro Kontakt f&auml;llt eine SMS Nachricht an</li></td>

	</tr>

	</table>


	</td>

</tr>

</table>

</form>

