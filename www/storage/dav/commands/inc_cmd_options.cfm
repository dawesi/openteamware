<!--- //

	Module:		WEBDAV Service
	Description:OPTIONS command
	

// --->

<cfcontent type="text/plain">

<cfheader name="Allow" value="OPTIONS,GET,HEAD,POST,DELETE,TRACE,PROPFIND,PROPPATCH,COPY,MOVE,PUT,LOCK,UNLOCK">
<cfheader name="DAV" value="1,2,<http://apache.org/dav/propset/fs/1>">

