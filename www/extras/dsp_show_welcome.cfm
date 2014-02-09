

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_overview')) />


<table border="0" cellspacing="0" cellpadding="8">
 <tr>
    <td valign="middle" align="right">
		<a href="../mailing/"><img src="/images/si/arrow_out.png" class="si_img" /></a>
	</td>
    <td valign="middle">
		<a href="/mailing/"><b><cfoutput>#GetLangVal('cm_wd_mailings')#</cfoutput></b></a>
		<br>
		<cfoutput>#GetLangVal('adrb_ph_mailings_description')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td valign="middle" align="right">
		<a href="../download/"><img src="/images/si/basket.png" class="si_img" /></a>
	</td>
    <td valign="middle">
		<a href="/download/"><b><cfoutput>#GetLangVal('extras_wd_downloads')#</cfoutput></b></a>
		<br>
		<cfoutput>#GetLangVal('extras_wd_downloads_description')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td valign="middle" align="right"><img src="/images/si/tag_orange.png" class="si_img" /></td>
    <td valign="middle">
		<a href="../bookmarks/"><b><cfoutput>#GetLangVal('cm_wd_bookmarks')#</cfoutput></b></a>
		<br>
		<cfoutput>#GetLangVal('extras_ph_bookmarks_description')#</cfoutput>
	</td>
  </tr>
   <tr>
    <td valign="middle" align="right">
		<a href="default.cfm?action=routeplanner"><img src="/images/si/map.png" class="si_img" /></a>
	</td>
    <td valign="middle">
		<a href="default.cfm?action=routeplanner"><b><cfoutput>#GetLangVal('extras_ph_route_planner')#</cfoutput></b></a>
		<br>
		<cfoutput>#GetLangVal('extras_ph_route_planner_description')#</cfoutput>
	</td>
  </tr>
   <tr>
    <td valign="middle" align="right">&nbsp;</td>
    <td valign="middle">
		<a href="default.cfm?action=Goodies"><b>Goodies</b></a>
		<br>
		<cfoutput>#GetLangVal('extras_ph_goodies_description')#</cfoutput>
	</td>
  </tr>
</table>