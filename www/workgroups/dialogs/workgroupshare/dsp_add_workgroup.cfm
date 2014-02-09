
<!--- add a workgroup now ... --->

<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupNameByEntryKey" returnvariable="a_str_name">

	<cfinvokeargument name="entrykey" value="#url.workgroupkey#">
</cfinvoke>

<form action="act_add_workgroup.cfm" method="post">

<b>Arbeitsgruppe "<cfoutput>#a_str_name#</cfoutput>" hinzufuegen</b>

<br><br>
Zugriff erlauben fuer ...<br>
<input checked type="Radio" onclick="HideWorkgroupMembers();" class="noborder" name="frmcballowto" value="all"> <b>alle</b> Mitglieder dieser Arbeitsgruppe (entsprechend ihren Berechtigungen)
<br>
<input type="Radio" onclick="DisplayWorkgroupMembers();" class="noborder" name="frmcballowto" value="selection"> eine <b>Auswahl</b> der Mitglieder
<br>

<!--- load members ... --->
<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupMembers" returnvariable="q_select_users">
	<cfinvokeargument name="workgroupkey" value=#url.workgroupkey#>
</cfinvoke>
<div style="display:none;padding-left:40px;" id="iddivmembers">

<table border="0" cellspacing="0" cellpadding="3">
<cfoutput query="q_select_users">
<tr>
	<td><input checked type="Checkbox" name="frmcbuser" class="noborder" value="#q_select_users.userkey#"></td>
	<td>
	#htmleditformat(q_select_users.fullname)#
	</td>
	<td>
	#q_select_users.roles#
	</td>
	<td>
	#q_select_users.username#
	</td>
</tr>
</cfoutput>
</table>

</div>
<input type="Radio" name="frmcballowto" disabled value="roles" class="noborder"> Bestimmte <b>Rollen</b>


<br>


&nbsp;&nbsp;&nbsp;<input type="Submit" name="frmsubmit" value="Hinzufuegen ...">

</form>

<script type="text/javascript">
	function DisplayWorkgroupMembers()
		{
		var obj1;
		obj1 = findObj('iddivmembers');
		obj1.style.display = "";		
		}
	function HideWorkgroupMembers()
		{
		var obj1;
		obj1 = findObj('iddivmembers');
		obj1.style.display = "none";				
		}
</script>