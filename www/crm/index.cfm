<!--- //

	Module:        CRM
	Description:   Main controller file
	

// --->

<cfset a_str_content = GetRenderCmp().GenerateServiceDefaultFile(servicekey = '7E68B84A-BB31-FCC0-56E6125343C704EF',
										pagetitle = GetLangVal('cm_wd_crm')) />

<cfoutput>#a_str_content#</cfoutput>

