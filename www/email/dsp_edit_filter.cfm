<!--- //

	edit a filter
	
	// --->
<cfparam name="url.id" type="numeric" default="0">
	
<!--- load filter --->
<cfset SelectSingleFilterRequest.id = url.id>
<cfinclude template="queries/q_select_single_filter.cfm">



<cfif q_select_single_filter.recordcount is 0>
	<b>Kein Filter gefunden</b>
	<cfexit method="exittemplate">
</cfif>

<!--- set parameters --->
<form action="act_update_filter.cfm" method="post">
<input type="hidden" name="frmid" value="<cfoutput>#url.id#</cfoutput>">
<cfset CreateEditFilterRequest.Filtername = q_select_single_filter.filtername>
<cfset CreateEditFilterRequest.SubmitBtnCaption = "Speichern">
<cfset CreateEditFilterRequest.Filteraction = q_select_single_filter.filtertype>
<cfset CreateEditFilterRequest.filterparam = q_select_single_filter.parameter>
<cfset CreateEditFilterRequest.comparisonfield = q_select_single_filter.comparisonfield>
<cfset CreateEditFilterRequest.comparison = q_select_single_filter.comparison>
<cfset CreateEditFilterRequest.comparisonparam = q_select_single_filter.comparisonparm>


<cfif CreateEditFilterRequest.Filteraction is 1>
	<!--- move to folder ... --->
	<cfset CreateEditFilterRequest.filterparam = "INBOX."&CreateEditFilterRequest.filterparam>
</cfif>

<cfset CreateEditFilterRequest.stoponsuccess = q_select_single_filter.stoponsuccess>
<cfset CreateEditFilterRequest.antispamfilter = q_select_single_filter.antispamfilter>

<!---<cfdump var="#CreateEditFilterRequest#">--->
<cfinclude template="dsp_inc_create_or_edit_filter.cfm">
</form>