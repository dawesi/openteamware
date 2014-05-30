<!--- //
	
	display the last 50 logins
	
	(ip/datetime)
	
	// --->
<cfinclude template="queries/q_select_logins.cfm">
	
<cf_disp_navigation mytextleft="#GetLangVal('prf_ph_security_login_logbook')#">

<br>
<cfoutput>#GetLangVal('prf_ph_security_logbook')#</cfoutput><br>
<br>

<table class="table table-hover">
  <tr class="tbl_overview_header">
    <td></td>
    <td><cfoutput>#GetLangVal('mail_ph_datetime')#</cfoutput></b></td>
    <td><b><cfoutput>#GetLangVal('cm_ph_ip_address')#</cfoutput></b></td>
  </tr>
<cfoutput query="q_select_logins">
  <tr>
    <td class="addinfotext">#q_select_logins.currentrow#</td>
    <td>#LsDateFormat(q_select_logins.dt, "ddd, dd.mm.yyyy")# #TimeFormat(q_Select_logins.dt, "HH:mm")#</td>
    <td>#q_select_logins.ip# <a target="_blank" href="http://www.ripe.net/perl/whois?form_type=simple&full_query_string=&searchtext=#q_select_logins.ip#&do_search=Search"><img src="/images/si/information.png" class="si_img" /></a></td>
  </tr>
</cfoutput>
</table>
