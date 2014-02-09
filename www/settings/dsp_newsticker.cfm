<!--- //

	display the newsticker features
	
	// --->
<cfinclude template="../content/pages/newsticker/queries/q_select_newsfeeds.cfm">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "newsticker"
	entryname = "active"
	defaultvalue1 = "1">	
	<cfset a_int_nt_active = a_str_person_entryvalue1>
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "newsticker"
	entryname = "viewmode"
	defaultvalue1 = "onload">	
	<cfset a_str_nt_viewmode = a_str_person_entryvalue1>
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "newsticker"
	entryname = "secdelay"
	defaultvalue1 = "10">	
	<cfset a_int_nt_secdelay = a_str_person_entryvalue1>
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "newsticker"
	entryname = "randommode"
	defaultvalue1 = "0">	
	<cfset a_int_nt_random_mode = a_str_person_entryvalue1>
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "newsticker"
	entryname = "scrollspeed"
	defaultvalue1 = "6">	
	<cfset a_int_nt_scrollspeed = a_str_person_entryvalue1>
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "newsticker"
	entryname = "sourceids"
	defaultvalue1 = "4,15,11,10">	
	<cfset a_str_nt_sourceids = a_str_person_entryvalue1>		
	
<cf_disp_navigation mytextleft="#GetLangVal('cm_wd_newsticker')#">
<br>
<form action="act_save_newsticker_settings.cfm" method="post">
<table border="0" cellspacing="0" cellpadding="5" width="500">
  <tr class="mischeader">
    <td>
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td style="font-weight:bold; "><input type="checkbox" name="frmActive" class="noborder" value="1" <cfoutput>#WriteCheckedElement(a_int_nt_active, 1)#</cfoutput>> Newsticker aktivieren</td>
			<td align="right"><input type="submit" name="frmSubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>"></td>
		  </tr>
		</table>
	
	</td>
  </tr>
  <!---<tr>
    <td>
	<b>Wo soll der Newsticker angezeigt werden?</b><br>
	<input type="radio" name="frmAreas" value="all" class="noborder"> überall
	&nbsp;&nbsp;
	<input type="radio" name="frmAreas" value="selected" class="noborder"> nur auf den folgenden Seiten:</td>
  </tr>
  
  <tr>
    <td align="right">
	<select name="frmselectedareas" size="5" multiple>
		<option value="email" selected>E-Mail</option>
		<option value="calendar" selected>Kalender</option>
		<option value="addressbook" selected>Adressbuch</option>
	</select>
	</td>
  </tr>--->
  <tr>
    <td>
	<!---<b><cfoutput>#GetLangVal('prf_ph_newsticker_viewmode')#</cfoutput></b><br>--->
	
		<table border="0" cellspacing="0" cellpadding="2">
		<input type="hidden" name="frmviewmode" value="onload">
		<input type="hidden" name="frmsecdelayed" value="30">
		  <!---<tr>
			<td><input class="noborder" type="radio" name="frmviewmode" <cfoutput>#WriteCheckedElement(a_str_nt_viewmode, "onload")#</cfoutput> value="onload"></td>
			<td><cfoutput>#GetLangVal('prf_ph_newsticker_viewmode_at_once')#</cfoutput></td>
		  </tr>
		  <tr>
			<td><input class="noborder" type="radio" name="frmviewmode" <cfoutput>#WriteCheckedElement(a_str_nt_viewmode, "delayed")#</cfoutput>  value="delayed"></td>
			<td>um <input type="text" name="frmsecdelayed" size="2" maxlength="2" value="<cfoutput>#a_int_nt_secdelay#</cfoutput>"> Sekunden verz&ouml;gert einblenden</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td class="addinfotext">Dadurch wird der Newsticker bei schnellen Seitenwechseln nicht geladen</td>
		  </tr>--->
		  <tr>
			<td>&nbsp;</td>
			<td><cfoutput>#GetLangVal('prf_ph_newsticker_scrollspeed')#</cfoutput>: <input type="text" size="2" maxlength="2" name="frmscrollspeed" value="<cfoutput>#a_int_nt_scrollspeed#</cfoutput>"> (h&ouml;her = schneller)
			</td>
		  </tr>
		</table>

	</td>
  </tr>
  <tr class="mischeader">
  	<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td><b><cfoutput>#GetLangVal('prf_ph_newsticker_newsfeeds')#</cfoutput></b></td>
			<td align="right"><input type="submit" name="frmSubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>"></td>
		  </tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td>
	
	<!--- select news sources --->
	<table border="0" cellspacing="0" cellpadding="2">
	  <tr>
	  	<td class="bb">&nbsp;</td>
		<td class="bb">
		<select name="frmrandommode">
			<option <cfoutput>#WriteSelectedElement(a_int_nt_random_mode, 0)#</cfoutput> value="0"><cfoutput>#GetLangVal('prf_ph_newsticker_order_top_news')#</cfoutput></option>					
			<option <cfoutput>#WriteSelectedElement(a_int_nt_random_mode, 1)#</cfoutput> value="1"><cfoutput>#GetLangVal('prf_ph_newsticker_order_one_by_one')#</cfoutput></option>
			<option <cfoutput>#WriteSelectedElement(a_int_nt_random_mode, 2)#</cfoutput> value="2"><cfoutput>#GetLangVal('prf_ph_newsticker_randomized')#</cfoutput></option>
		</select>
		</td>
	  </tr>
	  <cfoutput query="q_select_newsfeeds">
	  <tr>
		<td><input <cfif ListFind(a_str_nt_sourceids, q_select_newsfeeds.id) gt 0>checked</cfif> type="checkbox" value="#q_select_newsfeeds.id#" name="frmsourceids"  class="noborder"></td>
		<td><cfif Len(q_select_newsfeeds.logoimg) gt 0><img src="#q_select_newsfeeds.logoimg#" hspace="4" vspace="4" border="0" align="absmiddle"></cfif><b>#htmleditformat(q_select_newsfeeds.feedname)#</b></td>
	  </tr>
	  <tr>
	  	<td class="bb">&nbsp;</td>
		<td class="bb">#htmleditformat(q_select_newsfeeds.description)#&nbsp;</td>
	  </tr>
	  </cfoutput>
	</table>

	</td>
  </tr>
  <tr class="mischeader">
  	<td align="right"><input type="submit" name="frmSubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>"></td>
  </tr>
</table>
</form>