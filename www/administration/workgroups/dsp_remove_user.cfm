
<cfinclude template="../dsp_inc_select_company.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupNameByEntryKey" returnvariable="a_str_workgroup_name">
	<cfinvokeargument name="entrykey" value="#url.workgroupkey#">
</cfinvoke>

<cfif IsDefined('url.confirmed')>


<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="RemoveWorkgroupMember" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#url.entrykey#">
	<cfinvokeargument name="workgroupkey" value="#url.workgroupkey#">
</cfinvoke>
<br><br><br>
Benutzer wurde entfernt.
<br><br><br>
<a href="default.cfm?action=workgroupproperties&entrykey=<cfoutput>#url.workgroupkey##WriteURLTags()#</cfoutput>">zurueck</a>

<cfmail from="#request.stSecurityContext.myusername#" to="#stReturn.query.username#" subject="Arbeitsgruppenmitgliedschaft beendet">
Hinweis:

Ihre Mitgliedschaft in der Arbeitsgruppe #a_str_workgroup_name# wurde durch den Administrator #request.stSecurityContext.myusername# beendet.
</cfmail>

<cfelse>
<br><br>
Sind Sie sicher, dass Sie <cfoutput><b>#stReturn.query.username#</b></cfoutput> aus der Gruppe <b><cfoutput>#a_str_workgroup_name#</cfoutput></b> entfernen moechten?

<br><br><br>

<a href="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>&confirmed=true">Ja
<br><br><br>
<a href="<cfoutput>#ReturnRedirectURL()#</cfoutput>">Nein</a>
</cfif>