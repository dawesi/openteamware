<!--- //

	Module:		OutlookSync routines
	Action:		
	Description:	
	

// --->
<cfcomponent output='false'>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="GetOutlookMetaData" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="program_id" type="string" required="true">
		<cfargument name="startmoddate" type="string" required="no" default="">
		
		<!---<cflog text="servicekey: #arguments.servicekey#" type="Information" log="Application" file="ib_ws">--->
				
		<cfset var stReturn = StructNew()>
		
		<!---<cflog text="structure created" type="Information" log="Application" file="ib_ws">--->
		
		
		<!--- select now "real" workgroups --->
		<cfset var q_select_workgroup_permissions = arguments.securitycontext.q_select_workgroup_permissions>
		
		<!---<cflog text="setting query" type="Information" log="Application" file="ib_ws">--->
		
		<cfquery name="q_select_workgroup_permissions" dbtype="query">
		SELECT
			*
		FROM
			q_select_workgroup_permissions
		WHERE
			inherited_membership = 0
		;
		</cfquery>
		
		<!---<cflog text="queried" type="Information" log="Application" file="ib_ws">--->
		
		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
				<!--- calendar --->				
				<cfinclude template="queries/q_select_cal_meta_data.cfm">
				<cfset stReturn.q_select_meta_data = q_select_cal_meta_data>
			</cfcase>
			
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
				<!--- address book --->
				<cfinclude template="queries/q_select_addressbook_meta_data.cfm">
				<cfset stReturn.q_select_meta_data = q_select_addressbook_meta_data> 
			</cfcase>
			
			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
				<!--- tasks --->
				<cfinclude template="queries/q_select_tasks_meta_data.cfm">
				<cfset stReturn.q_select_meta_data = q_select_tasks_meta_data>
			</cfcase>
			
		</cfswitch>
		
		<cfreturn stReturn>
	
	</cffunction>
	
	<cffunction access="public" name="SetNewOutlookMetaData" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="program_id" type="string" required="true">	
		<cfargument name="metadata" type="array" required="true">
				
		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
			<!--- tasks --->
			<cfinclude template="utils/inc_update_tasks_meta_information.cfm">
			</cfcase>
			
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
			<!--- adress book --->
			<cfinclude template="utils/inc_update_contacts_meta_data.cfm">
			</cfcase>
			
			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
			<!--- calendar --->
			<cfinclude template="utils/inc_update_calendar_meta_data.cfm">
			</cfcase>
			
			<cfcase value="522325E3-E2D5-DD8F-BE9F72004234BA83">
			<!--- notes --->
			<cfinclude template="utils/inc_update_scratchpad_meta_data.cfm">
			</cfcase>
			
		</cfswitch>
		
		<cfreturn true>
	</cffunction>
	
	<!--- meta data exists? --->
	<cffunction access="public" name="MetaItemExists" output="false" returntype="boolean">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="program_id" type="string" required="true">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfinclude template="queries/q_select_meta_item_exists.cfm">
		
		<cfreturn (q_select_meta_item_exists.count_id IS 1)>
	</cffunction>
	
	<!--- update data --->
	<cffunction access="public" name="UpdateData" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="program_id" type="string" required="true">
		<cfargument name="data" type="array" required="true">
		
		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
			<!--- tasks --->
			<cfinclude template="utils/inc_update_tasks.cfm">
			</cfcase>
			
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
			<!--- adress book --->
			<cfinclude template="utils/inc_update_contacts.cfm">
			</cfcase>
			
			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
			<!--- calendar --->
			<cfinclude template="utils/inc_update_calendar.cfm">
			</cfcase>
			
			<cfcase value="522325E3-E2D5-DD8F-BE9F72004234BA83">
			<!--- notes --->
			<cfinclude template="utils/inc_update_scratchpad.cfm">
			</cfcase>
		</cfswitch>
		
		<cfreturn true>	
	</cffunction>
	
	<!--- create data --->
	<cffunction access="public" name="CreateData" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="program_id" type="string" required="true">
		<cfargument name="data" type="array" required="true">
		
		<cfset var a_array_return = arguments.data>
		
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="create data" type="html">
			<html>
				<body>
					<cfdump var="#arguments#">
				</body>				
			</html>
		</cfmail>--->
		
		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
			<!--- tasks --->
			<cfinclude template="utils/inc_create_tasks.cfm">
			</cfcase>
			
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
			<cfinclude template="utils/inc_create_contacts.cfm">
			</cfcase>
			
			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
			<cfinclude template="utils/inc_create_calendar.cfm">
			</cfcase>
			
			<cfcase value="522325E3-E2D5-DD8F-BE9F72004234BA83">
			<cfinclude template="utils/inc_create_scratchpad.cfm">
			</cfcase>
		</cfswitch>		
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="DeleteData" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true">
		<cfargument name="program_id" type="string" required="true">	
		<cfargument name="outlook_ids" type="string" required="true">
		
		<cfset var a_struct_settings = 0 />
		
		<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
			<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
		</cfinvoke>
		
		<cfset arguments.stUserSettings = a_struct_settings>		

		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
			<!--- tasks --->
			<cfinclude template="utils/inc_delete_data_tasks.cfm">
			</cfcase>
			
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
			<!--- contacts --->
			<cfinclude template="utils/inc_delete_data_contacts.cfm">
			</cfcase>
			
			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
			<!--- calendar --->
			<cfinclude template="utils/inc_delete_data_calendar.cfm">
			</cfcase>
			
			<cfcase value="522325E3-E2D5-DD8F-BE9F72004234BA83">
			<!--- notes --->
			<cfinclude template="utils/inc_delete_notes.cfm">
			</cfcase>
		</cfswitch>
		
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="deletedata" type="html">
			<cfdump var="#arguments#">
		</cfmail>--->
		
		<cfreturn true>
	</cffunction>
	
	<!---

		delete the saved outlook entrykeys to allow a new total sync
		
		--->
	<cffunction access="public" name="ClearSavedOutlookEntrykeys" returntype="boolean" output="false">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="program_id" type="string" required="yes">
		<cfargument name="servicekey" type="string" required="yes">
		
		<cfset var q_select_meta_data_outlook_entrykeys = 0 />
		<cfset var q_select_tasks_meta_data_outlook_entrykeys = 0 />
		<cfset var q_select_contacts_meta_data_outlook_entrykeys = 0 />
		<cfset var q_select_calendar_meta_data_outlook_entrykeys = 0 />
		
		<cfif Len(arguments.servicekey) IS 0>
			<cfreturn false>
		</cfif>
		
		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
				<!--- tasks --->
				<cfinclude template="queries/q_select_tasks_meta_data_outlook_entrykeys.cfm">
				
				<cfset q_select_meta_data_outlook_entrykeys = q_select_tasks_meta_data_outlook_entrykeys>
				
				<!--- delete data --->
				<cfinclude template="queries/q_delete_meta_data_tasks_outlook_entrykeys.cfm">
			</cfcase>
			
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
				<!--- contacts --->
				<cfinclude template="queries/q_select_contacts_meta_data_outlook_entrykeys.cfm">
				
				<cfset q_select_meta_data_outlook_entrykeys = q_select_contacts_meta_data_outlook_entrykeys>
				
				<!--- delete meta data --->
				<cfinclude template="queries/q_delete_meta_data_contacts_outlook_entrykeys.cfm">
			</cfcase>
			
			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
				<!--- calendar --->
				<cfinclude template="queries/q_select_calendar_meta_data_outlook_entrykeys.cfm">
				<cfset q_select_meta_data_outlook_entrykeys = q_select_calendar_meta_data_outlook_entrykeys>
				
				<cfinclude template="queries/q_delete_meta_data_calendar_outlook_entrykeys.cfm">
			</cfcase>
			
			<cfcase value="522325E3-E2D5-DD8F-BE9F72004234BA83">
				<!--- notes --->
				<cfinclude template="queries/q_select_scratchpad_meta_data_outlook_entrykeys.cfm">
				<cfset q_select_meta_data_outlook_entrykeys = q_select_scratchpad_meta_data_outlook_entrykeys>
				
				<cfinclude template="queries/q_delete_meta_data_scratchpad_outlook_entrykeys.cfm">
			</cfcase>
		</cfswitch>
		

		<cfwddx input="#q_select_meta_data_outlook_entrykeys#" output="a_Str_wddx" action="cfml2wddx">
		
		<!--- // insert into log table // --->
		<cfinclude template="queries/q_insert_meta_data_outlook_entrykeys_log.cfm">

		
		<cfreturn true>
	</cffunction>

</cfcomponent>

