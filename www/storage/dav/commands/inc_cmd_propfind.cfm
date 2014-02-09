<!--- //

	Module:		WebDAV
	Description:PROPFIND command
	

// --->


<cfheader statuscode="207" statustext="Information available">
<cfcontent type="text/xml; charset=utf-8">
<cfheader name="ContentEncoding" value="chunked">

<cfxml variable="a_obj_xml">
<a:multistatus xmlns:b="urn:uuid:c2f41010-65b3-11d1-a29f-00aa00c14882/" xmlns:c="xml:" xmlns:a="DAV:">
<a:response>
<a:href>/webdav/</a:href> 
<a:propstat>
<a:status>HTTP/1.1 200 OK</a:status> 
<a:prop>
<a:getcontentlength b:dt="int">0</a:getcontentlength> 
<a:creationdate b:dt="dateTime.tz">2003-03-27T15:39:16.412Z</a:creationdate> 
<a:displayname>/</a:displayname> 
<a:getetag>"4e3a5f4d364c31:526c0"</a:getetag> 
<a:getlastmodified b:dt="dateTime.rfc1123">Wed, 16 Apr 2003 16:36:16 GMT</a:getlastmodified> 
<a:resourcetype>
<a:collection /> 
</a:resourcetype>
<a:supportedlock /> 
<a:ishidden b:dt="boolean">0</a:ishidden> 
<a:iscollection b:dt="boolean">1</a:iscollection> 
<a:getcontenttype /> 
</a:prop>
</a:propstat>
</a:response>
</a:multistatus>
</cfxml>

<cfoutput>#ToString(a_obj_xml)#</cfoutput>

<cfset a_request_body = GetHttpRequestData().content />

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="dav req" type="html">
<cfdump var="#cgi#">
<cfdump var="#a_request_body#">
<cfdump var="#a_obj_xml#">
</cfmail>

