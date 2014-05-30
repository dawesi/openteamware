<!--- //
	Module:            administration (products)
	Action:            productadministration
    Description:       overview of all product groups and products
		
// --->

<cfsavecontent variable="a_str_js">
    function ConfirmDeleteProductGroup(entrykey, productgroupname) {
    	var url = 'index.cfm?action=productadministration<cfoutput>#WriteURLTags()#</cfoutput>&subaction=deleteproductgroup&entrykey=' + escape(entrykey) + '&productgroupname=' + escape(productgroupname);
    	ShowSimpleConfirmationDialog(url);
    }
    
    function ConfirmDeleteProduct(entrykey, productname) {
    	var url = 'index.cfm?action=productadministration<cfoutput>#WriteURLTags()#</cfoutput>&subaction=deleteproduct&entrykey=' + escape(entrykey) + '&productname=' + escape(productname);
		ShowSimpleConfirmationDialog(url);
    }
</cfsavecontent>
<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />

<!--- get all product groups of selected company --->
<cfset a_struct_filter = StructNew()/>
<cfset a_struct_filter.companykey = url.companykey/>
<cfinvoke component="#application.components.cmp_products#" method="FindProductGroups" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#"/>
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#"/>
	<cfinvokeargument name="filter" value="#a_struct_filter#"/>
</cfinvoke>

<cfset q_select_product_groups = stReturn.q_select_product_groups />

<!--- render product groups --->
<cfsavecontent variable="a_str_content_group">
<table class="table table-hover">
	<tr class="tbl_overview_header">
        <td style="width: 20%">
            <cfoutput>#GetLangval('cm_wd_name')#</cfoutput>
        </td>
        <td>
            <cfoutput>#GetLangval('cm_wd_description')#</cfoutput>
        </td>
        <td style="width: 15%">
            <cfoutput>#GetLangval('cm_wd_category')#</cfoutput> 1
        </td>
        <td style="width: 15%">
             <cfoutput>#GetLangval('cm_wd_category')#</cfoutput> 2
        </td>
        <td style="width: 10%">
			 <cfoutput>#GetLangval('cm_wd_action')#</cfoutput>
        </td>
    </tr>
<cfoutput query="stReturn.q_select_product_groups">
    <tr>
        <td>
            <img src="/images/si/package.png" class="si_img" /> #htmleditformat(stReturn.q_select_product_groups.productgroupname)#
        </td>
        <td>
            #htmleditformat(stReturn.q_select_product_groups.description)#
        </td>
        <td>
            #htmleditformat(stReturn.q_select_product_groups.category1)#
        </td>
        <td>
            #htmleditformat(stReturn.q_select_product_groups.category2)#
        </td>
        <td>
            <a href="index.cfm?action=productadministration#WriteURLTags()#&subaction=addproductgroup&entrykey=#stReturn.q_select_product_groups.entrykey#">
                <img src="/images/si/pencil.png" class="si_img" />
            </a>
			<a href="##" onclick="ConfirmDeleteProductGroup('#jsstringformat(stReturn.q_select_product_groups.entrykey)#', '#jsstringformat(stReturn.q_select_product_groups.productgroupname)#');return false;">
                <img src="/images/si/delete.png" class="si_img" />
            </a>
        </td>
    </tr>    
</cfoutput>
</table>
</cfsavecontent>

<cfsavecontent variable="a_str_button_group">
	<input type="button" value="<cfoutput>#GetLangVal('cm_wd_new')#</cfoutput>" onclick="GotoLocHref('index.cfm?action=productadministration<cfoutput>#WriteURLTags()#</cfoutput>&subaction=addproductgroup');" class="btn btn-primary" />
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_product_groups'), a_str_button_group, a_str_content_group)#</cfoutput>
<br /><br />  

<!--- get all products of selected company --->
<cfset a_struct_filter = StructNew()/>
<cfset a_struct_filter.companykey = url.companykey/>
<cfinvoke component="#application.components.cmp_products#" method="FindProducts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#"/>
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#"/>
	<cfinvokeargument name="filter" value="#a_struct_filter#"/>
</cfinvoke>

<!--- render products --->
<cfsavecontent variable="a_str_content_products">
<table class="table table-hover">
	<tr class="tbl_overview_header">
         <td style="width: 20%">
            <cfoutput>#GetLangval('cm_wd_name')#</cfoutput>
        </td>
        <td>
            <cfoutput>#GetLangval('cm_wd_description')#</cfoutput>
        </td>
		<td>
			 <cfoutput>#GetLangval('crm_ph_product_group')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangval('cm_wd_categories')#</cfoutput>
		</td>
        <td style="width:10%"> 
           <cfoutput>#GetLangval('cm_wd_action')#</cfoutput>
        </td>
    </tr>
<cfoutput query="stReturn.q_select_products">
    <tr>
        <td>
           <img src="/images/si/note.png" class="si_img" /> <a href="index.cfm?action=productadministration#WriteURLTags()#&subaction=ShowProduct&entrykey=#stReturn.q_select_products.entrykey#">#htmleditformat(stReturn.q_select_products.title)#</a>
        </td>
        <td>
            #htmleditformat(stReturn.q_select_products.description)#
        </td>
		<td>
			<cfquery name="q_select_group_name" dbtype="query">
			SELECT
				productgroupname
			FROM
				q_select_product_groups
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stReturn.q_select_products.productgroupkey#">
			;
			</cfquery>
			#htmleditformat(q_select_group_name.productgroupname)#
		</td>
		<td>
			#htmleditformat(stReturn.q_select_products.category1)# #htmleditformat(stReturn.q_select_products.category2)#
		</td>
        <td>
            <a href="index.cfm?action=productadministration#WriteURLTags()#&subaction=addproduct&entrykey=#stReturn.q_select_products.entrykey#">
                <img src="/images/si/pencil.png" class="si_img" />
            </a>
        
			<a href="##" onclick="ConfirmDeleteProduct('#jsstringformat(stReturn.q_select_products.entrykey)#', '#jsstringformat(stReturn.q_select_products.title)#');return false;">
                <img src="/images/si/delete.png" class="si_img" />
            </a>
        </td>
    </tr>    
</cfoutput>
</table>
</cfsavecontent>

<cfsavecontent variable="a_str_button_product">
	<input type="button" value="<cfoutput>#GetLangVal('cm_wd_new')#</cfoutput>" onclick="GotoLocHref('index.cfm?action=productadministration<cfoutput>#WriteURLTags()#</cfoutput>&subaction=addproduct');" class="btn btn-primary" />
</cfsavecontent>
<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_products'), a_str_button_product, a_str_content_products)#</cfoutput>


