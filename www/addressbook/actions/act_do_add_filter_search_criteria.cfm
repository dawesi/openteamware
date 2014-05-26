<!--- //

	Module:		Addressbok
	Action:		DoAddFilterSearchCriteria
	Description:Add some criteria to the currently selected
				filter view key ...
	
// --->

<cfparam name="form.frmfilterviewkey" type="string" default="" />
<cfparam name="form.frmdisplaydatatype" type="numeric" default="0" />
<cfparam name="form.frmarea" type="string" default="contact" />

<!--- clear all stored criteria? ... --->
<cfparam name="form.frmclearallstoredcriteria" type="numeric" default="0">

<!--- the list of fields displayed in the search form ... frm + name will give us the input name ... --->
<cfparam name="form.frm_fields" type="string" default="">

<!--- store setting ... --->
<cfset tmp = application.components.cmp_person.SaveUserPreference(userid = request.stSecurityContext.myuserid, section = 'addressbook',
					name = 'clearcriteria.unstoredfilter',
					value = form.frmclearallstoredcriteria) />

<!--- clear all stored criteria? ... --->
<cfif Len(form.frmfilterviewkey) IS 0 AND form.frmclearallstoredcriteria IS 1>
	
	<cfinvoke component="#application.components.cmp_crmsales#" method="ClearFilterCriterias" returnvariable="a_bol_return">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
		<cfinvokeargument name="viewkey" value="#form.frmfilterviewkey#">
	</cfinvoke>

</cfif>

<cfswitch expression="#form.frmarea#">
	<cfcase value="contact">
		<cfset a_int_area = 2 />
	</cfcase>
	<cfcase value="meta">
		<cfset a_int_area = 0 />
	</cfcase>
	<cfcase value="database">
		<cfset a_int_area = 1 />
	</cfcase>
</cfswitch>

<!--- loop through all given fields, check if they exists, the value is not empty ...
	if this is all true, add field to filter ... --->
<cfloop list="#form.frm_fields#" index="a_str_field_name">
	
	<cfset a_str_form_field_name = 'frm' & a_str_field_name />
	
	<cfif StructKeyExists(form, a_str_form_field_name)>
		
		<cfset a_str_form_value = form[a_str_form_field_name] />
		
		<cfif Len(Trim(a_str_form_value)) GT 0>

			<cfinvoke component="#application.components.cmp_crmsales#" method="AddFilterSearchCriteria" returnvariable="a_bol_return">
				<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
				<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
				<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
				<cfinvokeargument name="viewkey" value="#form.frmfilterviewkey#">
				<cfinvokeargument name="area" value="#a_int_area#">
				<cfinvokeargument name="connector" value="0">
				<cfinvokeargument name="operator" value="4">
				<cfinvokeargument name="displayname" value="#form[a_str_form_field_name & '_displayname']#">
				<cfinvokeargument name="internalfieldname" value="#a_str_field_name#">
				<cfinvokeargument name="comparevalue" value="#a_str_form_value#">
				<!--- always 0 ... not good! --->
				<cfinvokeargument name="internaldatatype" value="#Val(GetDatabaseDataTypeFromStringname('string'))#">
			</cfinvoke>
		
		</cfif>
	
	</cfif>

</cfloop>

<cflocation addtoken="false" url="index.cfm?action=ShowContacts&filterviewkey=#form.frmfilterviewkey#&filterdatatype=#form.frmdisplaydatatype#">
