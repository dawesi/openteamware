<!--- //

	Module:		Address Book
	Action:		DoCreateContact
	Description:Create a new contact
	
// --->

<cfparam name="form.frmentrykey" type="string" default="#CreateUUID()#">
<cfparam name="form.frmcontacttype" type="numeric" default="0">
<cfparam name="form.frmsuperiorcontactkey" type="string" default="">
<cfparam name="form.frmp_mobile" type="string" default="">
<cfparam name="form.frmp_url" type="string" default="">
<cfparam name="form.frmfirstname" type="string" default="">
<cfparam name="form.frmsurname" type="string" default="">
<cfparam name="form.frmtitle" type="string" default="">
<cfparam name="form.frmsex" type="string" default="-1">
<cfparam name="form.frmposition" type="string" default="">
<cfparam name="form.frmbirthday" type="string" default="">
<cfparam name="form.frmp_city" type="string" default="">
<cfparam name="form.frmp_street" type="string" default="">
<cfparam name="form.frmp_zipcode" type="string" default="">
<cfparam name="form.frmp_country" type="string" default="">
<cfparam name="form.frmp_telephone" type="string" default="">
<cfparam name="form.frmp_fax" type="string" default="">
<cfparam name="form.frmskypeusername" type="string" default="">
<cfparam name="form.frmcriteria" type="string" default="">
<cfparam name="form.frmcompany" type="string" default="">
<cfparam name="form.frmcompany_display" type="string" default="">
<cfparam name="form.frmemployees" type="string" default="">
<cfparam name="form.frmcategories" type="string" default="">
<cfparam name="form.frmnance_code" type="string" default="0">
<cfparam name="form.frmnotice" type="string" default="">
<cfparam name="form.frmprivatenotices" type="string" default="">
<cfparam name="form.frmworkgroupkeys" type="string" default="">
<cfparam name="form.frmassigned_users" type="string" default="">
<cfparam name="form.ownfield1" type="string" default="">
<cfparam name="form.ownfield2" type="string" default="">
<cfparam name="form.ownfield3" type="string" default="">
<cfparam name="form.ownfield4" type="string" default="">

<cfinvoke component="#application.components.cmp_addressbook#" method="CreateContact" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contacttype" value="#form.frmcontacttype#">
	<cfinvokeargument name="parentcontactkey" value="#form.frmcompany#">
	<cfinvokeargument name="superiorcontactkey" value="#form.frmsuperiorcontactkey#">
	<cfinvokeargument name="firstname" value="#form.frmfirstname#">
	<cfinvokeargument name="surname" value="#form.frmsurname#">
	<cfinvokeargument name="title" value="#form.frmtitle#">
	<cfinvokeargument name="sex" value="#form.frmsex#">
	<cfinvokeargument name="company" value="#form.frmcompany_display#">
	<cfinvokeargument name="department" value="#form.frmdepartment#">
	<cfinvokeargument name="position" value="#form.frmposition#">
	<cfinvokeargument name="email_prim" value="#form.frmemail_prim#">
	<cfinvokeargument name="email_adr" value="#form.frmemail_adr#">
	<cfinvokeargument name="birthday" value="#form.frmbirthday#">
	<cfinvokeargument name="categories" value="#form.frmcategories#">
	<cfinvokeargument name="criteria" value="#form.frmcriteria#">
	<cfinvokeargument name="nace_code" value="#val(form.frmnance_code)#">
	<cfinvokeargument name="b_street" value="#form.frmb_street#">
	<cfinvokeargument name="b_city" value="#form.frmb_city#">
	<cfinvokeargument name="b_zipcode" value="#form.frmb_zipcode#">
	<cfinvokeargument name="b_country" value="#form.frmb_country#">
	<cfinvokeargument name="b_telephone" value="#form.frmb_telephone#">
	<cfinvokeargument name="b_telephone_2" value="#form.frmb_telephone_2#">
	<cfinvokeargument name="b_fax" value="#form.frmb_fax#">
	<cfinvokeargument name="b_mobile" value="#form.frmb_mobile#">
	<cfinvokeargument name="b_url" value="#form.frmb_url#">
	<cfinvokeargument name="p_street" value="#form.frmp_street#">
	<cfinvokeargument name="p_city" value="#form.frmp_city#">
	<cfinvokeargument name="p_zipcode" value="#form.frmp_zipcode#">
	<cfinvokeargument name="p_country" value="#form.frmp_country#">
	<cfinvokeargument name="p_telephone" value="#form.frmp_telephone#">
	<cfinvokeargument name="p_mobile" value="#form.frmp_mobile#">
	<cfinvokeargument name="p_url" value="#form.frmp_url#">
	<cfinvokeargument name="notice" value="#form.frmnotice#">
	<cfinvokeargument name="skypeusername" value="#form.frmskypeusername#">
	<cfinvokeargument name="language" value="#form.frmlanguage#">
	<cfinvokeargument name="employees" value="#form.frmemployees#">
	
	<cfinvokeargument name="ownfield1" value="#form.ownfield1#">
	<cfinvokeargument name="ownfield2" value="#form.ownfield2#">
	<cfinvokeargument name="ownfield3" value="#form.ownfield3#">
	<cfinvokeargument name="ownfield4" value="#form.ownfield4#">
</cfinvoke>

<cfif NOT stReturn.result>
	<cfoutput>An error occured: #stReturn.error#</cfoutput>
	<cfexit method="exittemplate">
</cfif>

<cfset a_str_contactkey = stReturn.entrykey />

<cfif Len(form.frmprivatenotices) GT 0>
	<!--- update private comment --->
	<cfmodule template="/common/person/saveuserpref.cfm"
		entrysection = "crm.contact.owncomment"
		entryname = "#a_str_contactkey#"
		entryvalue1 = #form.frmprivatenotices#>	
</cfif>

<!--- workgroup permissions ... --->
<cfloop list="#form.frmworkgroupkeys#" delimiters="," index="a_str_workgroupkey">
	
	<cfinvoke component="#application.components.cmp_security#" method="CreateWorkgroupShare" returnvariable="stReturn">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="workgroupkey" value="#a_str_workgroupkey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="entrykey" value="#a_str_contactkey#">
	</cfinvoke>
	
</cfloop>

<!--- assignments ... --->
<cfloop list="#form.frmassigned_users#" index="a_str_assigned_userkey">

	<cfinvoke component="#application.components.cmp_assigned_items#" method="AddAssignment" returnvariable="a_bol_return">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="objectkey" value="#a_str_contactkey#">
		<cfinvokeargument name="userkey" value="#a_str_assigned_userkey#">
		<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	</cfinvoke>

</cfloop>

<cflocation addtoken="no" url="default.cfm?action=ShowItem&entrykey=#urlencodedformat(a_str_contactkey)#">
