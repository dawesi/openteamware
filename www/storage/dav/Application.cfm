<!--- //

	Component:	Service
	Function:	Function
	Description:
	
	Header:	

	
	
	Necessary Apache directive:
	
	RewriteEngine On
    RewriteRule ^/webdav/(.*) /storage/dav/dav.cfm%{REQUEST_URI} [PT]

	
// --->

<cfapplication name="ibx_webdav_server" setclientcookies="true" clientmanagement="true">

<cfinclude template="/common/app/app_global.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<cferror type="EXCEPTION" template="inc/error.cfm" mailto="feedback@openTeamWare.com">

