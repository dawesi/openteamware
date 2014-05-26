
<cfinclude template="../../../login/check_logged_in.cfm">

<!--- first step: 

	the master category list
	
	--->
<cfset a_str_categories = getlangval("cm_ph_categories_masterlist")>
	
<!--- 2nd step:
	load workgroup defined categories
	
	...
	--->
	
<!--- 3rd step
	load user defined categories
	--->
<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "common"
	entryname = "personalcategories"
	defaultvalue1 = ""
	setcallervariable1 = 'a_str_own_categories'>
	
<cfif Len(a_str_own_categories) GT 0>
	<cfset a_str_categories = ListPrepend(a_str_categories, a_str_own_categories)>
</cfif>

<cfset a_str_categories = ListSort(a_str_categories, 'textnocase')>
	
<!--- already defined categories ... --->
<cfparam name="url.categories" type="string" default="">

<cfparam name="url.form" type="string" default="form">

<html>
<head>
	<cfinclude template="../../../style_sheet.cfm">
<title><cfoutput>#GetLangVal("cm_wd_categories")#</cfoutput></title>

<script type="text/javascript">
	function SetCategories()
		{
		var x,y,sReturn;
		// return the categories to the caller form
		sReturn = '';
		
		for(var x=0;x<document.formdummyform.elements.length;x++) 
	     { var y=document.formdummyform.elements[x]; 		
		 
		 	if (y.checked == true)
				{
		 		sReturn = sReturn+ ',' + y.value ;
				}	
		}
		
		
		if (sReturn.length > 0)
			{
			sReturn = sReturn.substr(1, sReturn.length);
			}
		
		opener.document.<cfoutput>#url.form#</cfoutput>.frmcategories.value = sReturn;
		window.close();
		}
</script>
</head>

<body>

<form name="formdummyform" style="margin:0px; ">
<table width="100%" border="0" cellspacing="0" cellpadding="1">
  <tr class="mischeader">
    <td colspan="2" class="contrasttext" style="padding:4px;font-weight:bold;">
		<cfoutput>#GetLangVal("cm_wd_categories")#</cfoutput>
	</td>
  </tr>
  <tr>
	<td colspan="2" align="right" class="bb" style="padding:4px;">
		<input type="button" name="frmbtnsetcategories" onClick="SetCategories();" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>" style="font-weight:bold;">
	</td>
  </tr>
  <cfloop list="#a_str_categories#" index="a_str_category" delimiters=",">
  <tr>
    <td width="25">
		<input type="checkbox" <cfif ListFindNoCase(url.categories,a_Str_category) gt 0>checked</cfif> name="frmcbcategories" class="noborder" value="<cfoutput>#htmleditformat(a_str_category)#</cfoutput>">
	</td>
    <td>
		<cfoutput>#a_str_category#</cfoutput>
	</td>
  </tr>
  </cfloop>

</table>
</form>

</body>
</html>
