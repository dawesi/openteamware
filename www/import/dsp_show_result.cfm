<!--- //

	Module:        Import
	Description:   Display result of import process
	

// --->

<cfset SetHeaderTopInfoString(GetLangVal('import_ph_import_done')) />

<cfparam name="url.jobkey" type="string">

<br /><br /><br />
   
<img src="/images/si/accept.png" class="si_img" /> <cfoutput>#GetLangVal('import_ph_import_done')#</cfoutput>

