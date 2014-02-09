<!--- used for forms ... this file generates an uuid that is used in forms.

so a user can have a session timeout and click on an action from, than he
has to enter his access data and no inputs are lost! --->

<cfif isDefined("session.AutologinKey")>
	<input type="hidden" name="frmIBLoginKey" value="<cfoutput>#session.AutologinKey#</cfoutput>">
</cfif>