<!--- // 

	save and edit views ...
	
	// --->
<cfinclude template="queries/q_select_views.cfm">

<cf_disp_navigation mytextleft="Ansichten abspeichern">
<br>

<cfif StructKeyExists(url, "saveview")>
Geben Sie nun bitte einen Namen und eine Beschreibung ein um die Ansicht abzuspeichern:
<table border="0" cellspacing="0" cellpadding="6">
<form action="act_save_view.cfm" method="post" name="formsaveview">
  <tr>
    <td align="right">Name:</td>
    <td><input type="text" name="frmname" size="30"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="frmsubmit" value="Speichern"></td>
  </tr>
  </form>
</table>

</cfif>

<script type="text/javascript">
	function DeleteView(entrykey)
		{
		if (confirm('Wollen Sie diese Ansicht wirklich loeschen?') == true)
			{
			location.href = 'act_delete_view.cfm?entrykey='+escape(entrykey);
			}
		}
</script>
<br><br>

<b>Gespeicherte Ansichten (<cfoutput>#q_select_views.recordcount#</cfoutput>)</b><br><br>

<table border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
    <td class="bb">Name</td>
    <td class="bb">Erstellt</td>
    <td class="bb"><b>Anzeigen</b></td>
    <td class="bb">Loeschen</td>
  </tr>
  <cfoutput query="q_select_views">
  <tr>
    <td>
	<a href="default.cfm?#q_select_views.href#">#htmleditformat(checkzerostring(q_select_views.viewname))#</a>
	</td>
    <td>#lsDateFormat(q_select_views.dt_created, "dd.mm.yy")#</td>
    <td>
	<a href="default.cfm?#q_select_views.href#"><b>Jetzt anzeigen ...</b></a>
	</td>
    <td align="center">
	<a href="javascript:DeleteView('#jsstringformat(q_select_views.entrykey)#');"><img src="/images/del.gif" width="12" height="12" hspace="4" vspace="4" border="0" align="absmiddle"></a>
	</td>
  </tr>
  </cfoutput>
</table>

