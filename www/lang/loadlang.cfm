<!--- //

	Description:Reload the given translation data ...
	

// --->

<cfparam name="url.LoadLanguageNo" type="numeric" default="0">

<cfset iLangNo = url.LoadlanguageNo />

<cfif StructKeyExists(application.langdata, 'lang' & iLangNo)>

	<cfset StructDelete(application.langdata, 'lang' & iLangNo) />
	
	<!--- <cfset application.components.cmp_lang.LoadTranslationData(langno = iLangNo) /> --->
	
	forced reload for lang <cfoutput>#iLangNo#</cfoutput>
</cfif>
