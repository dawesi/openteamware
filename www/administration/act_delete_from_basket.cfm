<!--- //

	delete from basket
	
	// --->
	

<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.companykey" type="string" default="">

<cfset DeleteFromBasketRequest.entrykey = url.entrykey>
<cfset DeleteFromBasketRequest.companykey = url.companykey>
<cfinclude template="queries/q_delete_from_basket.cfm">


<cflocation addtoken="no" url="default.cfm?action=shop#WriteURLTags()#">