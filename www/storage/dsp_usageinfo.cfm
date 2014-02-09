<!--- //

	Module:		Storage
	Description:Usage
	

// --->

<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_wd_usage'))>

<cfinvoke component = "#application.components.cmp_storage#"   
	method = "GetUsageInfo"   
	returnVariable = "q_query_usage"   
	securitycontext="#request.stSecurityContext#">
</cfinvoke>


<cfset a_int_maxsize_one_perc = q_query_usage.maxsize / 100 />

<cfif q_query_usage.bused neq "" >
	<cfset a_int_use_perc = q_query_usage.bused / a_int_maxsize_one_perc>
<cfelse>
	<cfset a_int_use_perc = 0>
</cfif>



<cfset a_int_free = q_query_usage.maxsize - q_query_usage.bused />
<cfsavecontent variable="a_str_content">
<cfchart format="flash" showlegend="false">
	<cfchartseries type="pie">
		<cfchartdata item="#GetLangVal('sto_wd_used')#" value="#val(q_query_usage.bused)#">
		<cfchartdata item="#GetLangVal('cm_wd_maximal')#" value="#val(a_int_free)#">
	</cfchartseries>
</cfchart>

<table class="table_details">
<cfoutput>
  <tr>
    <td class="field_name">
		#GetLangVal('sto_wd_used')#:
	</td>
    <td>
		#ByteConvert(q_query_usage.bused)#
	</td>
  </tr>
  <tr>
    <td class="field_name">
		#GetLangVal('cm_wd_maximal')#:
	</td>
    <td>
		#ByteConvert(q_query_usage.maxsize)#
	</td>
  </tr>
  <tr>
  	<td class="field_name">%</td>
	<td>
		#DecimalFormat(a_int_use_perc)#%
	</td>
  </tr>
</cfoutput>  
</table>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
	<a href="/administration/?action=shop" target="_blank"><cfoutput>#GetLangVal('cm_ph_shop_increase_space_description')#</cfoutput></a>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('sto_wd_usage'), a_str_buttons, a_str_content)#</cfoutput>

<br><br><br>
<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetTrafficInfo"   
	returnVariable = "q_query_traffic"   
	securitycontext="#request.stSecurityContext#">
</cfinvoke>
<!---
<b>Traffic-Information</b>
<br>
<cfoutput>
<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td>Status:</td>
    <td>
		#ByteConvert(q_query_traffic.kbused)#
	</td>
  </tr>
  <tr>
    <td>Tages-Limit:</td>
    <td>
		#ByteConvert(q_query_traffic.kblimit)#
	</td>
  </tr>
</table>
</cfoutput>
--->

