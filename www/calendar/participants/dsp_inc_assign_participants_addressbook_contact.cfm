<!--- //

	Module:		Calendar
	Action:		AssignNewElementToAppointment
	Description:Assign contact from address book
	

// --->

<form  action="act_add_addressbook_contacts.cfm" method="post">
	<input type="hidden" name="formeventkey" value="#url.eventkey#">
Use template show_select_addressbook.cfm as example

<input type="checkbox" value="1"> Send invitation by email
<input type="submit">
</form>

