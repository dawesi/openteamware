<!--- //

	Service:	CRM
	Action:		DeleteFollowups
	Description:Delete given follow ups
	
	Header:	

// --->

<cfparam name="url.entrykeys" type="string" default="">

<cfloop list="#url.entrykeys#" index="sEntrykey">

	<cfset application.components.cmp_followups.DeleteFollowup(securitycontext = request.stSecurityContext,
						entrykey = sEntrykey) />
						
</cfloop>

<cflocation addtoken="false" url="#ReturnRedirectURL()#">


