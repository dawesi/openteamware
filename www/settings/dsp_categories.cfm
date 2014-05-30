<!--- //

	Module:		
	Action:		Categories
	Description:	
	

// --->

<cfset a_str_categories = GetUserPrefPerson('common', 'personalcategories', '', '', false) />

<cfset tmp = SetHeaderTopInfoString( GetLangVal('prf_ph_personal_data_own_categories') ) />

<cfoutput>#GetLangVal('prf_ph_own_categories_description')#</cfoutput>
<br /><br />
<b><cfoutput>#GetLangVal('prf_ph_personal_data_own_categories')#</cfoutput> (<cfoutput>#ListLen(a_str_categories)#</cfoutput>)</b><br>

<ul class="img_points">
<cfloop list="#a_str_categories#" index="a_str_category" delimiters=",">
<cfoutput>
	<li>#htmleditformat(a_str_category)# <a href="javascript:deletecategory('#jsstringformat(a_str_category)#');">#si_img('delete')#</a></li>
</cfoutput>

</cfloop>
</ul>
<form action="act_create_personal_category.cfm" method="post">
<cfoutput>#GetLangVal('prf_ph_own_categories_new_category')#</cfoutput>: <input type="text" name="frmcategoryname" size="20">&nbsp;<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" class="btn" />
</form>



<cfset a_str_categories = getlangval("cm_ph_categories_masterlist")>

<b><cfoutput>#GetLangVal('prf_ph_own_categories_default_categories')#</cfoutput> (<cfoutput>#ListLen(a_str_categories)#</cfoutput>)</b>

<ul class="img_points">
<cfloop list="#a_str_categories#" index="a_str_category" delimiters=",">
<cfoutput>
<li>#htmleditformat(a_str_category)#</li>
</cfoutput>
</cfloop>
</ul>

<script type="text/javascript">
	function deletecategory(categoryname)
		{
		if (confirm('<cfoutput>#GetLangValJS('cm_ph_are_you_sure')#</cfoutput>') == true)
			{
			location.href = 'act_delete_category.cfm?categoryname='+escape(categoryname);
			}
		}
</script>

