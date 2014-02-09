<!--- //

	set new outlook meta data

	- outlook-id
	- last modification date
	- datatype

	depending on these data we insert or update an outlook_data
	table in order to reflect the changes made online

	// --->

<cfparam name="form.program_id" default="" type="string">
<cfparam name="form.datatype" type="numeric" default="-1">

<cfif form.datatype is -1>
	<cfexit method="exittemplate">
</cfif>

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

<!--- parse xml file --->
<cfset sFilename_Destination = request.a_str_temp_dir_outlooksync&CreateUUID()&".xml">

<cffile action="upload" filefield="filename" destination="#sFilename_Destination#" nameconflict="makeunique">

<cffile action="READ" file="#sFilename_Destination#" variable="a_str_Filecontent">

<CFSET MyXml = XmlParse(a_str_Filecontent)>
<CFSET xnResults = MyXML.XmlRoot>

<cfset a_arr_meta = ArrayNew(1)>

<cfloop index="a_int_index_ii" from="1" to="#ArrayLen(xnResults.XmlChildren)#">

	<cfset A_str_Outlook_id = "">
	<cfset A_str_Lastmodified = "">
	<cfset a_str_itemttype = "">
	<cfset a_str_inboxcc_entrykey = "">
	
	<cfset a_int_arr = ArrayLen(a_arr_meta)+1>
	<cfset a_arr_meta[a_int_arr] = StructNew()>

	<cfset xnUpdateItem = xnResults.XmlChildren[a_int_index_ii]>


	<!--- loop through entry part --->
	<cfloop index="a_int_index_jj" from="1" to="#ArrayLen(xnUpdateItem.XMLChildren)#">

		<cfset xnUpdateEntry = xnUpdateItem.XmlChildren[a_int_index_jj]>
			<!--- get data --->
			<cfswitch expression="#xnUpdateEntry.xmlname#">
				<cfcase value="lastmod">
					<cfset A_str_Lastmodified = urldecode(xnUpdateEntry.xmltext)>
				</cfcase>
				<cfcase value="itemtype">
					<cfset a_str_itemttype = urldecode(xnUpdateEntry.xmltext)>
				</cfcase>
				<cfcase value="Outlook_id">
					<cfset A_str_Outlook_id = urldecode(xnUpdateEntry.xmltext)>
				</cfcase>
				<cfcase value="inboxcc_entrykey">
					<cfset a_str_inboxcc_entrykey = urldecode(xnUpdateEntry.xmltext)>
				</cfcase>
			</cfswitch>

	</cfloop>

	<!--- parse date / time in order to create a datetime object --->
	<cfset a_dt_lastmod = LsParseDateTime(A_str_Lastmodified)>
	
	<cfset a_arr_meta[a_int_arr].a_dt_lastmod = a_dt_lastmod>
	<cfset a_arr_meta[a_int_arr].a_str_outlook_id = A_str_Outlook_id>	
	<cfset a_arr_meta[a_int_arr].a_str_inboxcc_entrykey = a_str_inboxcc_entrykey>	
	
</cfloop>

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="UPDATE META INFORMATION" type="html">
<cfdump var="#a_arr_meta#">
</cfmail>--->
<!---
	1 = appointments
	2 = contacts
	3 = tasks
	5 = notes--->
				
<!--- invoke component ... --->
<cfinvoke component="/components/sync/outlook/cmp_sync" method="SetNewOutlookMetaData" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="servicekey" value="#a_str_servicekey#">
	<cfinvokeargument name="program_id" value="#form.program_id#">
	<cfinvokeargument name="metadata" value="#a_arr_meta#">
</cfinvoke>


<xml>
	<return/>
</xml>