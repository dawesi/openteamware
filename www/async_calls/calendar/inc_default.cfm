
<cfparam name="url.action" type="string" default="">


<cfswitch expression="#url.action#">
	<cfcase value="delete">
		<!--- simple delete of ONE event --->
		<cfinclude template="inc_action_delete.cfm">
	</cfcase>
</cfswitch>