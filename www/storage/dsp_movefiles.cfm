<!--- //

	Module:		Storage
	Action:		MoveFiles
	Description: 
	

// --->


<cfparam name="url.frm_entrykey" type="string" default="">
<cfparam name="url.frm_parentdirectorykey" type="string">

<cfif Len(url.frm_entrykey ) IS 0>
	<cflocation addtoken="no" url="default.cfm?action=showfiles&directorykey=#url.frm_parentdirectorykey#">
</cfif>

<cfset sFilenames = "" />

<cfloop index="sEntrykey" list="#url.frm_entrykey#">
	
	<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "GetFileInformation"   
		returnVariable = "a_struct_file_info"   
		entrykey = "#sEntrykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#">
	</cfinvoke>
	
	<cfset q_query_file = a_struct_file_info.q_select_file_info />

	<cfset sFilenames = ListAppend(sFilenames, q_query_file.filename, ', ') />
</cfloop>


<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_ph_movefiles') & ' ' & sFilenames) />

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFullDirectoryStructureOfUser"   
	returnVariable = "a_struct_dirs"   
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	includeshareddirectories=true>
</cfinvoke>

<cfset q_select_directories = a_struct_dirs.q_select_directories />


<form action="default.cfm?action=DoMoveFiles" method="post">
	<cfoutput>
	<input type="hidden" name="frmentrykeys" value="#url.frm_entrykey#" />
	</cfoutput>
	
	
<table class="table_details">
	<tr>
		<td class="field_name">
			<cfoutput>#si_img('information')#</cfoutput>
		</td>
		<td style="font-weight:bold;">
			<cfoutput>#GetLangVal('sto_ph_movefiles')# #sFilenames#</cfoutput>
			<img src="/images/space_1_1.gif" class="si_img" />
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#getlangval('sto_ph_destinationdirectory')#</cfoutput>:
		</td>
		<td>
			
			<cfoutput>#LoopOutput(query = q_select_directories, isroot = true)#</cfoutput>
			
		</td>
	</tr>
	<tr>
		<td class="field_name"></td>
		<td>
			<input type="submit" value="<cfoutput>#getlangval('sto_ph_move')#</cfoutput>" class="btn" />
		</td>
	</tr>
</table>
</form>

<cffunction access="private" name="LoopOutput" returntype="void" output="true">
	<cfargument name="parentdirectorykey" type="string" default="" required="false">
	<cfargument name="level" type="numeric" default="0" required="false">
	<cfargument name="isroot" type="boolean" default="false">
	
	<cfset var q_select_current_level = 0 />
	
	<cfif arguments.level GT 5>
		<cfreturn />
	</cfif>
	
	<cfif Len(arguments.parentdirectorykey) IS 0 AND NOT arguments.isroot>
		<cfreturn />
	</cfif>
	
	<cfquery name="q_select_current_level" dbtype="query">
	SELECT
		*
	FROM
		q_select_directories
	WHERE
		parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentdirectorykey#">
	ORDER BY
		directoryname
	;
	</cfquery>
	
	<cfif q_select_current_level.recordcount GT 0>
	
	<ul class="ul_nopoints">
	<cfoutput query="q_select_current_level">
		<li>
			#si_img('bullet_orange')# <input class="noborder" type="radio" name="frm_directorykey" value="#q_select_current_level.entrykey#" /> #htmleditformat(q_select_current_level.directoryname)#
			
			#LoopOutput(parentdirectorykey = q_select_current_level.entrykey, level = arguments.level + 1)#
		</li>
	</cfoutput>
	</ul>
	
	</cfif>
	
</cffunction>


