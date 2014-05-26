<!--- //

	// --->
	
<!--- load preferences --->

<cfparam name="url.showfulltext" default="0" type="numeric">
	
<cfset GetTasksRequest.itemtype = 1>
<cfinclude template="queries/q_select_tasks.cfm">
	
<cf_disp_navigation mytextleft="Notizen">
<br>
<cfif url.showfulltext is 1>
[ <a href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "showfulltext", 0)#</cfoutput>">Notiztext ausblenden</a> ]
<cfelse>
[ <a href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "showfulltext", 1)#</cfoutput>">Notiztext einblenden</a> ]
</cfif>
&nbsp;&nbsp;[ <a href="index.cfm?action=NewNotice">Neue Notiz eintragen</a> ]
<!--- save now preferences on this --->

<br><br>
<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
    <td class="bb" colspan="2">Titel</td>
    <td class="bb">Ge�ndert</td>
    <td class="bb">Projekt/Kategorie</td>
    <td class="bb">Aktion</td>
  </tr>
  <cfoutput query="q_select_tasks">
  <tr>
    <td class="bb" colspan="2" nowrap><img src="/images/icon/notizen.gif" vspace="0" height="12" width="12" hspace="0" border="0">&nbsp;<a href="index.cfm?action=ShowNotice&id=#q_select_tasks.id#" class="simplelink"><b>#q_select_tasks.title#</b></a></td>
    <td class="bb">#LsDateFormat(q_select_tasks.lastmodified, "ddd, dd.mm.yyyy")# #TimeFormat(q_select_tasks.lastmodified, "HH:mm")#</td>
    <td class="bb">&nbsp;</td>
	<td class="bb">
	<img src="/images/editicon.gif">
	&nbsp;|&nbsp;
	<img src="/images/del.gif">	
	</td>
  </tr>
  <cfif Compare(url.showfulltext, 1) is 0>
  <tr>
  	<td class="bb" width="10px">&nbsp;</td>
	<td colspan="4" class="bb">
	#htmleditformat(q_select_tasks.notice)#
	</td>
  </tr>
  </cfif>
  </cfoutput>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr class="mischeader">
  	<td colspan="5" class="bb"><b>Neue Notiz eintragen</b></td>
  </tr>
  <form action="act_new_notice.cfm" method="post">
  <tr>
  	<td colspan="5">
	<textarea name="frmNotice" cols="35" rows="5"></textarea>
	</td>
  </tr>
  <tr>
  	<td colspan="5">
	<input type="submit" name="frmSubmit" value="Notiz eintragen">
	</td>
  </tr>
  </form>
