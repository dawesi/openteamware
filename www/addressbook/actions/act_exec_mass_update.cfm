<!--- //

	Module:		Address Book
	Action:		DoExecuteMassActions
	Description:Execute the mass action
	
// --->

<cfparam name="form.frmentrykeys" type="string">
<cfparam name="form.frmassignedusers" type="string" default="">
<cfparam name="form.frmcriteria" type="string" default="">
<cfparam name="form.frmworkgroupshares" type="string" default="">
<cfparam name="form.frmreplaceexistingassignments" type="string" default="0">
<cfparam name="form.frmdatatype" type="numeric" default="0">
<cfparam name="form.frmcategories" type="string" default="">
<cfdump var="#form#">

<!--- add this criteria to all selected items? --->
<cfif Len(form.frmcriteria) GT 0>

	<cfloop list="#form.frmentrykeys#" index="a_str_itemkey">
	
	<cfif form.frmreplaceexistingassignments IS 1>
		
		<!--- easy, just update ... --->
		
		<cfset stUpdate = StructNew() />
		<cfset stUpdate.criteria = form.frmcriteria />
		
		<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="stReturn">
			<cfinvokeargument name="entrykey" value="#a_str_itemkey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="newvalues" value="#stUpdate#">
		</cfinvoke>
		
	<cfelse>
	
		<!--- load existing criteria and update with new ones ... --->
		<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_get_contact">
			<cfinvokeargument name="entrykey" value="#a_str_itemkey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>
		
		<cfset q_select_contact = a_struct_get_contact.q_select_contact />
		
		<!--- combine criteria ... --->
		<cfset a_str_criteria = ListAppend(q_select_contact.criteria, form.frmcriteria) />
		<cfset a_str_criteria = ListDeleteDuplicates(a_str_criteria) />
		
		<cfset stUpdate = StructNew() />
		<cfset stUpdate.criteria = a_str_criteria />
		
		<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="stReturn">
			<cfinvokeargument name="entrykey" value="#a_str_itemkey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="newvalues" value="#stUpdate#">
		</cfinvoke>
	
	</cfif>
	
	</cfloop>
	
</cfif>

<!--- categories ... --->
<cfif Len(form.frmcategories) GT 0>

	<cfloop list="#form.frmentrykeys#" index="a_str_itemkey">
	
	<cfif form.frmreplaceexistingassignments IS 1>
		
		<!--- easy, just update ... --->
		
		<cfset stUpdate = StructNew() />
		<cfset stUpdate.categories = form.frmcategories />
		
		<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="stReturn">
			<cfinvokeargument name="entrykey" value="#a_str_itemkey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="newvalues" value="#stUpdate#">
		</cfinvoke>
		
	<cfelse>
	
		<!--- load existing criteria and update with new ones ... --->
		<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_get_contact">
			<cfinvokeargument name="entrykey" value="#a_str_itemkey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>
		
		<cfset q_select_contact = a_struct_get_contact.q_select_contact />
		
		<!--- combine criteria ... --->
		<cfset a_str_categories = ListAppend(q_select_contact.categories, form.frmcategories) />
		<cfset a_str_categories = ListDeleteDuplicates(a_str_categories) />
		
		<cfset stUpdate = StructNew() />
		<cfset stUpdate.categories = a_str_categories />
		
		<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="stReturn">
			<cfinvokeargument name="entrykey" value="#a_str_itemkey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="newvalues" value="#stUpdate#">
		</cfinvoke>
	
	</cfif>
	
	</cfloop>
	
</cfif>

<!--- Update assigned users? ... --->
<cfif Len(form.frmassignedusers) GT 0>
	

	
	<cfloop list="#form.frmentrykeys#" index="a_str_itemkey">
	
		<cfif form.frmreplaceexistingassignments IS 1>
			<!--- remove all existing assignments ... --->
			<cfinvoke component="#application.components.cmp_assigned_items#" method="RemoveAllAssignments" returnvariable="stReturn_remove_assignments">
				<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
				<cfinvokeargument name="objectkey" value="#a_str_itemkey#">
				<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			</cfinvoke>
			
		</cfif>

		<cfloop list="#form.frmassignedusers#" index="a_str_assigned_userkey">
		
			<cfinvoke component="#application.components.cmp_assigned_items#" method="AddAssignment" returnvariable="a_bol_return">
				<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
				<cfinvokeargument name="objectkey" value="#a_str_itemkey#">
				<cfinvokeargument name="userkey" value="#a_str_assigned_userkey#">
				<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
			</cfinvoke>
		
		</cfloop>
	
	</cfloop>

</cfif>

<!--- workgroups ... --->
<cfif Len(form.frmworkgroupshares) GT 0>

	<cfloop list="#form.frmentrykeys#" index="a_str_itemkey">
	
			<cfif form.frmreplaceexistingassignments IS 1>
				<!--- remove all existing assignments ... --->
			
				<cfset q_select_wg_shares = application.components.cmp_security.GetWorkgroupSharesForObject(securitycontext = request.stSecurityContext,
													servicekey = request.sCurrentServiceKey,
													entrykey = a_str_itemkey) />
													
				<cfloop query="q_select_wg_shares">
					<cfset tmp = application.components.cmp_security.RemoveWorkgroupShare(securitycontext = request.stSecurityContext,
													servicekey = request.sCurrentServiceKey,
													entrykey = a_str_itemkey,
													workgroupkey = q_select_wg_shares.workgroupkey) />
				</cfloop>
			
			</cfif>
	
		<cfloop list="#form.frmworkgroupshares#" delimiters="," index="a_str_workgroupkey">
		
		<cfinvoke component="#application.components.cmp_security#" method="CreateWorkgroupShare" returnvariable="stReturn">
			<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
			<cfinvokeargument name="workgroupkey" value="#a_str_workgroupkey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="entrykey" value="#a_str_itemkey#">
		</cfinvoke>
		
	</cfloop>
	
	</cfloop>

</cfif>


<cflocation url="default.cfm?filterdatatype=#form.frmdatatype#&otwinfono=1200" addtoken="false">
