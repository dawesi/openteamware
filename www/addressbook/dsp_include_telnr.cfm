<cfparam name="url.telnr" default="">

<cfinclude template="query_adrb.cfm">
<form action="act_set_telnr.cfm" method="POST" enablecab="No">
<input type="Hidden" name="telnr" value="<cfoutput>#urlencodedformat(url.telnr)#</cfoutput>">
<table cellspacing="1" cellpadding="3" align="center">
<tr>
	<td colspan="2"  style="border-bottom:silver solid 1px;"><b>Telefonnummer:</b>&nbsp;
	<cfoutput><font color="##004080"><b>#url.telnr#</b></font></cfoutput>
	</td>
</tr>
<tr>
	<td colspan="2" style="border-bottom:silver solid 1px;"><br>

	
	<b>Rufnummer einem bestehenden Eintrag zuordnen</b>
	</td>
</tr>
<tr>
	<td colspan="2" align="center">
	
	<table>
	<tr>
		<td align="right">Eintrag:</td>
		<td>
			<select name="adrb">
			<cfoutput query="ADRB">
			<option value="#ADRB.id#">#ADRB.firstname# #ADRB.surname#
			</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td align="right">Typ:</td>
		<td>
		<input type="Radio" name="type"  style="background-color:##EEEEEE;" value="p_mobile" checked="true"> Privatnummer&nbsp;&nbsp;|&nbsp;&nbsp;<input type="Radio" name="type" value="mobile" style="background-color:##EEEEEE;"> Gesch&auml;ftsnummer
		</td>
	</tr>
	<tr>
		<td></td>
		<td><input type="Submit" value="Speichern"></td>
	</tr>
	</table>
	
	</td>
</tr>
<tr>
	<td colspan="2" style="border-bottom:silver solid 1px;">
	<br>

	
	<b>Neuen Eintrag anlegen</b>
	</td>
</tr>
<tr>
	<td colspan="2" align="center"><a href="default.cfm?Action=View&ID=-1&mobile=<cfoutput>#urlencodedformat(url.telnr)#</cfoutput>">Neuen Eintrag mit dieser Rufnummer anlegen</a></td>
</tr>
</table>
</form>