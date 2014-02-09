<?xml version="1.0" encoding="utf-8"?>
<!--- //
	upload data and set the action
	<io>
		<in>
			<param scope="form" name="datatype" type="integer" default="0">
				<description>
				where to delete the items
				
				1 = appointments
				2 = contacts
				3 = tasks
				5 = notes
				
				</description>
			</param>
			
			<param scope="form" name="xml_gzipped" type="string" default="">
				<description>
				gzipped version of the xml file
				</description>
		</param>
		
			<param scope="form" name="action" type="integer" default="0">
				<description>
				what to do
				
				1 = add
				10 = update
				</description>
			</param>			
	</io>
	
	// --->
	
<cfparam name="form.datatype" default="0" type="numeric">
<cfparam name="form.xml_gzipped" default="" type="string">
<cfparam name="form.program_id" default="" type="string">

<cfset sFilename_Destination = request.a_str_temp_dir_outlooksync&CreateUUID()&".gz">

<cffile action="upload" filefield="filename" destination="#sFilename_Destination#" nameconflict="makeunique">

<cfset sFilename_outfile = request.a_str_temp_dir_outlooksync&createuuid()&".xml">

<!--- gunzip --->
<cfexecute name="gunzip" arguments="-c #sFilename_Destination#" outputfile="#sFilename_outfile#" timeout="30"></cfexecute>

<cffile action="read" file="#sFilename_outfile#" variable="a_str_xml">

<cfinvoke
	component="components/cmp_createstructfromxml"
	method="createstructurefromxml"
	returnvariable="a_array_return">
	<cfinvokeargument name="str_xml" value="#a_str_xml#">
</cfinvoke>

<cfswitch expression="#form.datatype#">
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
	
	<cfdefaultcase>
		<cfset a_str_servicekey = ''>
	</cfdefaultcase>

</cfswitch>

<cfinvoke component="/components/sync/outlook/cmp_sync" method="UpdateData" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="program_id" value="#form.program_id#">
	<cfinvokeargument name="servicekey" value="#a_str_servicekey#">
	<cfinvokeargument name="data" value="#a_array_return#">
</cfinvoke>

<result/>