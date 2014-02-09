<!--- //

	Module:		Address Book
	Action:		Organigramm
	Description:Show orgranization organigramm
	

	
	
	TODO hp: implement feature
	
// --->

<cfparam name="url.accountkey" type="string" default="">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('crm_wd_organigram')) />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_object">
	<cfinvokeargument name="entrykey" value="#url.accountkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="loadmetainformations" value="true">
</cfinvoke>


<cfset tmp = SetHeaderTopInfoString(GetLangVal('crm_wd_organigram') & ' ' & a_struct_object.q_Select_contact.company) />

<cfset q_select_sub_items = a_struct_object.q_select_sub_items />
<cfset a_str_contactkeys = ValueList(q_select_sub_items.entrykey) />

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.entrykeys = a_str_contactkeys />

<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_loadoptions.fieldstoselect = 'entrykey,superiorcontactkey,firstname,surname,title,department,aposition,b_city' />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<cfset q_select_items = stReturn.q_select_contacts />

<ul class="ul_nopoints">
	<cfoutput>#LoopContacts(superiorcontactkey = '')#</cfoutput>
</ul>

<cffunction access="private" name="LoopContacts" output="true">
	<cfargument name="superiorcontactkey" type="string" default="">
	
	<cfquery name="q_select_level" dbtype="query">
	SELECT
		*
	FROM
		q_select_items
	WHERE
		superiorcontactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.superiorcontactkey#">
	ORDER BY
		surname,firstname
	;
	</cfquery>
	
	<cfloop query="q_select_level">
		
		<li><a href="/addressbook/?action=ShowItem&entrykey=#q_select_level.entrykey#">#si_img('user')# #q_select_level.surname#, #q_select_level.firstname#</a>
		
		<cfquery name="q_select_second_level" dbtype="query">
		SELECT
			*
		FROM
			q_select_items
		WHERE
			superiorcontactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_level.entrykey#">
		;
		</cfquery>
		
		<cfif q_select_second_level.recordcount GT 0>
			<ul>
				#LoopContacts(superiorcontactkey = q_select_level.entrykey)#
			</ul>
		</cfif>
	
	</li>
	</cfloop>
	
</cffunction>

