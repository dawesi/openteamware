<!--- //

	compose a new email ... 
	
	//--->
	
<cfparam name="url.to" type="string" default="">
<cfparam name="url.subject" type="string" default="">

<!--- check if url contains ?subject= ... --->

<cfset url.to = ReplaceNoCase(url.to, "/emailaddress:", "")>

<cfif FindNoCase("?subject=", url.to) gt 0>
	<cfset url.to = Mid(url.to, 1, findnocase("?subject=",url.to, 1))>
	<cfset url.subject = mid(url.to, findnocase("?subject=", url.to)+len("?subject=")+1, len(url.to))>
</cfif>

<cflocation addtoken="no" url="../../../email/default.cfm?action=composemail&to=#urlencodedformat(url.to)#&subject=#urlencodedformat(url.subject)#&type=0">