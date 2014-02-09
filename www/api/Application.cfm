<cfapplication name="ib_app_ws" clientmanagement="yes" sessionmanagement="yes" setclientcookies="yes" setdomaincookies="no" clientstorage="mysession">

<!--- n/a yet --->
<cfabort>

<cferror type="exception" template="exception.cfm">
<cfinclude template="/common/app/app_global.cfm">

<cfset request.a_tc_begin = GetTickCount()>

<cfset request.a_str_request_uuid = CreateUUID()>

<cfset request.a_str_app_key = ''>

<!---<cfif StructKeyExists(arguments, 'applicationkey')>--->
<!---	<cfset request.a_str_app_key = arguments.applicationkey>--->
<!---</cfif>--->

<cfinclude template="log/inc_log_request.cfm">



