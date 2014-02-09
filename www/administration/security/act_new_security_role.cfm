<cfparam name="form.frmcballowpdalogin" type="numeric" default="0">
<cfparam name="form.frmcballowwaplogin" type="numeric" default="0">
<cfparam name="form.frmcballowoutlooksync" type="numeric" default="0">
<cfparam name="form.frmcballowmailaccessdata" type="numeric" default="0">
<cfparam name="form.frmcballowftpacces" type="numeric" default="0">
<cfparam name="form.frmcballowftpacces" type="numeric" default="0">
<cfparam name="form.frmprotocoldepth" type="numeric" default="5">

<cfdump var="#form#">

<cfinvoke component="#application.components.cmp_security#" method="CreateSecurityRole" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="rolename" value="#form.frmrolename#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="protocol_depth" value="#form.frmprotocoldepth#">
	<cfinvokeargument name="allow_pda_login" value="#form.frmcballowpdalogin#">
	<cfinvokeargument name="allow_pda_login" value="#form.frmcballowwaplogin#">
	<cfinvokeargument name="allow_outlooksync" value="#form.frmcballowoutlooksync#">
	<cfinvokeargument name="allow_ftp_login" value="#form.frmcballowftpacces#">
	<cfinvokeargument name="allow_maildataacceessdata_access" value="#form.frmcballowmailaccessdata#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cflocation addtoken="no" url="../default.cfm?resellerkey=#urlencodedformat(form.frmresellerkey)#&action=security&companykey=#urlencodedformat(form.frmcompanykey)#">