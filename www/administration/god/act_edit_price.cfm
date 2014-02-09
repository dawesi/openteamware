<cfif ListFindNoCase('5CC09B22-C7D0-A37B-531095FF97EADD33,60A4475A-C14B-BF72-E972FDFA003DA27C',request.stSecurityContext.myuserkey) is 0>

	<cfabort>

</cfif>



<!--- edit a price ... --->


<cfif IsDefined("form.FRMSUBMITSAVE")>
	<cfinclude template="queries/q_update_price.cfm">
</cfif>

<cfif isDefined("form.FRMSUBMITDELETE")>
	<cfinclude template="queries/q_delete_price.cfm">
</cfif>



<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">