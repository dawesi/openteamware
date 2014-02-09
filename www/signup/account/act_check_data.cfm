<!--- post page for registration --->
<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="default.cfm">
</cfif>

<!--- include scripts ... --->
<cfinclude template="/common/scripts/script_utils.cfm">
<cfinclude template="inc_scripts.cfm">

<cfinclude template="inc_check_custom_style.cfm">

<cfparam name="form.frmusername" type="string" default="">
<cfparam name="form.frmpassword1" type="string" default="">
<cfparam name="form.frmpassword2" type="string" default="">
<cfparam name="form.frm_external_email" type="string" default="">

<cfparam name="form.frmfirstname" type="string" default="">
<cfparam name="form.frmsurname" type="string" default="">
<cfparam name="form.frmsex" type="numeric" default="0">
<cfparam name="form.frmtitle" type="string" default="">

<cfparam name="form.frmcbacceptagb" type="numeric" default="0">
<cfparam name="form.frm_create_no_team" type="numeric" default="0">
<cfparam name="form.frmsystempartnerkey" type="string" default="">
<cfparam name="form.frmoptions" type="string" default="">

<!--- set session variables ... --->

<!--- agb accepted? --->
<cfset session.a_struct_data.agbaccepted = form.frmcbacceptagb>

<!--- username/password --->
<cfset session.a_struct_data.username = form.frmusername>
<cfset session.a_struct_data.password = form.frmpassword1>

<!--- external email --->
<cfset session.a_struct_data.external_email = form.frm_external_email>

<!--- team ... --->
<cfset session.a_struct_data.groupname = form.frmgroupname>
<cfset session.a_struct_data.groupdescription = form.frmgroupdescription>

<cfloop from="1" to="4" index="ii">
	<cfset session.a_struct_data['member_' & ii] = form['frmmember_' & ii]>
</cfloop>

<cfset session.a_struct_data.firstname = form.frmfirstname>
<cfset session.a_struct_data.surname = form.frmsurname>
<cfset session.a_struct_data.title = form.frmtitle>
<cfset session.a_struct_data.sex = val(form.frmsex)>
<cfset session.a_struct_data.company = form.frmcompany>
<cfset session.a_struct_data.street = form.frmstreet>
<cfset session.a_struct_data.zipcode = form.frmzipcode>
<cfset session.a_struct_data.city = form.frmcity>
<cfset session.a_struct_data.telephone = form.frmtelephone>
<cfset session.a_struct_data.industry = form.frmindustry>
<cfset session.a_struct_data.source = form.frmsource>
<cfset session.a_struct_data.country = form.frmcountry>

<!--- fullfill now various checks ... --->
<cfif Len(form.frmfirstname) LTE 2>
	<cflocation addtoken="no" url="default.cfm?error=tooshortfirstname">
</cfif>

<cfif Len(form.frmsurname) LTE 2>
	<cflocation addtoken="no" url="default.cfm?error=tooshortsurname">
</cfif>

<cfif Len(form.frmusername) LT 3>
	<cflocation addtoken="no" url="default.cfm?error=tooshortusername">
</cfif>

<cfif FindNoCase("@", form.frmUsername, 1) GT 0>
	<cflocation addtoken="no" url="default.cfm?error=atcharinusername">
</cfif>

<cfif ReFindNoCase("[^0-9,a-z,.,--,_]", form.frmUsername, 1) GT 0>
	<cflocation addtoken="no" url="default.cfm?error=invalidcharinusername">
</cfif>

<cfif form.frmcbacceptagb IS 0>
	<cflocation addtoken="no" url="default.cfm?error=agbacceptmissing">
</cfif>

<!--- check the full username ... --->
<cfset form.frmUsername = form.frmUsername & '@' & request.appsettings.properties.defaultdomain>

<!--- username available? --->
<cfinvoke component="#application.components.cmp_user#" method="UsernameExists" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#form.frmUsername#">
</cfinvoke>

<cfif a_bol_return>
	<!--- user already exists ... --->
	<cflocation addtoken="no" url="default.cfm?error=useralreadyexists">
</cfif>

<cfif ExtractEmailAdr(form.frm_external_email) IS ''>
	<!--- empty external address --->
	<cflocation addtoken="no" url="default.cfm?error=invalidexternaladdress">
</cfif>

<!--- anti-spammer! --->
<cfset a_str_hostname_of_ip = application.components.cmp_tools.GetHostName(cgi.REMOTE_ADDR) />

<cfif Len(form.frmpassword1) LT 4>
	<cflocation addtoken="no" url="default.cfm?error=passworderror">
</cfif>

<cfif CompareNoCase(form.frmpassword1, form.frmpassword2) NEQ 0>
	<cflocation addtoken="no" url="default.cfm?error=passworderror">
</cfif>

<cfif Len(form.frmstreet) LTE 5>
	<cflocation addtoken="no" url="default.cfm?error=emptystreet">
</cfif>

<cfif Len(form.frmzipcode) LT 4>
	<cflocation addtoken="no" url="default.cfm?error=errorzipcode">
</cfif>

<cfif Len(form.frmcity) LT 3>
	<cflocation addtoken="no" url="default.cfm?error=errorcity">
</cfif>

<!--- ok, all checks done ... now create company/users ... --->
<cfinclude template="inc_create_customer.cfm">