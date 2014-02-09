<!--- //

	Module:		Address Book
	Description:load data from parent contact
	

// --->
	
<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn_load_parent_contact">
	<cfinvokeargument name="entrykey" value="#url.parentcontactkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif stReturn_load_parent_contact.result>

	<cfset q_parent_contact = stReturn_load_parent_contact.q_select_contact>
		
	<cfquery name="q_parent_contact" dbtype="query">
	SELECT
		parentcontactkey,entrykey,notice,email_prim,
		b_city,b_zipcode,b_country,b_telephone,b_fax,b_mobile,
		criteria,categories,b_url,department,b_street,company,lang
	FROM
		q_parent_contact
	;
	</cfquery>	
	
	<cfset tmp = QuerySetCell(q_parent_contact, 'parentcontactkey', url.parentcontactkey, 1) />
</cfif>

