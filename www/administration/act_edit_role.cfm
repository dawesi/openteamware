<!--- //

	save permissions
	
	// --->
	


<cfdump var="#form#">

<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="DeleteSavedRoleSettings" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
</cfinvoke>

<cfset cmp_security = application.components.cmp_security>

<cfset q_select_avaliable_actions = cmp_security.LoadAvaliableActionsofService('')>

<cfset tmp = QueryAddColumn(q_select_avaliable_actions, "ok", ArrayNew(1))>

<cfoutput query="q_select_avaliable_actions">
	<cfset tmp = QuerySetCell(q_select_avaliable_actions, "ok", 0, q_select_avaliable_actions.currentrow)>
</cfoutput>



<cfloop index="sEntrykey" list="#form.frmcbpermissions#" delimiters=",">
	<cfoutput>#sEntrykey#</cfoutput><br>
	
	<!--- check if the read permission is given ... --->

	
</cfloop>

<cfoutput query="q_select_avaliable_actions">

	<cfset ii = ListFindNoCase(form.frmcbpermissions, q_select_avaliable_actions.entrykey)>
	
	<!---<cfquery name="q_select_parent_read_ok" dbtype="query">
	SELECT ok FROM q_select_avaliable_actions
	WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value=""
	</cfquery>--->
	
	<cfif ii gt 0>
			<cfset tmp = QuerySetCell(q_select_avaliable_actions, "ok", 1, q_select_avaliable_actions.currentrow)>
	</cfif>
	
</cfoutput>


<cfdump var="#q_select_avaliable_actions#">

<cfquery name="q_select_avaliable_actions" dbtype="query">
SELECT * FROM q_select_avaliable_actions WHERE ok = 1;
</cfquery>

<cfdump var="#q_select_avaliable_actions#">

<cfquery name="q_select_distinct_services" dbtype="query">
SELECT DISTINCT(servicekey) FROM q_select_avaliable_actions;
</cfquery>


<cfoutput query="q_select_distinct_services">
	<cfquery name="q_select_actions" dbtype="query">
	SELECT ok,actionname,entrykey FROM q_select_avaliable_actions
	WHERE servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_services.servicekey#">;
	</cfquery>
	
	<cfset a_str_actions = "">
	
	<cfloop query="q_select_actions">
		<cfset a_str_actions = a_str_actions & "," & q_select_actions.actionname>
	</cfloop>
	
	<cfset a_str_actions = Trim(Mid(a_str_actions, 2, len(a_str_actions)))>
	<cfdump var="#a_str_actions#"><br>
	
	<cfset InsertRolePermissions.workgroupkey = "">
	<cfset InsertRolePermissions.rolekey = form.frmentrykey>
	<cfset InsertRolePermissions.servicekey = q_select_distinct_services.servicekey>
	<cfset InsertRolePermissions.allowedactions = a_str_actions>
	
	<cfinclude template="queries/q_insert_role_permissions.cfm">
	
</cfoutput>


<cflocation addtoken="no" url="default.cfm?action=roleproperties&entrykey=#urlencodedformat(form.frmentrykey)#">