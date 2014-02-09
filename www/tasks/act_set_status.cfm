<!--- status auf "done" setzen --->

<cfinclude template="../common/scripts/script_utils.cfm">

<cfparam name="url.id" type="numeric" default="0">
<cfparam name="url.status" type="numeric" default="0">

<cfset SetStatusRequest.Status = val(url.status)>
<cfset SetStatusRequest.id = val(url.id)>

<cfinclude template="queries/q_set_status.cfm">

<cfset SetOlMetaDataInfo.id = SetStatusRequest.id>
<cfset SetOlMetaDataInfo.userid = request.stSecurityContext.myuserid>

<cfinclude template="queries/q_update_ol_meta_info.cfm">

<cflocation addtoken="No" url="#ReturnRedirectURL()#">