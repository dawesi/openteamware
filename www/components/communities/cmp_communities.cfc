<cfcomponent>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<!--- return all communities of a given user --->
	<cffunction access="public" name="GetCommunities" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		
		<cfinclude template="queries/q_select_communities.cfm">
		
		<cfreturn q_select_communities>
	</cffunction>
	
	<!--- write out the default link dialog --->
	<cffunction access="public" name="WriteDefaultLinkDialog" output="false" returntype="string">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">		
		<cfargument name="servicekey" type="string" required="no">
		<cfargument name="objectkey" type="string" required="yes">
		
		<cfset var sReturn = '' />		
		<cfset var q_select_communities = GetCommunities(securitycontext = arguments.securitycontext, usersettings=arguments.usersettings) />		
		<cfset var q_select_community_links_of_object = GetCommunityLinksOfCertainObject(servicekey = arguments.servicekey, objectkey = arguments.objectkey) />
		
		<cfsavecontent variable="sReturn">
			<select name="frmcommunitykeys">
				<cfoutput query="q_select_communities">
					<option value="#q_select_communities.entrykey#">#q_select_communities.community_name#</option>
				</cfoutput>
			</select>
		</cfsavecontent>
		
		<cfreturn sReturn>
	</cffunction>
	
	<cffunction access="public" name="GetCommunityLinksOfCertainObject" returntype="query">
		<cfargument name="servicekey" type="string" required="no" default="if empty, return all elements">
		<cfargument name="objectkey" type="string" required="yes">
		<cfinclude template="queries/q_select_community_links_of_object.cfm">
		<cfreturn q_select_community_links_of_object>
	</cffunction>
	
	<!--- return links to elements for this community --->
	<cffunction access="public" name="GetCommunityLinks" output="false" returntype="query">
		<cfargument name="communitykey" type="string" required="yes" hint="entrykey of the community">
		<cfargument name="servicekey" type="string" required="no" default="if empty, return all elements">
		
		<cfinclude template="queries/q_select_community_links.cfm">
		
		<cfreturn q_select_community_links>	
	</cffunction>
	
	<!--- make something available for a community --->
	<cffunction access="public" name="CreateElementLink" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="servicekey" type="string" required="yes" hint="entrykey of the certain service">
		<cfargument name="objectkey" type="string" required="yes" hint="entrykey of the certain object">
		<cfargument name="communitykey" type="string" required="yes" hint="entrykey of the community">
		
		<cfinclude template="queries/q_insert_community_link.cfm">
		
		<cfreturn true>		
	</cffunction>
	
	<cffunction access="public" name="CreateOrEditCommunity" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes" hint="if entrykey is empty, new community!">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="description" type="string" required="yes">
		
		<cfset var stReturn = StructNew()>
		
		<!--- if update and entrykey is given, delete old item --->
		<cfif Len(arguments.entrykey) GT 0>
			<cfset DeleteCommunity(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, entrykey = arguments.entrykey)>
		</cfif>
		
		<cfif Len(arguments.entrykey) IS 0>
			<cfset arguments.entrykey = CreateUUID()>
		</cfif>
		
		<cfinclude template="queries/q_insert_community.cfm">
		
		<cfreturn stReturn>	
	</cffunction>
	
	<cffunction access="public" name="DeleteCommunity" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		
		<cfinclude template="queries/q_delete_community.cfm">
		
		<cfreturn true>	
	</cffunction>
	
</cfcomponent>