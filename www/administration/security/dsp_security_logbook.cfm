<cfinclude template="../dsp_inc_select_company.cfm">

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
  <cfinvokeargument name="entrykey" value="#url.userkey#">
</cfinvoke>

<cfset q_userdata = stReturn.query>

<h4><cfoutput>#GetLangVal('adm_ph_security_logbook')#</cfoutput></h4>

<b><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>: <cfoutput>#htmleditformat(q_userdata.username)#</cfoutput></b>
<hr size="1" noshade><bR>

<b><cfoutput>#GetLangVal('adm_ph_failed_logins')#</cfoutput></b> 
<br>


<hr size="1" noshade>

<br><br>
<cfinvoke component="/components/log/cmp_log" method="GetLoginLogbook" returnvariable="q_select_logbook">
	<cfinvokeargument name="userkey" value="#url.userkey#">
	<cfinvokeargument name="usersettings" value="#session.stUserSettings#">
</cfinvoke>

<cfquery name="q_select_logbook" dbtype="query">
SELECT
	*
FROM
	q_select_logbook
ORDER BY
	dt_created DESC
;
</cfquery>

<b><cfoutput>#GetLangVal('adm_ph_last_50_logins')#</cfoutput></b><hr size="1" noshade>
<table class="table table-hover">
  <tr class="tbl_overview_header"> 
    <td>&nbsp;</td>
    <td><cfoutput>#GetLangVal('cm_ph_date_time')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_area')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_ph_ip_address')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_logbook" startrow="1" maxrows="50"> 
    <tr> 
      <td align="right">#q_select_logbook.currentrow#</td>
      <td>#LsDateFormat(q_select_logbook.dt_created, "ddd, dd.mm.yyyy")# #TimeFormat(q_select_logbook.dt_created, "HH:mm")#</td>
      <td> 
        <cfswitch expression="#val(q_select_logbook.loginsection)#">
          <cfcase value="0">
          <img src="/storage/images/topopen.gif" width="19" height="19" hspace="2" vspace="2" border="0" align="absmiddle">Web
          </cfcase>
          <cfcase value="1">
          <img src="/images/settings/menu_anzeige.gif" width="19" height="19" hspace="2" vspace="2" border="0" align="absmiddle"> 
          PDA
          </cfcase>
          <cfcase value="2">
          <img src="/images/settings/menu_wireless.gif" width="19" height="19" hspace="2" vspace="2" border="0" align="absmiddle">WAP
          </cfcase>
          <cfcase value="3">
          Tools
          </cfcase>
        </cfswitch> </td>
      <td>#q_select_logbook.ip# <a target="_blank" href="http://www.ripe.net/perl/whois?form_type=simple&full_query_string=&searchtext=#urlencodedformat(q_select_logbook.ip)#&do_search=Search"><img src="/images/info.jpg" width="12" height="12" hspace="2" vspace="2" border="0" align="absmiddle" title=""></a></td>
    </tr>
  </cfoutput> 
</table>
