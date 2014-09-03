<cfinclude template="/login/check_logged_in.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<!--- //

	create data export

	// --->

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cfabort>
</cfif>

<cfparam name="form.frmentrykeys" type="string" default="">
<cfparam name="form.frmformat" type="string" default="csv">
<cfparam name="form.frmendoding" type="string" default="UTF-8">

<!--- load contacts ... --->

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.entrykeys = form.frmentrykeys />

<cfset stOpts = StructNew() />
<cfset stOpts.maxrows = 99999 />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="loadowndatafields" value="true">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="loadoptions" value="#stOpts#" />
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts>

<!--- select datafields --->
<cfquery name="q_select_contacts" dbtype="query">
SELECT
	firstname,surname,sex,email_prim,email_adr,title,company,aposition,birthday,
	b_street,b_city,b_zipcode,b_country,b_telephone,b_fax,b_url,
	p_street,p_city,p_zipcode,p_country,p_telephone,p_fax,p_url,
	categories
FROM
	q_select_contacts
;
</cfquery>

<!--- create CSV --->
<cfset variables.a_str_csv = QueryToCSV2(variables.q_select_contacts)>

<!--- deliver file ... --->
<cfset a_str_uuid = createuuid()>
<cfset sFilename = getTempDirectory() & a_str_uuid>

<cffile charset="#form.frmencoding#" action="write" output="#a_str_csv#" file="#sFilename#" addnewline="no">

<!--- forward to download page ... --->
<cflocation addtoken="yes" url="/tools/download/dl.cfm?source=#urlencodedformat(a_str_uuid)#&contenttype=#urlencodedformat('text/csv')#&filename=export.csv&app=#urlencodedformat(application.applicationname)#&local=true">