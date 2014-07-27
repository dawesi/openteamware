<!--- //

	Module:        universal selector
	Description:   Select nace code
	
	Parameters

// --->

<!--- get all available codes ... --->
<cfset q_select_nance_codes = application.components.cmp_Addressbook.ReturnAllNaceCodes(request.stUserSettings.language) />

<!--- base code has 2 chars ... --->
<cfset a_int_index = 2 />

<cfsavecontent variable="a_str">
<ul id="id_ul_nace">
<cfoutput query="q_select_nance_codes">
	
	<cfset a_int_new_index = Len(q_select_nance_codes.code) />
	
	<cfif q_select_nance_codes.currentrow NEQ q_select_nance_codes.recordcount>
	
		<cfset a_int_next_index = Len(q_select_nance_codes['code'][q_select_nance_codes.currentrow + 1]) />
	
	<cfelse>
	
		<cfset a_int_next_index = -1 />
	</cfif>
	
	<li <cfif a_int_new_index IS 2>class="closed"</cfif>>
		
	<!--- {#q_select_nance_codes.code#} ... #a_int_index# next: #a_int_next_index#  --->
	<a href="javascript:UniversalSelectorSetReturnValues(#q_select_nance_codes.code#, '#jsstringformat(q_select_nance_codes.industry_name)#');">#htmleditformat(q_select_nance_codes.industry_name)#</a>
	

	<cfif a_int_next_index GT a_int_new_index>
		<!--- open tag ... --->
		<ul>
	</cfif>
	
	<cfif a_int_next_index LT a_int_new_index>
		<cfloop from="1" to="#(a_int_new_index - a_int_next_index)#" index="ii">
		</ul>
		</cfloop>
	</cfif>
	
	
</cfoutput>
</ul>

</cfsavecontent>

<cfoutput>#a_str#</cfoutput>

<cfsavecontent variable="a_str_js">
$("#id_ul_nace").Treeview();
</cfsavecontent>

<cfset AddJSToExecuteAfterPageLoad(a_str_js, '') />


