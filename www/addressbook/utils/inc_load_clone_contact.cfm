<!--- //

	Module:		Address Book
	Description:Load data of contact for cloneing ...
	

// --->
	
<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn_load_parent_contact">
	<cfinvokeargument name="entrykey" value="#url.clonefromcontactkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif stReturn_load_parent_contact.result>

	<cfset q_parent_contact = stReturn_load_parent_contact.q_select_contact>
		
	<cfquery name="q_parent_contact" dbtype="query">
	SELECT
		parentcontactkey,notice,email_prim,firstname,surname,title,sex,birthday,
		b_city,b_zipcode,b_country,b_telephone,b_fax,b_mobile,b_street,
		nace_code,criteria,
		categories,b_url,department,b_street,company,lang,
		p_city,p_zipcode,p_country,p_street,p_mobile,p_telephone,p_fax
	FROM
		q_parent_contact
	;
	</cfquery>
		
	
	<cfset QuerySetCell(q_parent_contact, 'parentcontactkey', url.parentcontactkey, 1) />
</cfif>

