<?xml version="1.0" encoding="utf-8"?>

<cfif NOT StructKeyExists(session, 'stSecurityContext')>
	<cflocation addtoken="No" url="../notloggedin.xml">
</cfif>

<!--- //

	load the list of items ... 
	
	xml fields:
	
	id: integer ... id of entry in the system
	outlook_id string(255): outlook-id (maybe empty if new entry!)
	lastmod ... string(50) ... last modification date
	
	input fields
	
	<io>
		<in>
			<param scope="url" name="donotmixoutlookversion" type="integer" default="0">
				<description>
				if 0, do not send back items of other outlook versions
				if 1, the user wants to synchronize other outlook versions too
				</description>
			</param>
			
			<param scope="url" name="program_id" type="string" length="255" default="0">
				<description>
				The outlook program id
				</description>
			</param>
			
			<param scope="url" name="startmoddate" type="string" subtype="date" default="">
				<description>
				from which date on should we load the data (lastmodification date)
				these items and new items are loaded
				</description>
			</param>
			
			<param scope="url" name="itemtype" type="numeric" default="-1">
				<description>
				The item type of which we want to have information
				
				1 Kalender
				2 Kontakte				
				3 Aufgaben
				5 Notizen
				
				</description>			
			</param>
				
		</in>
	
	</io>

	// --->
	
<cfparam name="url.program_id" type="string" default="">
<cfparam name="url.donotmixoutlookversion" type="numeric" default="1">
<cfparam name="url.startmoddate" type="string" default="">
<cfparam name="url.itemtype" type="numeric" default="-1">

<!--- no date given -> exit --->
<cfif Len(url.startmoddate) is 0><cfabort></cfif>

<cfif url.itemtype is -1><cfabort></cfif>

<cfif Len(url.program_id) is 0><cfabort></cfif>
	
<!--- load query ...the exact query depends on the url.itemtype variable --->
<cfswitch expression="#url.itemtype#">
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


<cfinvoke component="/components/sync/outlook/cmp_sync" method="GetOutlookMetaData" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="program_id" value="#url.program_id#">
	<cfinvokeargument name="servicekey" value="#a_str_servicekey#">
	<cfinvokeargument name="startmoddate" value="#url.startmoddate#">
</cfinvoke>

<cfset q_select_meta_data = stReturn.q_select_meta_data>

<!---<cfif IsDate(url.startmoddate)>
	<cfif request.stSecurityContext.myuserid is 2>
	
		<cfquery name="q_select_meta_data" dbtype="query">
		SELECT
			*
		FROM
			q_select_meta_data
		WHERE
			dt_lasttimemodified IS NULL
			OR
			dt_lasttimemodified >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(url.startmoddate)#">
		;
		</cfquery>
		
	</cfif>
</cfif>--->

<results recordcount="<cfoutput>#q_select_meta_data.recordcount#</cfoutput>">
<cfoutput query="q_select_meta_data">

	<cfset a_dt_lastmod = TRIM(DateFormat(q_select_meta_data.dt_lasttimemodified, "dd.mm.yyyy")&" "&TimeFormat(q_select_meta_data.dt_lasttimemodified, "HH:mm:ss"))>

	<result>
	<inboxcc_entrykey>#xmlformat(q_select_meta_data.entrykey)#</inboxcc_entrykey>
	<!---<readonly>#a_str_ro#</readonly>--->
	<outlook_id>#xmlformat(q_select_meta_data.outlook_id)#</outlook_id>
	<lastmod>#xmlformat(a_dt_lastmod)#</lastmod>
	<title>#urlencodedformat(trim(q_select_meta_data.title), 'ISO-8859-1')#</title>
	<hash>#hash(q_select_meta_data.hashvalue)#</hash>
	</result>
</cfoutput>
</results>