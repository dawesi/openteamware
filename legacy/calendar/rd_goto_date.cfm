<!--- // 



	redirect to a certain date from calendar overview



	// --->
	

<cfparam name="form.FRMDT_GO_LEFT" type="string" default="">
<cfparam name="form.frmdt_go" type="string" default="">

<cfif isDate(form.frmdt_go) is true>
	<cfset a_dt_goto = LsParseDateTime(form.frmdt_go)>
	
	<cflocation addtoken="no" url="index.cfm?action=ViewDay&Date=#urlencodedformat(DateFormat(a_dt_goto, "m/d/yyyy"))#">
<cfelseif isDate(form.FRMDT_GO_LEFT)>
	<cfset a_dt_goto = LsParseDateTime(form.FRMDT_GO_LEFT)>
	
	<cflocation addtoken="no" url="index.cfm?action=ViewDay&Date=#urlencodedformat(DateFormat(a_dt_goto, "m/d/yyyy"))#">
<cfelse>
	<cflocation addtoken="no" url="index.cfm">
</cfif>