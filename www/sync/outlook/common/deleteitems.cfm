<?xml version="1.0" encoding="utf-8"?>
<!--- //

	submit outlook ids of entries which have to be deleted
	<io>
		<in>
			<param scope="form" name="datatype" type="integer" default="0">
				<description>
				where to delete the items
				
				1 =
				2 =
				3 =
				5 =
				
				</description>
			</param>
			
			<param scope="form" name="outlook_ids" type="string"default="">
				<description>
				the outlook ids of the items to delete
				</description>
			</param>
			
			<param scope="form" name="program_id" type="string"default="">
				<description>
				id of program
				</description>
			</param>			
	</io>
	
// --->
<cfparam name="form.datatype" default="" type="string">
<cfparam name="form.outlook_ids" default="" type="string">
<cfparam name="form.program_id" default="" type="string">

<cfswitch expression="#form.datatype#">
	<cfcase value="3">
		<cfset a_str_servicekey = '52230718-D5B0-0538-D2D90BB6450697D1'>
	</cfcase>
	<cfcase value="2">
		<cfset a_str_servicekey = '52227624-9DAA-05E9-0892A27198268072'>
	</cfcase>
	<cfcase value="1">
		<!--- calendar --->
		<cfset a_str_servicekey = '5222B55D-B96B-1960-70BF55BD1435D273'>
	</cfcase>
	<cfcase value="5">
		<cfset a_str_servicekey = '522325E3-E2D5-DD8F-BE9F72004234BA83'>
	</cfcase>
	<cfdefaultcase>
		<cfset a_str_servicekey = ''>
	</cfdefaultcase>
</cfswitch>

<cfinvoke component="/components/sync/outlook/cmp_sync" method="DeleteData" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="servicekey" value="#a_str_servicekey#">
	<cfinvokeargument name="program_id" value="#form.program_id#">
	<cfinvokeargument name="outlook_ids" value="#form.outlook_ids#">
</cfinvoke>

<result>
	<done/>
</result>