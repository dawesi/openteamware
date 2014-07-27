<!--- //

	Component:     Forum
	
	Parameters

// --->
<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction access="public" name="GetLatestPostingsOfForum" output="false" returntype="query">


	</cffunction>
	
	<cffunction access="public" name="GetForumNameByEntrykey" output="false" returntype="string">
		<cfargument name="entrykey" type="string" required="yes">		
		<cfinclude template="queries/q_select_forum_name_by_entrykey.cfm">		
		<cfreturn q_select_forum_name_by_entrykey.forumname>
	</cffunction>

	<cffunction access="public" name="SelectNewestPostings" output="false" returntype="query">
		<cfargument name="forenkeys" type="string" required="yes">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="maxage_days" type="numeric" default="14" hint="max age of articles">
		<cfargument name="max_rows" type="numeric" default="10">
		
		<cfset var q_select_newest_postings = 0 />
		
		<cfinclude template="queries/q_select_newest_postings.cfm">
		<cfreturn q_select_newest_postings />
	</cffunction>

	<cffunction access="public" name="CloseThread" output="false" returntype="boolean" hint="allow no further articles">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="threadkey" type="string" required="yes">
	
	</cffunction>
	
	<cffunction access="public" name="GetRawPosting" output="false" returntype="query" hint="return just a specified posting">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of posting">
		<cfargument name="forumkey" type="string" required="yes">
		<cfinclude template="queries/q_select_raw_posting.cfm">
		<cfreturn q_select_raw_posting>
	</cffunction>

	<cffunction access="public" name="DeletePosting" output="false" returntype="boolean" hint="delete a posting">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of posting">
		<cfargument name="forumkey" type="string" required="yes">

		<cfset var a_bol_return = false />
		<cfset var a_bol_is_moderator = IsModeratorOfForum(securitycontext = arguments.securitycontext, forumkey = arguments.forumkey) />

		<cfif NOT a_bol_is_moderator>
			<cfreturn false />
		</cfif>
	
		<cfset q_select_raw_posting = GetRawPosting(securitycontext = arguments.securitycontext, forumkey = arguments.forumkey, entrykey = arguments.entrykey) />
	
		<cfinclude template="queries/q_insert_deleted_posting.cfm">
		<cfinclude template="queries/q_delete_posting.cfm">

		<cfif Len(q_select_raw_posting.parentpostingkey) GT 0>
			<cfset UpdatePostingCount(q_select_raw_posting.parentpostingkey) />
		</cfif>

		<cfreturn a_bol_return />
	</cffunction>

	<cffunction access="public" name="GetForumProperties" output="false" returntype="query" hint="return forum properties query">
		<cfargument name="entrykey" type="string" required="yes">
		<cfinclude template="queries/q_select_forum.cfm">
		<cfreturn q_select_forum>
	</cffunction>

	<cffunction access="public" name="IsModeratorOfForum" output="false" returntype="boolean" hint="check if company admin">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="forumkey" type="string" required="yes">
		
		<cfset var a_bol_return = false />
		
		<cfif arguments.securitycontext.iscompanyadmin>
			<!--- user is admin, so check rights ... --->
			<cfset a_bol_return = application.components.cmp_customer.CheckCompanyAdminRightAvailable(
												userkey = arguments.securitycontext.myuserkey,
												companykey = arguments.securitycontext.mycompanykey,
												permissionname = 'forumadmin')>
		</cfif>

		<cfif NOT a_bol_return>
			<!--- defined as explicit moderator for this forum? ... --->
			<cfinclude template="queries/q_select_is_explicit_moderator.cfm">
			<cfset a_bol_return = (q_select_is_explicit_moderator.count_id IS 1) />
		</cfif> 
		
		<cfreturn a_bol_return />
	</cffunction>

	<cffunction access="public" name="CreateForum" output="false" returntype="boolean">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="createdbyuserkey" type="string" required="yes">
		<cfargument name="workgroupkeys" type="string" required="true">
		<cfargument name="companynews_forum" type="numeric" default="0" required="no" hint="company news forum (0/1)">
		<cfargument name="admin_post_only" type="numeric" default="0" required="no" hint="are only admins allowed to post news?">
		
		<cfset var q_insert_forum = 0 />
		
		<!--- is company admin? --->
		
		<cfinclude template="queries/q_insert_forum.cfm">
		
		<cfloop list="#arguments.workgroupkeys#" delimiters="," index="a_str_workgroupkey">
			<cfinvoke component="cmp_forum" method="AddWorkgroupToForum" returnvariable="a_bol_return">
				<cfinvokeargument name="forumkey" value="#arguments.entrykey#">
				<cfinvokeargument name="workgroupkey" value="#a_str_workgroupkey#">
			</cfinvoke>
		</cfloop>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="SearchForums" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="forumkeys" type="string" required="yes">
		<cfargument name="searchfor" type="string" required="yes">
		
		<cfreturn queryNew('123')>
	</cffunction>
	
	<cffunction access="public" name="GetAllForumsOfACompany" output="false" returntype="query" hint="return all forums of a specified company">
		<cfargument name="companykey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_forums_of_a_company.cfm">
		
		<cfreturn q_select_forums_of_a_company>
		
	</cffunction>
	
	<!--- the the forums a user has permissions for .. --->
	<cffunction access="public" name="GetForumList" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfinclude template="queries/q_select_foren.cfm">
		
		<cfreturn q_select_foren>
	</cffunction>

	<cffunction access="public" name="GetForenCountForUser" output="false" returntype="numeric">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfinclude template="queries/q_select_foren_count.cfm">
		<cfreturn val(q_select_foren_count.count_id)>
	</cffunction>
	
	<cffunction access="public" name="AddWorkgroupToForum" returntype="boolean" output="false">
		<cfargument name="forumkey" type="string" required="true">
		<cfargument name="workgroupkey" type="string" required="true">
		<!--- check if item already exists --->
		<cfinclude template="queries/q_insert_workgroup_share.cfm">
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetForumPostings" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfinclude template="queries/q_select_foren_postings.cfm">
		
		<cfreturn q_select_foren_postings>
			
	</cffunction>
	
	<cffunction access="public" name="DeleteOnChangeAlert" output="false" returntype="boolean">
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="CreateOnChangeAlert" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="forumkey" type="string" required="yes">
		<cfargument name="threadkey" type="string" required="yes">
		<cfinclude template="queries/q_insert_onchange_alert.cfm">
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="CheckOnChangeAlertsToSend" output="false" returntype="boolean">
		<cfargument name="userkey_posting" type="string" required="yes" hint="the user who has created the posting">
		<cfargument name="threadkey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_article_watchers.cfm">
		
		<cfif q_select_article_watchers.recordcount GT 0>
			<cfinclude template="utils/inc_send_alert_on_change.cfm">
		</cfif>
		
		<cfreturn true>	
	</cffunction>
	
	<cffunction access="public" name="CreateOrUpdatePostingEx" output="false" returntype="struct"
			hint="create or update meta data after a create/update operation">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="action_type" type="string" default="create" required="true"
			hint="create or update">
		<cfargument name="database_values" type="struct" required="true"
			hint="structure with values ...">
		<cfargument name="all_values" type="struct" required="true"
			hint="various other variables">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_threadkey = ''>
		<cfset var a_str_parent_postingkey = arguments.all_values.frmreplytopostingkey />
		<cfset var a_str_postingkey = arguments.database_values.entrykey />
				
		<!--- update answer count ... --->
		<cfif Len(a_str_parent_postingkey) GT 0>
			<cfset UpdatePostingCount(a_str_parent_postingkey) />
		</cfif>

		<cfif Len(a_str_parent_postingkey) GT 0>
			<cfset a_str_threadkey = a_str_parent_postingkey />
		<cfelse>
			<cfset a_str_threadkey = a_str_postingkey />
		</cfif>

		<!--- update last posting ... --->
		<cfset UpdateLastPosting(forumkey = arguments.database_values.forumkey, threadkey = a_str_threadkey) />
		
		<!--- send alerts? --->
		<cfset CheckOnChangeAlertsToSend(userkey_posting = arguments.securitycontext.myuserkey, threadkey = a_str_threadkey) />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<cffunction access="public" name="UpdatePosting" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="forumkey" type="string" required="yes">
		<cfargument name="body" type="string" required="true" hint="html body">

		<cfset q_select_raw_posting = GetRawPosting(securitycontext = arguments.securitycontext, forumkey = arguments.forumkey, entrykey = arguments.entrykey)>
	
		<cfinclude template="queries/q_insert_edited_posting.cfm">
		<cfinclude template="queries/q_update_posting.cfm">

		<cfset UpdateLastPosting(forumkey = arguments.forumkey, threadkey = arguments.entrykey)>
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="UpdateLastPosting" output="false" returntype="boolean">
		<cfargument name="forumkey" type="string" hint="entrykey of forum" required="yes">
		<cfargument name="threadkey" type="string" hint="entrykey of the main posting">

		<cfinclude template="queries/q_update_lastposting.cfm">
		
		<cfreturn true>		
	</cffunction>
	
	<cffunction access="public" name="UpdatePostingCount" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="yes" hint="main thread entrykey">
		
		<cfinclude template="queries/q_update_posting_count.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetWholePosting" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="any" required="true">		
		
		<!--- check the security ... --->
		<cfinclude template="queries/q_select_whole_postings.cfm">
		
		<cfreturn q_select_whole_postings>
		
	</cffunction>

</cfcomponent>
