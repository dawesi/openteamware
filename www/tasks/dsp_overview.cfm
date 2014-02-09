<!--- show overview ... --->
<cf_disp_navigation mytextleft="Notizen und Aufgaben"><br>

<a href="default.cfm?action=ShowWelcome"><b>Jetzt alle Aufgaben und Notizen anzeigen</b></a><br><br>

<table  border="0" cellspacing="0" cellpadding="2">
<form action="default.cfm?action=QuickAdd" method="POST" enablecab="No">
<cfinclude template="../login/inc_login_key.cfm">
<tr>
	<td colspan="7" class="b_all">
		
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td align="right">Kurze Notiz anlegen:</td>
		<td><cfinput type="Text" name="frmTitle" required="Yes" size="40" maxlength="100"></td>
		<td><input type="Submit" name="frmSubmit" value="Speichern"></td>
		<td><a href="default.cfm?action=NewNotice">Erweiterte Eingabe ...</a></td>
	</tr>
	</table>
	
	</td>
</tr>
</form>
</table>
<br>

<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td>
	<!--- include tasks --->
	
	&nbsp;</td>
    <td width="200">
	<!--- notices --->
	
		<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#FFFF99">
		<tr>
			<td><b>Notizen</b></td>
		</tr>
		<tr>
			<td align="center">
			<textarea name="frmNotice" cols="25" rows="3" style="width:100%;font-family:Verdana;font-size:11px;"></textarea>

			<input type="submit" name="frmSubmit" value="Hinzuf&uuml;gen">
			</td>
		</tr>
		<tr>
			<td>
			<div style="border:#FFFF66 solid 1px;">&nbsp;</div>
			
			</td>
		</tr>
		</table>

	
	&nbsp;</td>
  </tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="7">
  <tr>
    <td valign="top" style="border-bottom:dashed silver 1px;">
	<cfset TaskRequest.SelectTop = 15>
	<cfset TaskRequest.StatusExclude = 0>
	<cfset TaskRequest.Sort = "due">
	<cfset TaskRequest.DueNotNull = 1>
	<cfset TaskRequest.Order = "up">
	<cfset TaskRequest.DueDateGreatherThan = "">	
	<cfinclude template="qry_get_all_notices.cfm">

	<b style="letter-spacing:2px;"><img src="/images/high.png" border="0" align="absmiddle"><img src="/images/high.png" align="absmiddle" hspace="3" vspace="3">&nbsp;&Uuml;berf&auml;llige Aufgaben</b>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr class="spaltenkoepfe">
		<td class="bb" width="20">&nbsp;</td>
		<td class="bb">Betreff</td>
		<td class="bb">F&auml;llig</td>
		<td class="bb">Tage</td>
	</tr>
	<cfoutput query="q_select_all">
	<cfif q_select_all.dt_due lte now()>
	  <tr>
		<td valign="top"><font style="color:##CC0000;font-weight:bold;">&##187;</font></td>
		<td valign="top"><img height=9 width=9 align="absmiddle" src="/images/tasks/task_status_#q_select_all.status#.png">&nbsp;&nbsp;<a href="default.cfm?action=showNotice&id=#q_select_all.id#" class="ntd">#q_select_all.title#</a></td>
		<td valign="top">#dateformat(q_select_all.dt_due, "dd.mm.yyy")#</td>
		<cfset ADistance = DateDiff("d", q_select_all.dt_due, now())>
		<td align="right" valign="top">#ADistance#</td>
	  </tr>
	 </cfif>
	 </cfoutput>
	</table>	
	
	</td>
    <td valign="top" style="border-left:dashed silver 1px;border-bottom:dashed silver 1px;">
		
	<cfset TaskRequest.SelectTop = 15>
	<cfset TaskRequest.StatusExclude = 0>
	<cfset TaskRequest.DueNotNull = 1>
	<cfset TaskRequest.Sort = "due">
	<cfset TaskRequest.DueDateGreatherThan = now()>
	<cfset TaskRequest.Order = "down">
	<cfinclude template="qry_get_all_notices.cfm">

	<b style="letter-spacing:2px;"><img src="/images/high.png" align="absmiddle" hspace="3" vspace="3">&nbsp;Bald f&auml;llige Aufgaben</b>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr class="spaltenkoepfe">
		<td class="bb" width="20">&nbsp;</td>
		<td class="bb">Titel</td>
		<td class="bb" align="right">F&auml;llig</td>
		<td align="right" class="bb">Tage</td>
	</tr>
	<cfoutput query="q_select_all">	
	  <tr>
		<td valign="top"><font style="color:##CC0000;font-weight:bold;">&##187;</font></td>
		<td valign="top"><img height=9 width=9 align="absmiddle" src="/images/tasks/task_status_#q_select_all.status#.png">&nbsp;&nbsp;<a href="default.cfm?action=showNotice&id=#q_select_all.id#" class="ntd">#q_select_all.title#</a></td>
		<td valign="top" align="right">#dateformat(q_select_all.dt_due, "dd.mm.yyy")#</td>		
		<cfset ADistance = DateDiff("d",now(),  q_select_all.dt_due)>
		<td align="right" valign="top">#ADistance#</td>
	  </tr>
	 </cfoutput>
	</table>
		
	</td>
  </tr>
  <tr>
    <td valign="top">
	<cfset TaskRequest.SelectTop = 15>
	<cfset TaskRequest.StatusExclude = -1>
	<cfset TaskRequest.StatusExclude2 = 0>
	<cfset TaskRequest.Sort = "id">
	<cfset TaskRequest.Order = "down">
	<cfset TaskRequest.DueDateGreatherThan = "">
	<cfinclude template="qry_get_all_notices.cfm">

	<b style="letter-spacing:2px;"><img src="/images/tasks/red_square.gif" border="0" align="absmiddle">&nbsp;Neuste Eintr&auml;ge</b>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr class="spaltenkoepfe">
		<td class="bb" width="20">&nbsp;</td>
		<td class="bb">Titel</td>
		<td class="bb" align="right">F&auml;llig</td>
	</tr>
	<cfoutput query="q_select_all">
	  <tr>
		<td valign="top"><font style="color:##CC0000;font-weight:bold;">&##187;</font></td>
		<td valign="top"><img height=9 width=9 align="absmiddle" src="/images/tasks/task_status_#q_select_all.status#.png">&nbsp;&nbsp;<a href="default.cfm?action=showNotice&id=#q_select_all.id#" class="ntd">#q_select_all.title#</a></td>
		<td valign="top" align="right">#dateformat(q_select_all.dt_due, "dd.mm.yyy")#</td>		
	  </tr>
	  </cfoutput>
	</table>

	</td>
    <td valign="top" style="border-left:dashed silver 1px;">
	<cfset TaskRequest.SelectTop = 15>
	<cfset TaskRequest.StatusOnly = 0>
	<cfset TaskRequest.StatusExclude2 = "">
	<cfset TaskRequest.StatusExclude = "">
	<cfset TaskRequest.DueNotNull = "">
	<cfset TaskRequest.DueDateGreatherThan = "">
	<cfset TaskRequest.Sort = "id">
	<cfset TaskRequest.Order = "down">
	
	<cfinclude template="qry_get_all_notices.cfm">

	<b style="letter-spacing:2px;"><img src="/images/set_status_done.gif" border="0" align="absmiddle">&nbsp;Zuletzt erledigte Aufgaben</b>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr class="spaltenkoepfe">
		<td class="bb" width="20">&nbsp;</td>
		<td class="bb">Titel</td>
	</tr>
	<cfoutput query="q_select_all">
	  <tr>
		<td valign="top"><font style="color:gray;font-weight:bold;">&##187;</font></td>
		<td valign="top"><a href="default.cfm?action=showNotice&id=#q_select_all.id#" class="ntd">#q_select_all.title#</a></td>
	  </tr>
	  </cfoutput>
	</table>
	</td>
  </tr>
</table>
