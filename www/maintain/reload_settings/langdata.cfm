<!--- //

	Description:reload language
	
	Header:		

// --->
	
<cfsetting showdebugoutput="false">
<cfsetting requesttimeout="2000">

<!--- reload translation ... --->
<cfinvoke component="#application.components.cmp_lang#" method="ReadTranslationsFromCSV" returnvariable="ab">
</cfinvoke>
	
<!--- reload lang ... --->
<cfloop from="0" to="7" index="ii">
	<cfhttp url="http://#cgi.http_host#/lang/loadlang.cfm?LoadLanguageNo=#ii#" delimiter="," resolveurl="no"></cfhttp>
	
	lang <cfoutput>#ii#</cfoutput> done.
	<br /> 
</cfloop>


