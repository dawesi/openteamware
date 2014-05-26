<!--- //

	list the tasks
	
	needed: query q_select_tasks
	
	// --->
	
<div class="bb">
<table border="0" cellspacing="0" cellpadding="6">
<form action="index.cfm?action=QuickAdd" method="POST" enablecab="No">
<tr>
	<td align="right"><img src="/images/icon/icon_star.gif" align="absmiddle" vspace="2" hspace="2" border="0">&nbsp;Kurze Notiz anlegen:</td>
	<td><input type="Text" name="frmTitle" required="Yes" size="40" maxlength="100"></td>
	<td><input type="Submit" name="frmSubmit" value="Speichern"></td>
	<td><a href="index.cfm?action=NewTask">Erweiterte Eingabe ...</a></td>
</tr>
</form>
</table>
</div>

<div class="bb">
<table border="0" cellspacing="2" cellpadding="4" align="center">
  <tr>
  	<td>Ansicht:&nbsp;</td>
    <td width="120px" align="center">
	<b><cfoutput>#GetLangVal("tsk_wd_view_standard")#</cfoutput></b>
	</td>
    <td width="120px" align="center" class="bl">
	<a class="simplelink" href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "status", 1)#</cfoutput>"><img src="/images/high.png" width="8" height="17" hspace="2" vspace="2" align="absmiddle" border="0"><cfoutput>#GetLangVal("tsk_wd_view_due")#</cfoutput> (7)</a>
	</td>
    <td width="120px" align="center" class="bl">
	<a class="simplelink" href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "status", 2)#</cfoutput>"><img src="/images/high.png" width="8" height="17" hspace="2" vspace="2" align="absmiddle" border="0"><img src="/images/high.png" width="8" height="17" hspace="2" vspace="2" align="absmiddle" border="0"><cfoutput>#GetLangVal("tsk_wd_view_overdue")#</cfoutput> (18)</a>
	</td>
    <td width="120px" align="center" class="bl">
	<a class="simplelink" href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "status", 0)#</cfoutput>"><img src="/images/set_status_done.gif" height="16" width="16" border="0" vspace="2" hspace="2" align="absmiddle"><cfoutput>#GetLangVal("tsk_wd_view_done")#</cfoutput> (127)</a>
	</td>
  </tr>
</table>
</div>
<br>
<cfinclude template="dsp_standard_list.cfm">