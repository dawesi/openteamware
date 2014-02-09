<!--- //

	// --->
	
<cfparam name="url.action" type="string" default="">


<cfswitch expression="#url.action#">
	<cfcase value="delete">
		<!--- simple delete of ONE message --->
		<cfinclude template="inc_action_delete.cfm">
	</cfcase>
	<cfcase value="delete_multi">
		<!--- delete more than one message at once --->
	</cfcase>
</cfswitch>