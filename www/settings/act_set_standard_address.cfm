<!--- //



	set an email address as standard address ...

	

	// --->

<cfparam name="url.emailaddress" type="string" default="#request.stSecurityContext.myusername#">



<cfmodule template="../common/person/saveuserpref.cfm"

	entrysection = "email"

	entryname = "defaultemailaccount"

	entryvalue1 = #url.emailaddress#>	



<cflocation addtoken="no" url="index.cfm?action=emailaccounts">