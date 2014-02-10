<!--- //

	Module:		Logging
	Description: 
	

// --->
<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="CreateLogEntry" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true" default="userkey">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="sectionkey" type="string" required="false" default="">
		<cfargument name="entrykey" type="string" required="true" default="entrykey of object">
		<cfargument name="performedaction" type="string" required="true" default="read" hint="the performed action">
		<cfargument name="failed" type="numeric" default="0" required="false" hint="did the operation fail?">
		<cfargument name="additionalinformation" type="string" required="false" default="">
		
		<cfinclude template="queries/q_insert_log.cfm">
		
		<cfreturn true />
		
	</cffunction>
	
	<cffunction access="public" name="GetLogEntriesForObject" output="false" returntype="query">
		<!--- entrykey of the object --->
		<cfargument name="entrykey" type="string" required="true">
		<!--- date/time ... --->
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfinclude template="queries/q_select_log_object.cfm">
		
		<cfreturn q_select_log_object>
	
	</cffunction>
	
	<cffunction access="public" name="GetLoginLogbook" output="false" returntype="query">
		<!--- userkey ... --->
		<cfargument name="userkey" type="string" required="true">
		<!--- date/time --->
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfinclude template="queries/q_select_login_logbook.cfm">
		
		<cfreturn q_select_login_logbook>
	</cffunction>
	
	<cffunction access="public" name="SaveEditedRecordOldVersion" output="false" returntype="boolean">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="title" type="string" default="" required="false">
		<cfargument name="datakey" type="string" required="true">
		<cfargument name="query" type="query" required="true">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="newvalues" type="struct" required="no" default="#StructNew()#">
		
		<cfset var a_str_fields_changed = ''>
		<cfset var a_struct_new_data = StructNew()>
		<cfset var a_struct_old_data = StructNew()>
		
		<cfif StructCount(arguments.newvalues) GT 0>
			<cfinclude template="utils/inc_check_edited_values.cfm">
		</cfif>
		
		<cfwddx action="cfml2wddx" input="#arguments.query#" output="a_str_xml_package" usetimezoneinfo="yes">
		
		<cfinclude template="queries/q_insert_edited_data.cfm">
		
		<cfreturn true>
	</cffunction>	
	
	<cffunction access="public" name="SaveDeletedRecord" output="false" returntype="boolean">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="title" type="string" default="" required="false">
		<cfargument name="datakey" type="string" required="true">
		<cfargument name="query" type="query" required="true">
		<cfargument name="userkey" type="string" required="true">
		
		<cfwddx action="cfml2wddx" input="#arguments.query#" output="a_str_xml_package" usetimezoneinfo="yes">
		
		<cfinclude template="queries/q_insert_deleted_data.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="SimpleLog" output="false" returntype="void">
		<cfargument name="msg" type="string" default="" required="false">
		
		<cflog application="false" file="ib_simple_log" text="#arguments.msg#" type="information" log="Application">
	</cffunction>
	
	<cffunction access="public" name="LogException" output="false" returntype="string"
			hint="log an exception and return the UUID of the exception">
		<cfargument name="message" default="" required="false" type="string"
			hint="simple error message">
		<cfargument name="args" default="#StructNew()#" required="false"
			hint="arguments">
		<cfargument name="url" default="#StructNew()#" required="false"
			hint="url struct">
		<cfargument name="cgi" default="#StructNew()#" required="false"
			hint="cgi struct">
		<cfargument name="session" default="#StructNew()#" required="false"
			hint="session struct">
		<cfargument name="error" required="true"
			hint="the exception information (cferror / cfcatch)">
		<cfargument name="form" required="false" default="#StructNew()#"
			hint="form vars">
			
		<cfset var sEntrykey = CreateUUID() />
		<cfset var inet = CreateObject("java", "java.net.InetAddress") />
		<cfset inet = inet.getLocalHost() />
			
		<cfinclude template="queries/q_insert_exception.cfm">
		
		<cfreturn sEntrykey />
	</cffunction>
	
	<cffunction access="public" name="GetCommissiongoodsHistory" output="false" returntype="query">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="userkey" type="string" required="no" default="">
		
		<cfinclude template="queries/q_select_commissiongoods_history.cfm">
		
		<cfreturn q_select_commissiongoods_history>
		
	</cffunction>
</cfcomponent>


