
<cfinvoke component="#request.a_str_component_licence#" method="GetAvailableQuota" returnvariable="a_int_quota">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
</cfinvoke>


<cfparam name="form.frmaddquota" type="numeric" default="0">

<cfif form.frmaddquota GT a_int_quota>

	<cfset a_str_text = GetLangVal('adm_ph_quota_error_max_value')>
	<cfset a_str_text = ReplaceNoCase(a_str_text, '%MB%', a_int_quota)>
	
	<cfoutput>#a_str_text#</cfoutput>
	<br><br>
	<cfoutput>#GetLangVal('adm_ph_please_order_in_the_shop')#</cfoutput>: <a href="default.cfm?action=shop"><cfoutput>#GetLangVal('adm_ph_goto_shop')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<!--- get size in kb --->
<cfset a_int_bytes_to_add = form.frmaddquota * 1024 * 1024>

<cfdump var="#form#">

<cfswitch expression="#form.frmtype#">
	<cfcase value="email">
	<!--- add email quota --->
	<cfinvoke component="#application.components.cmp_email_tools#" method="GetQuotaDataForUser" returnvariable="a_struct_user">
		<cfinvokeargument name="username" value="#form.frmusername#">
	</cfinvoke> 
	
	<!--- calc new size ... --->
	<cfset a_int_newsize = a_struct_user.maxsize + a_int_bytes_to_add>
	
	<cfinvoke component="#application.components.cmp_email_tools#" method="UpdateQuota" returnvariable="a_struct_user">
		<cfinvokeargument name="username" value="#form.frmusername#">
		<cfinvokeargument name="quota" value="#a_int_newsize#">
	</cfinvoke> 
		
	</cfcase>
	<cfcase value="storage">
	
	<!--- to do ... storage --->
	
	</cfcase>
</cfswitch>


<!--- remove quota ... --->
<cfinvoke component="#request.a_str_component_licence#" method="AddAvailableQuota" returnvariable="a_int_quota">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="mb" value="-#form.frmaddquota#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">