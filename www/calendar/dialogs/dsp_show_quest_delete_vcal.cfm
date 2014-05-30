<!--- //

	Module:		Calendar
	Action:		ShowQuestDeleteVirtualCalendar
	Description:Delete virtual calendar?
	

// --->

<!--- entrykey of virtual calendar ... --->
<cfparam name="url.entrykey" type="string" default="">

Are you sure that you want to delete the virtual calendar '<cfoutput>#url.title#</cfoutput>'
<br /><br />  

<form method="post" action="index.cfm?action=DoDeleteVirtualCalendar">
<input type="hidden" name="frmentrykey" value="<cfoutput>#url.entrykey#</cfoutput>" />
<table class="table_detail table_edit_form">
<tr>
	<td>
		<input type="checkbox" name="frmdodeleteappointmentsaswell" value="true" class="noborder">
	</td>
	<td>
		Delete appointments as well
	</td>
</tr>
<tr>
	<td colspan="2">
	<input type="submit" value="delete" class="btn btn-primary" />
	<input type="button" value="no, do not delete" onclick="CloseSimpleModalDialog();" class="btn" />
	</td>
</tr>
</table>
</form>

