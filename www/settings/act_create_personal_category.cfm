<!--- //

	add a personal category ...
	
	// --->
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "common"
	entryname = "personalcategories"
	defaultvalue1 = ""
	setcallervariable1 = 'a_str_categories'>
	
<cfif Len(form.frmcategoryname) GT 0 AND ListFindNoCase(a_str_categories, form.frmcategoryname) IS 0>
	<cfset a_str_categories = ListPrepend(a_str_categories, form.frmcategoryname)>
</cfif>

<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "common"
	entryname = "personalcategories"
	entryvalue1 = #a_str_categories#>

<cflocation addtoken="no" url="default.cfm?action=categories">