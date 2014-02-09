<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Unbenannt</title>
</head>
<body>
<cfparam name="url.key" type="string">
<cfparam name="url.id" type="numeric">

<cfset AID = val(url.id)>
<cfset AKey = url.key>

<cfquery name="q_select_attachment" username="u_filestorage" password="insert" datasource="myMailAttachments" dbtype="ODBC">
select dbid,contenttype,filename from bigfiles where id = #val(AID)#
and (randomkey = '#url.key#');
</cfquery>

<cfif q_select_attachment.recordcount is 0>
	Diese Datei existiert nicht oder wurde vom Benutzer bereits gelöscht.
	<cfabort>
</cfif>

<!--- attachment ausliefern --->

<!--- mit dem userquota gegenrechnen --->
<cfif fileexists("\\213.229.30.103\mysql\#q_select_attachment.dbid##AID#")>
	<cffile action="DELETE" file="\\213.229.30.103\mysql\#q_select_attachment.dbid##AID#">
</cfif>

<!--- dateien laden --->
<cfquery name="q_select_attachment" username="u_filestorage" password="insert" datasource="myMailAttachments" dbtype="ODBC">
select filecontent  INTO DUMPFILE  "/var/mysql_out/#q_select_attachment.dbid##AID#"
from bigfiles
where (dbid = #q_select_attachment.dbid#)
and (randomkey = '#AKey#') and (id = #AID#);
</cfquery>


<cfset AContentType = #q_select_attachment.contenttype#>

<cffile action="COPY" source="\\213.229.30.103\mysql\#q_select_attachment.dbid##Aid#" destination="c:\temp\#q_select_attachment.dbid##Aid#">
<cffile action="DELETE" file="\\213.229.30.103\mysql\#q_select_attachment.dbid##Aid#">

<cflocation addtoken="No" url="../../../storage/startdownload.cfm?id=#q_select_attachment.dbid##Aid#&filename=#urlencodedformat(q_select_attachment.filename)#&contenttype=#urlencodedformat(AContenttype)#">
</body>
</html>
