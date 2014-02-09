


<form action="request.cfm" method="Post" enctype="application/x-www-form-urlencoded">

XMLRequest: <textarea name="XMLRequest" cols=70 rows=15>
</textarea>
<p>
StylesheetURL: <input name="StyleSheetURL" value="" size=70/>
<p>
DataURL:   <input name="DataURL" value="" size=70/>
<p>

<input type="submit">

</form>

<cfif cgi.REQUEST_METHOD IS 'POST'>
		
	<cfhttp url="http://toolbox.openTeamWare.com:8080/services/signature/trustdesk.cfm" method="post" delimiter="," port="3495" resolveurl="no">
		<cfhttpparam type="formfield" name="XMLRequest" value="#form.XMLRequest#">
	</cfhttp>

	<cfdump var="#cfhttp.FileContent#">
</cfif>