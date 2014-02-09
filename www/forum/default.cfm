<!--- //

	Module:		Forum
	Description: 
	

// --->


<cfparam name="url.action" default="ShowWelcome" type="string">
<cfparam name="url.folder" default="0">
<cfparam name="url.sort" default="up" type="string">
<cfparam name="url.order" default="title" type="string">

<cfoutput>#GetRenderCmp().GenerateServiceDefaultFile(servicekey = '66A3CE92-923A-0620-7656393EA07FAB3B',
										pagetitle = GetLangVal('cm_wd_fax'))#</cfoutput>
										

