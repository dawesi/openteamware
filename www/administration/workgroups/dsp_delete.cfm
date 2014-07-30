<cfparam name="url.entrykey" type="string" default="">

<cfif IsDefined("url.confirmed")>


<!--- delete ressource definitions ... --->

<!--- delete global shares --->

<!--- delete special security settings ... --->

<!--- delete now group ... --->

<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="DeleteWorkgroup" returnvariable="a_bol_return">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="workgroupkey" value="#url.entrykey#">
	<cfinvokeargument name="deletedbyuserkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

Gruppe wurde geloescht.
<br><br><br>
<a href="index.cfm?action=workgroups<cfoutput>#writeurltags()#</cfoutput>">zurueck</a>

<cfelse>


<!--- check if this workgroup has subgroups or still members ... --->
<cfquery name="q_select_sub_workgroups">
SELECT
	COUNT(id) AS count_id
FROM
	workgroups
WHERE
	parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>

<cfif q_select_sub_workgroups.count_id GT 0>
	<h4>Fehler</h4>
	<b>Es existieren noch Untergruppen.</b><br><br>
	<a href="javascript:history.go(-1);">zurueck</a>
	<cfexit method="exittemplate">
</cfif>

<cfset SelectWorkgroupMembersRequest.entrykey = url.entrykey>
<cfinclude template="../queries/q_select_workgroup_members.cfm">

<cfif q_select_workgroup_members.recordcount GT 0>
	<h4>Fehler</h4>
	<b>Diese Gruppe hat noch <cfoutput>#q_select_workgroup_members.recordcount#</cfoutput> Mitglieder.</b><br><br>
	<a href="javascript:history.go(-1);">zurueck</a>
	<cfexit method="exittemplate">
</cfif>

<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupNameByEntryKey" returnvariable="a_str_workgroup_name">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

Sind Sie sicher, dass Sie die Arbeitsgruppe <b><cfoutput>#a_str_workgroup_name#</cfoutput></b> loeschen wollen?<bR><br><br>

<a href="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#&confirmed=true</cfoutput>">Ja</a>

<br><br><br>
<a href="javascript:history.go(-1);">Nein</a>

</cfif>