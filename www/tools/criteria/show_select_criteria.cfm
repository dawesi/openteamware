<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.ids" type="string" default="">
<cfparam name="url.form" type="string" default="">

<!--- if posting, set data --->
<cfif cgi.REQUEST_METHOD is 'post'>
	<cfinclude template="act_set_criteria.cfm">
	
	<cfabort>
</cfif>

<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	<title><cfoutput>#GetLangVal('crm_wd_criteria')#</cfoutput></title>
</head>

<body>

<div class="addinfotext bb mischeader" style="padding:4px;font-weight:bold; "><cfoutput>#GetLangVal('crm_ph_criteria_select')#</cfoutput>&nbsp;</div>



<form action="show_select_criteria.cfm" style="margin:0px; " method="post">
<input type="hidden" name="form_name" value="<cfoutput>#url.form#</cfoutput>">
<div style="text-align:center;padding:6px;" class="bb">
<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
</div>


<!--- display ... --->
<cfinvoke component="#request.a_str_component_crm_sales#" method="BuildCriteriaTree" returnvariable="sReturn">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
	<cfinvokeargument name="options" value="allowedit">
	<cfinvokeargument name="selected_ids" value="#url.ids#">
</cfinvoke>

<cfoutput>#sReturn#</cfoutput>

<div style="text-align:center;padding:6px;" class="bt">
<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
</div>
</form>

</body>
</html>