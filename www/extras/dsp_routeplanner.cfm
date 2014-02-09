<!--- //

	Module:		Extras / Route planner
	Description: 
	

// --->

<cfset tmp = SetHeaderTopInfoString( GetLangVal('extras_ph_route_planner') ) />


<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserdata" returnvariable="stReturn">
	<cfinvokeargument name="userid" value="#request.stSecurityContext.myuserid#">
</cfinvoke>

<cfset q_user_data = stReturn.query>

<form action="show_goto_route_planner.cfm" method="get" target="_blank">

<table border="0" cellspacing="0" cellpadding="6" width="450">
  <tr>
  	<td colspan="2">
	
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
	  <tr>
		<td style="line-height:18px;">
		<b><cfoutput>#GetLangVal('extras_ph_route_planner_intro')#</cfoutput></b><br><br>
		<cfoutput>#GetLangVal('extras_ph_route_planner_addressbook')#</cfoutput> (<a href="/addressbook/"><cfoutput>#GetLangVal('extras_ph_route_planner_addressbook_link')#</cfoutput></a>)
		</td>
		<td width="140" class="addinfotext" align="center">
		<img src="../images/status/status2.png" width="128" height="85" hspace="2" vspace="2" border="0">
				<br><br>
		<img src="/images/partner/img_map24.png"><br>
		powered by map24
		</td>
	  </tr>
	</table>
	
	</td>
  </tr>

  
  <tr>
  	<td colspan="2" class="bb mischeader bt" align="center">
	<input type="submit" name="frmsubmit" style="font-weight:bold;" value="<cfoutput>#GetLangVal('extras_ph_route_planner_show_route')#</cfoutput>" class="btn" />
	</td>
  </tr>
  
  <tr>
  	<td width="50%" align="center">
	<b><cfoutput>#GetLangVal('extras_ph_route_planner_from')#</cfoutput>:</b>
	</td>
	<td width="50%" align="center">
	<b>... <cfoutput>#GetLangVal('extras_ph_route_planner_to')#</cfoutput>:</b>
	</td>
  </tr>
  <tr>
    <td valign="top" width="50%">

		<cfoutput query="q_user_data">
		<table border="0" cellspacing="0" cellpadding="5">
		  <tr>
			<td align="right">#GetLangVal('adrb_wd_street')#:</td>
			<td><input type="text" name="frmstreet1" size="25" maxlength="150" value="#htmleditformat(q_user_data.address1)#"></td>
		  </tr>
		  <tr>
		  	<td align="right">#GetLangVal('adrb_wd_zipcode')#:</td>
			<td><input type="text" name="frmzipcode1" size="10" maxlength="10" value="#htmleditformat(q_user_data.plz)#"></td>
		  </tr>
		  <tr>
			<td align="right">#GetLangVal('adrb_wd_city')#:</td>
			<td><input type="text" name="frmcity1" size="25" maxlength="150" value="#htmleditformat(q_user_data.city)#"></td>
		  </tr>
		  <tr>
			<td align="right">#GetLangVal('adrb_wd_country')#:</td>
			<td>
			<select name="frmcountry1">
				<option value='at' >Oesterreich (A)</option>
				<option value='de' <cfif q_user_data.country is "Deutschland">selected</cfif>>Deutschland (D)</option>
<option value="al">Albanien</option>

<option value="ad">Andorra</option>
<option value="am">Armenien</option>
<option value="az">Aserbaidschan</option>
<option value="be">Belgien</option>
<option value="ba">Bosnien</option>
<option value="bg">Bulgarien</option>
<option value="dk">Daenemark</option>
<option value="ee">Estland</option>

<option value="fo">Faroeer Inseln</option>
<option value="fi">Finnland</option>
<option value="fr">Frankreich</option>
<option value="ge">Georgien</option>
<option value="gr">Griechenland</option>
<option value="gb">Groszbritannien</option>
<option value="ie">Irland</option>
<option value="is">Island</option>
<option value="it">Italien</option>

<option value="hr">Kroatien</option>
<option value="lv">Lettland</option>
<option value="li">Liechtenstein</option>
<option value="lt">Litauen</option>
<option value="lu">Luxemburg</option>
<option value="mt">Malta</option>
<option value="mk">Mazedonien</option>
<option value="md">Moldawien</option>
<option value="mc">Monaco</option>

<option value="nl">Niederlande</option>
<option value="no">Norwegen</option>
<option value="pl">Polen</option>
<option value="pt">Portugal</option>
<option value="ro">Rumaenien</option>
<option value="ru">Russland</option>
<option value="se">Schweden</option>
<option value="ch">Schweiz</option>

<option value="cs">Serbien und Montenegro</option>
<option value="sk">Slovakei</option>
<option value="si">Slowenien</option>
<option value="es">Spanien</option>
<option value="cz">Tschechien</option>
<option value="tr">T�rkei</option>
<option value="ua">Ukraine</option>
<option value="hu">Ungarn</option>
<option value="by">Wei�russland</option>

<option value="cy">Zypern</option>
			</select>
			</td>
		  </tr>
		</table>
		</cfoutput>		

    </td>
	<td class="bl" valign="top">
	
		<table border="0" cellspacing="0" cellpadding="5">
		  <tr>
			<td align="right"><cfoutput>#GetLangVal('adrb_wd_street')#</cfoutput>:</td>
			<td><input type="text" name="frmstreet2" size="25" maxlength="150" value=""></td>
		  </tr>
		  <tr>
		  	<td align="right"><cfoutput>#GetLangVal('adrb_wd_zipcode')#</cfoutput>:</td>
			<td><input type="text" name="frmzipcode2" size="10" maxlength="10" value=""></td>
		  </tr>
		  <tr>
			<td align="right"><cfoutput>#GetLangVal('adrb_wd_city')#</cfoutput>:</td>
			<td><input type="text" name="frmcity2" size="25" maxlength="150" value=""></td>
		  </tr>
		  <tr>
			<td align="right"><cfoutput>#GetLangVal('adrb_wd_country')#</cfoutput>:</td>
			<td>
			<select name="frmcountry2">

				<option value='at' >Oesterreich (A)</option>
				<option value='de' <cfif q_user_data.country is "Deutschland">selected</cfif>>Deutschland (D)</option>
<option value="al">Albanien</option>

<option value="ad">Andorra</option>
<option value="am">Armenien</option>
<option value="az">Aserbaidschan</option>
<option value="be">Belgien</option>
<option value="ba">Bosnien</option>
<option value="bg">Bulgarien</option>
<option value="dk">Daenemark</option>
<option value="ee">Estland</option>

<option value="fo">Faroeer Inseln</option>
<option value="fi">Finnland</option>
<option value="fr">Frankreich</option>
<option value="ge">Georgien</option>
<option value="gr">Griechenland</option>
<option value="gb">Groszbritannien</option>
<option value="ie">Irland</option>
<option value="is">Island</option>
<option value="it">Italien</option>

<option value="hr">Kroatien</option>
<option value="lv">Lettland</option>
<option value="li">Liechtenstein</option>
<option value="lt">Litauen</option>
<option value="lu">Luxemburg</option>
<option value="mt">Malta</option>
<option value="mk">Mazedonien</option>
<option value="md">Moldawien</option>
<option value="mc">Monaco</option>

<option value="nl">Niederlande</option>
<option value="no">Norwegen</option>
<option value="pl">Polen</option>
<option value="pt">Portugal</option>
<option value="ro">Rumaenien</option>
<option value="ru">Russland</option>
<option value="se">Schweden</option>
<option value="ch">Schweiz</option>

<option value="cs">Serbien und Montenegro</option>
<option value="sk">Slovakei</option>
<option value="si">Slowenien</option>
<option value="es">Spanien</option>
<option value="cz">Tschechien</option>
<option value="tr">T�rkei</option>
<option value="ua">Ukraine</option>
<option value="hu">Ungarn</option>
<option value="by">Wei�russland</option>

<option value="cy">Zypern</option>
			</select>
			</td>
		  </tr>
		</table>
	
	
	</td>
  </tr>
  <tr>
  	<td align="center" class="bt">
	<input type="submit" name="frmsubmitlocationAonly" value="<cfoutput>#GetLangVal('extras_ph_route_planner_show_this_location')#</cfoutput>" class="btn2" />
	</td>
	<td align="center" class="bl bt">
	<input type="submit" name="frmsubmitlocationBonly" value="<cfoutput>#GetLangVal('extras_ph_route_planner_show_this_location')#</cfoutput>" class="btn2" />
	</td>
  </tr>
  
</table>
</form>
<font class="addinfotext"><cfoutput>#GetLangVal('extras_ph_route_planner_map24')#</cfoutput></font>


