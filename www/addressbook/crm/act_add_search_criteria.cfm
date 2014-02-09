<cfinclude template="/login/check_logged_in.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<!--- default: 0 = AND --->
<cfparam name="form.frmconnector" type="numeric" default="0">
<cfparam name="form.frmfield" type="string" default="">


<cfset a_str_area = ListGetAt(form.frmfield, 1, '_')>
<cfset a_str_datatype = ListGetAt(form.frmfield, 2, '_')>
<cfset a_str_fieldname = ListGetAt(form.frmfield, 3, '_')>

<cfset a_str_compare_operator = form['FRMCOMPARE_'&a_str_datatype]>

<cfif StructKeyExists(form, 'FRMFIELDCOMPAREVALUES_'&a_str_fieldname)>
	<cfset a_str_compare_value = form['FRMFIELDCOMPAREVALUES_'&a_str_fieldname]>
<cfelse>
	<cfset a_str_compare_value = ''>
</cfif>

<cfswitch expression="#a_str_area#">
	<cfcase value="crm">
		<!--- crm --->
		
		
		
		<cfset a_str_display_fieldname = form['FRMDISPLAYFIELDNAME_'&a_str_fieldname]>
		
		displayname: <cfoutput>#a_str_display_fieldname#</cfoutput>
		<br />
		feldname: <cfoutput>#a_str_fieldname#</cfoutput>
		<br />
		datatype: <cfoutput>#a_str_datatype#</cfoutput>
		<br />
		connector: <cfoutput>#form.frmconnector#</cfoutput>
		<br />
		operator: <cfoutput>#GetDatabaseOperatorFromTextOperator(a_str_compare_operator)#</cfoutput>
		<br />
		value: <cfoutput>#a_str_compare_value#</cfoutput>
		
		<cfinvoke component="#application.components.cmp_crmsales#" method="AddFilterSearchCriteria" returnvariable="a_bol_return">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
			<!--- crm --->
			<cfinvokeargument name="area" value="1">
			<cfinvokeargument name="connector" value="#form.frmconnector#">
			<!---
				0 = is
				1 = is not
				2 = greater
				3 = smaller
				4 = contains
				--->
			<cfinvokeargument name="operator" value="#a_str_compare_operator#">
			<!--- automatically calculated --->
			<cfinvokeargument name="displayname" value="#a_str_display_fieldname#">
			<cfinvokeargument name="internalfieldname" value="#a_str_fieldname#">
			<cfinvokeargument name="comparevalue" value="#a_str_compare_value#">
			<cfinvokeargument name="internaldatatype" value="#GetDatabaseDataTypeFromStringname(a_str_datatype)#">
		</cfinvoke>
				
	</cfcase>
	<cfcase value="meta">
		<!--- meta ... workgroups ... categories ... followups ... assigned to ... --->
		<h4>meta</h4>
		a_str_fieldname: <cfoutput>#a_str_fieldname#</cfoutput>
		<br />
		a_str_datatype: <cfoutput>#a_str_datatype#</cfoutput>
		<br />
		a_str_compare_value: <cfoutput>#a_str_compare_value#</cfoutput>
		<br />
		a_str_compare_operator: <cfoutput>#a_str_compare_operator#</cfoutput>
		
		<!--- add --->
		<cfinvoke component="#application.components.cmp_crmsales#" method="AddFilterSearchCriteria" returnvariable="a_bol_return">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
			<cfinvokeargument name="area" value="0">
			<cfinvokeargument name="connector" value="0">
			<!---
				0 = is
				1 = is not
				2 = greater
				3 = smaller
				4 = contains
				--->
			<cfinvokeargument name="operator" value="0">
			<!--- automatically calculated --->
			<cfinvokeargument name="displayname" value="">
			<cfinvokeargument name="internalfieldname" value="#a_str_fieldname#">
			<cfinvokeargument name="comparevalue" value="#a_str_compare_value#">
			<cfinvokeargument name="internaldatatype" value="0">
		</cfinvoke>
		
	</cfcase>
	<cfcase value="contact">
		<!--- contact (address ...) --->
		
	</cfcase>
</cfswitch>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">