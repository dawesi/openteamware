<!--- //

	Component:	Followups
	Description:Manage followups
	

// --->

<cfcomponent output="false">
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction access="public" name="CreateFollowup" returntype="struct" output="false">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkey" type="string" required="yes">
		<cfargument name="objecttitle" type="string" required="no" default="">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="createdbyuserkey" type="string" required="yes">
		<cfargument name="dt_due" type="date" required="yes">
		<cfargument name="subject" type="string" required="false" default=""
			hint="subject of follow up job, to be removed in future">
		<cfargument name="comment" type="string" required="no" default=""
			hint="comment?">
		<cfargument name="alert_email" type="numeric" default="0" required="no"
			hint="alert by email?">
		<cfargument name="priority" type="numeric" default="3" required="no"
			hint="item type">
		<cfargument name="type" type="numeric" default="0" required="no"
			hint="item type">
		<cfargument name="categories" type="string" default="" required="false"
			hint="categories to apply to item">
		
		<cfset var stReturn = GenerateReturnStruct() />
		
		<cfif (Len(arguments.entrykey) IS 0) OR (Len(arguments.servicekey) IS 0) OR
			  (Len(arguments.objectkey) IS 0)>
			<cfreturn SetReturnStructErrorCode(stReturn, 123) />
		</cfif>

		<!--- insert follow up ... --->
		<cfinclude template="queries/q_insert_follow_up.cfm">
		
		<!--- update activity index of contact ... --->
		<cfset application.components.cmp_crmsales.UpdateActivityCountOfContact(objectkey = arguments.objectkey,
																		servicekey = arguments.servicekey,
																		itemtype = 'followups') />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<cffunction access="public" name="DeleteFollowup" returntype="boolean" output="false">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		
		<cfinclude template="queries/q_delete_follow_up.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="DisplayShortFollowupInfos" output="false" returntype="struct"
		hint="display short information about followups e.g. in the email area">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkeys" type="string" required="yes">
		<cfargument name="highlight" type="boolean" required="no" default="true">
		
		<cfset var stReturn = StructNew()>
		<cfset stReturn.content = ''>
		<cfset stReturn.result = false>
		
		<cfinclude template="utils/inc_display_short_followup_infos.cfm">
		
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="UpdateFollowup" returntype="boolean" output="false">
		<cfargument name="entrykey" type="string" required="yes"
			hint="entrykey of fwup item">
		<cfargument name="objectkey" type="string" required="false" default=""
			hint="entrykey of object item">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="newvalues" type="struct" required="no" default="#StructNew()#">
		
		<cfset var tmp = false />
		<cfset var q_update_followup = 0 />
		
		<cfinclude template="queries/q_update_followup.cfm">
		
		<cfset application.components.cmp_crmsales.UpdateActivityCountOfContact(objectkey = arguments.objectkey,
																		servicekey = '52227624-9DAA-05E9-0892A27198268072',
																		itemtype = 'followups') />
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="GetFollowup" returntype="struct" output="false"
			hint="return a single follow up item">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of the follow up item">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_follow_up = 0 />
		
		<!--- TODO hp: check security ... --->
		
		<cfinclude template="queries/followups/q_select_follow_up.cfm">
		
		<cfset stReturn.q_select_follow_up = q_select_follow_up />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
			
	</cffunction>
	
	<cffunction access="public" name="GetFollowUps" returntype="query" output="false">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkeys" type="string" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="filter" type="struct" default="#StructNew()#">
		
		<cfinclude template="queries/q_select_follow_ups.cfm">
		
		<cfreturn q_select_follow_ups>
		
	</cffunction>
	
	<cffunction access="public" name="CreateUpdateFollowup" returntype="struct" output="false"
			hint="Create or update a follow up item">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="action_type" type="string" default="create" required="true"
			hint="create or update">
		<cfargument name="database_values" type="struct" required="true"
			hint="structure with values ...">
		<cfargument name="all_values" type="struct" required="true"
			hint="various other variables">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_struct_do_action = StructNew() />
		<cfset var sEntrykey = CreateUUID() />
		<cfset var a_update_item = 0 />
		<cfset var tmp = 0 />
		
		<cfif arguments.action_type IS 'create'>
		
			<!--- create ... --->
			<cfset a_struct_do_action = CreateFollowup(entrykey = CreateUUID(),
											servicekey = arguments.database_values.servicekey,
											objectkey = arguments.database_values.objectkey,
											objecttitle = arguments.database_values.objecttitle,
											userkey = arguments.database_values.userkey,
											createdbyuserkey = arguments.securitycontext.myuserkey,
											dt_due = arguments.database_values.dt_due,
											userkey = arguments.database_values.userkey,
											comment = arguments.database_values.comment,
											alert_email = val(arguments.database_values.alert_email),
											priority = arguments.database_values.priority,
											type = arguments.database_values.followuptype,
											categories = arguments.database_values.categories) />			
		<cfelse>
		
			<!--- update ... --->
			<cfquery name="followup">
			UPDATE	followup
			SET		comment	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.comment#" />,
					dt_due	= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.database_values.dt_due#" />,
					followuptype	= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.database_values.followuptype#" />,
					userkey			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.userkey#">
					alert_email= <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(arguments.database_values.alert_email)#">,
					priority	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(arguments.database_values.priority)#">,
					categories = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.categories#">
			WHERE	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.entrykey#" />
			</cfquery>
			
		</cfif>
		
		<cfset application.components.cmp_crmsales.UpdateActivityCountOfContact(objectkey = arguments.database_values.objectkey,
																		servicekey = arguments.database_values.servicekey,
																		itemtype = 'followups') />
	
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
</cfcomponent>

