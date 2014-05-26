
<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.categoryname" type="string" default="">

	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "common"
	entryname = "personalcategories"
	defaultvalue1 = ""
	setcallervariable1 = 'a_str_categories'>
	
	
<cfif Len(url.categoryname) GT 0>
	
	<cfset ii = ListFindNoCase(a_str_categories, url.categoryname)>
	
	<cfif ii GT 0>
		<cfset a_str_categories = ListDeleteAt(a_str_categories, ii)>
	</cfif>

</cfif> 

<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "common"
	entryname = "personalcategories"
	entryvalue1 = #a_str_categories#>

<cflocation addtoken="no" url="index.cfm?action=categories">