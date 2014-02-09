<!--- //

	Module:		EMail
	Action:		AddDomainToRemoteImageDisplayException
	Description:Allow to load remote images for this domain
	

// --->

<cfparam name="url.sender" type="string" default="">

<cfset a_str_sender = ExtractEmailAdr(url.sender) />

<cfset a_str_domain = ListLast(a_str_sender, '@') />

<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "surpress_external_elements_exception_domains"
	defaultvalue1 = ""
	setcallervariable1 = "a_str_surpress_external_elements_exception_domains">
	
<cfif ListFindNoCase(a_str_surpress_external_elements_exception_domains, a_str_domain, chr(10)) IS 0>
	<cfset a_str_surpress_external_elements_exception_domains = ListAppend(a_str_surpress_external_elements_exception_domains, a_str_domain, chr(10)) />
</cfif>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "surpress_external_elements_exception_domains"
	entryvalue1 = #a_str_surpress_external_elements_exception_domains#>

<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">


