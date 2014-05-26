<!--- //

	Service:	Address Book
	Action:		AddCRMFilterCriteria
	Description:Add criteria ...
	
	Header:		

// --->

<cfparam name="form.frm_reset_all_criterias" type="numeric" default="0">
<cfparam name="form.frmredirect" type="string" default="">
<cfparam name="form.frmentrykey" type="string" default="">

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="index.cfm">
</cfif>

<cfif Len(form.frmentrykey) IS 0 AND form.frm_reset_all_criterias IS 1>
	<!--- clear all criterias with empty viewkey --->
	
	<cfinvoke component="#application.components.cmp_crmsales#" method="ClearFilterCriterias" returnvariable="a_bol_return">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="viewkey" value="#form.frmentrykey#">
	</cfinvoke>	
	
</cfif>

<cfloop list="#form.FRMFIELDNAMES#" delimiters="," index="a_str_fieldname">
	<!---fieldname: <cfoutput>#a_str_fieldname#</cfoutput>--->
	
	<cfset a_str_uuid = form['frmfielduuid' & a_str_fieldname] />
	
	<!---<cfoutput>#a_str_uuid#</cfoutput><br>--->
	
	<cfset a_str_source = form['frmFieldSource' & a_str_uuid] />
	<cfset a_str_showname = form['frmshownamename' & a_str_uuid] />
	<cfset a_str_fieldtype = form['frmFieldType' & a_str_uuid] />
	<cfset a_str_operator = form['frmoperator' & a_str_uuid] />
	
	<cfif StructKeyExists(form, 'frmcompare' & a_str_uuid)>
		<cfset a_str_compare = form['frmcompare' & a_str_uuid] />
	<cfelse>
		<cfset a_str_compare = '' />
	</cfif>
	
	<!---
	<cfoutput>|source: #a_str_source#|showname: #a_str_showname#| #a_str_fieldtype# #a_str_operator# #a_str_compare#</cfoutput><br>
	--->
	<cfif a_str_fieldtype IS 'boolean'>
		<cfset a_str_compare = 1 />
	</cfif>
	
	<!--- operator selected and comparevalue <> '' --->
	
	<!--- TEST: removed  AND Len(a_str_compare) GT 0 --->
	<cfif (a_str_operator NEQ - 1) AND Len(a_str_compare) GT 0>
		<h1>hit</h1>
				
		<cfswitch expression="#a_str_source#">
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
		
		<cfinvoke component="#application.components.cmp_crmsales#" method="AddFilterSearchCriteria" returnvariable="a_bol_return">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<!--- address book --->
			<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
			<cfinvokeargument name="viewkey" value="#form.frmentrykey#">
			<cfinvokeargument name="area" value="#a_int_area#">
			<cfinvokeargument name="connector" value="0">
			<!---
				0 = is
				1 = is not
				2 = greater
				3 = smaller
				4 = contains
				--->
			<cfinvokeargument name="operator" value="#a_str_operator#">
			<!--- automatically calculated --->
			<cfinvokeargument name="displayname" value="#a_str_showname#">
			<cfinvokeargument name="internalfieldname" value="#a_str_fieldname#">
			<cfinvokeargument name="comparevalue" value="#a_str_compare#">
			<!--- always 0 ... not good! --->
			<cfinvokeargument name="internaldatatype" value="#Val(GetDatabaseDataTypeFromStringname(a_str_fieldtype))#">
		</cfinvoke>
	</cfif>
	
</cfloop>

<cfswitch expression="#form.frmredirect#">
	<cfcase value="addressbook">
		<cflocation addtoken="no" url="/addressbook/?filterviewkey=#UrlEncodedFormat(form.frmentrykey)#">
	</cfcase>
	<cfdefaultcase>
		<cflocation addtoken="no" url="#ReturnRedirectURL()#">
	</cfdefaultcase>
</cfswitch>

