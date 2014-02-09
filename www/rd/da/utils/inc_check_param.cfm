
<cfif NOT StructKeyExists(url, 'clientkey')>
	<cfabort>
</cfif>

<cfif NOT StructKeyExists(url, 'appkey')>
	<cfabort>
</cfif>