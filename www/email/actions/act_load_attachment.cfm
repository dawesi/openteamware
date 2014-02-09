<!--- //

	Module:		EMail
	Action:		LoadAttachment
	Description:Deliver an attachment
	

// --->

<cfsetting enablecfoutputonly="Yes">

<cfparam name="url.mailbox" default="" type="string">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">
<cfparam name="url.uid" default="0" type="numeric">
<cfparam name="url.account" type="string" default="#request.stSecurityContext.myusername#">
<cfparam name="url.partid" default="0" type="numeric">
<cfparam name="url.filename" default="" type="string">
<cfparam name="url.contenttype" default="" type="string">
<cfparam name="url.charset" default="" type="string">
<cfparam name="url.compressed" type="numeric" default="0">

<cfif Compare(url.userkey, request.stSecurityContext.myuserkey) NEQ 0>
	
	<!--- check is allowed --->
	<cfinvoke component="#application.components.cmp_security#" method="GetPermissionsForObject" returnvariable="stReturn_rights">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="object_entrykey" value="#url.userkey#:#url.mailbox#">
	  </cfinvoke>
	  
		<cfinvoke component="#application.components.cmp_customer#" method="CheckCompanyAdminRightAvailable" returnvariable="a_bol_admin_right_view_usercontent">
			<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
			<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
			<cfinvokeargument name="permissionname" value="viewusercontent">
		</cfinvoke>				  
	  
	  <cfif a_bol_admin_right_view_usercontent OR (StructKeyExists(stReturn_rights, 'read') AND stReturn_rights.read)>
	  		<!--- load access data --->
			
			<cfinvoke component="/components/email/cmp_accounts" method="GetIMAPAccessdata" returnvariable="stReturn">
				<cfinvokeargument name="userkey" value="#url.userkey#">
			</cfinvoke>
			
			<cfset request.a_str_imap_host = stReturn.a_str_imap_host>
			<cfset request.a_str_imap_username = stReturn.a_str_imap_username>
			<cfset request.a_str_imap_password = stReturn.a_str_imap_password>
			
			<!--- display information ... --->
			<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
				<cfinvokeargument name="entrykey" value="#url.userkey#">
			</cfinvoke>
						
			
	  <cfelse>
	  		<h4>Permission denied.</h4>
			<cfabort>
	  </cfif>

</cfif>


<!--- load attachment ... --->
<cfinvoke component="/components/email/cmp_tools" method="loadattachment" returnvariable="a_struct_result">
  <cfinvokeargument name="server" value="#request.a_str_imap_host#">
  <cfinvokeargument name="username" value="#request.a_str_imap_username#">
  <cfinvokeargument name="password" value="#request.a_str_imap_password#">
  <cfinvokeargument name="foldername" value="#url.mailbox#">
  <cfinvokeargument name="uid" value="#url.id#">
  <cfinvokeargument name="partid" value="#url.partid#">
  <cfinvokeargument name="savepath" value="#request.a_str_temp_directory#">
</cfinvoke>

<cfif a_struct_result.result NEQ "ok">
  <h4>1: error</h4>
  <cfabort>
</cfif>

<cfset a_str_src = a_struct_result.savepath />

<cfif Len(url.contenttype) IS 0>
  <cfset url.contenttype = "binary/unknown" />
</cfif>

<cfif NOT FileExists(a_str_src)>
	<h4>2: error</h4>
	<cfabort>
</cfif>

<cfset a_str_downloadkey = CreateUUID() />
<!--- <cfset a_str_destination_filename = CreateUUID() />
<cfset a_str_destination = request.a_str_temp_directory & request.a_str_dir_separator & a_str_destination_filename />

<cffile action="move" source="#a_str_src#" destination="#a_str_destination#"> --->

<cfquery name="q_insert_dl_link" datasource="#request.a_str_db_tools#">
INSERT INTO
	download_links
	(
	filelocation,
	entrykey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_src#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_downloadkey#">
	)
;
</cfquery>

<!--- redirect ... --->
<cfset a_str_url = "/tools/download/dl.cfm?dl_entrykey=#a_str_downloadkey#&source=#GetFileFromPath(a_str_src)#&contenttype=#urlencodedformat(url.contenttype)#&filename=#urlencodedformat(url.filename)#&app=#urlencodedformat(application.applicationname)#" />

<cflocation addtoken="yes" url="#a_str_url#">

<cfsetting enablecfoutputonly="No">


