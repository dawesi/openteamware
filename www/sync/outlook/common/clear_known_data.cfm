<?xml version="1.0" encoding="utf-8"?>

<cfif NOT StructKeyExists(session, 'stSecurityContext')>
	<cfabort>
</cfif>

<!--- // clear all known information about an outlook install // --->

<!--- which datatypes? if empty, clear all --->
<cfparam name="url.datatypes" type="string" default="">

<!--- program id --->
<cfparam name="url.PROGRAM_ID" type="string" default="">

<!--- check if the program_id goes along with the userkey --->
<cfinclude template="queries/q_select_check_program_id_userkey.cfm">

<cfif q_select_check_program_id_userkey.count_id IS 0>
	<cfabort>
</cfif>

<cfif Len(url.datatypes) IS 0>
	<cfset url.datatypes = '1,2,3,5'>
</cfif>

<cfloop from="1" to="#Len(url.datatypes)#" index="ii">
	<!--- loop --->
	<cfset a_str_int_datatype = Mid(url.datatypes, ii, 1)>
	<cfset a_str_servicekey = ''>
	
	<cfswitch expression="#a_str_int_datatype#">
		<cfcase value="1">
			<!--- kalendar --->
			<cfset a_str_servicekey = '5222B55D-B96B-1960-70BF55BD1435D273'>
		</cfcase>
		
		<cfcase value="2">
			<!--- adressbuch --->
			<cfset a_str_servicekey = '52227624-9DAA-05E9-0892A27198268072'>
		</cfcase>
		
		<cfcase value="3">
			<!--- tasks --->
			<cfset a_str_servicekey = '52230718-D5B0-0538-D2D90BB6450697D1'>
		</cfcase>
		
		<cfcase value="5">
			<!--- notes --->
			<cfset a_str_servicekey = '522325E3-E2D5-DD8F-BE9F72004234BA83'>
		</cfcase>
	</cfswitch>
	
	<cfinvoke component="/components/sync/outlook/cmp_sync" method="ClearSavedOutlookEntrykeys" returnvariable="a_bol_return">
		<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
		<cfinvokeargument name="servicekey" value="#a_str_servicekey#">
		<cfinvokeargument name="program_id" value="#url.program_id#">
	</cfinvoke>

</cfloop>

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="123" type="html">
<cfdump var="#url#">
<cfdump var="#session#">
</cfmail>