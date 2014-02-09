<!--- //

	Component:	Admintool
	Action:		productadministration
	Description:Base template for product administration
		Header:		

// --->

<cfinclude template="../dsp_inc_select_company.cfm">

<cfparam name="url.subaction" type="string" default="">

<cfswitch expression="#url.subaction#">

    <cfcase value="deleteproductgroup">
		<cfinvoke component="#application.components.cmp_products#" method="DeleteProductGroup" returnvariable="stReturn">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="entrykey" value="#url.entrykey#">
		</cfinvoke>
		<cfif NOT stReturn.result>
			<cflocation url="default.cfm?action=productadministration#WriteURLTags()#&ibxerrorno=#stReturn.error#"/>
		</cfif>
		<cfinclude template="dsp_overview.cfm"/>
    </cfcase>
    <cfcase value="deleteproduct">
		<cfinvoke component="#application.components.cmp_products#" method="DeleteProduct" returnvariable="stReturn">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="entrykey" value="#url.entrykey#">
		</cfinvoke>
		<cfif NOT stReturn.result>
			<cflocation url="default.cfm?action=productadministration#WriteURLTags()#&ibxerrorno=#stReturn.error#"/>
		</cfif>
		<cfinclude template="dsp_overview.cfm"/>
    </cfcase>


	<cfcase value="addproduct">
		<cfinclude template="dsp_add_edit_product.cfm"/>
	</cfcase>
	<cfcase value="addproductgroup">
		<cfinclude template="dsp_add_edit_product_group.cfm"/>
	</cfcase>

	<cfdefaultcase>
		<cfinclude template="dsp_overview.cfm"/>
	</cfdefaultcase>
</cfswitch>

