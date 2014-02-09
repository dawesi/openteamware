<!--- //

	edit a customer ...
	
	// --->
	
<cfif form.frmdomain is "own">
	<cfset form.frmdomain = form.frmowndomain>
</cfif>
	
<cfinclude template="queries/q_update_customer.cfm">

<cflocation addtoken="no" url="default.cfm?action=customerproperties&companykey=#urlencodedformat(form.frmentrykey)#&resellerkey=#urlencodedformat(form.frmresellerkey)#">