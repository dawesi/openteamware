<!--- //

	Module:		Storage
	Description:Service
	

// --->

<cfparam name="url.action" type="string" default="ShowWelcome">
<cfparam name="url.directorykey" type="string" default="">
<cfset request.a_str_storage_servicekey = '5222ECD3-06C4-3804-E92ED804C82B68A2' />

<cfoutput>#GetRenderCmp().GenerateServiceDefaultFile(servicekey = '5222ECD3-06C4-3804-E92ED804C82B68A2',
										pagetitle = GetLangVal('cm_wd_project'))#</cfoutput>


