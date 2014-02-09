<!--- //

	Component:	Recording of travelling Reporting output
	Description:Generate report in PDF format, shows travelling records
	
	Header:	

// --->

<cfparam name="url.format" type="string" default="PDF">

<cfset sFilename = application.a_struct_appsettings.properties.CONFIGURATIONDIRECTORY & ReturnDirSeparatorOfCurrentOS() & 'reports' & ReturnDirSeparatorOfCurrentOS() & 'Travelling.cfr' />

<cfinvoke component="#application.components.cmp_products#" method="FindRecordsTravelling" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="useinreport" value="true">
</cfinvoke>

<cfset q_select_recording_travelling = stReturn.q_select_recording_travelling />

<cfloop query="q_select_recording_travelling">
	<cfset q_select_recording_travelling.username = application.components.cmp_user.GetUsernamebyentrykey(entrykey = q_select_recording_travelling.createdbyuserkey) />
</cfloop>


<cfset a_str_output_filename = request.a_str_temp_directory & CreateUUID() />

<CFREPORT format="#url.format#" template="#sFilename#" query="#q_select_recording_travelling#" filename="#a_str_output_filename#">
	<cfreportparam NAME="myusername" VALUE="#request.stSecurityContext.myusername#">
	<cfreportparam NAME="reportname" VALUE="#GetLangVal('adrb_wd_reportname_tr')#">	
	<cfreportparam NAME="generby" VALUE="#GetLangVal('adrb_wd_generby')#">
	<cfreportparam NAME="inboxname" VALUE="#GetLangVal('adrb_wd_inboxname')#">
	<cfreportparam NAME="date" VALUE="#GetLangVal('crm_wd_product_date')#">
	<cfreportparam NAME="kilometers" VALUE="#GetLangVal('adrb_wd_kilometers')#">
	<cfreportparam NAME="username" VALUE="#GetLangVal('cm_wd_username')#">
</CFREPORT>

<cfswitch expression="#url.format#">
	<cfcase value="Excel">
		<cfset a_str_format = 'xls' />
	</cfcase>
	<cfcase value="PDF">
		<cfset a_str_format = 'pdf' />
	</cfcase>
</cfswitch>

<cfheader name="Content-Disposition" value="attachment; filename=report.#a_str_format#">
<cfcontent deletefile="false" file="#a_str_output_filename#" type="application/#a_str_format#">

