<!--- //

	display the form to create a filter
	
	// --->
	
<cfset tmp = SetHeaderTopInfoString(GetLangVal('mail_ph_create_new_filter'))>

<br />

<form action="act_create_filter.cfm" method="POST" name="formfilter" onSubmit="return CheckFormData();">
<input type="hidden" name="redirect" value="no">


<cfset CreateEditFilterRequest.SubmitBtnCaption = "Erstellen">
<cfinclude template="dsp_inc_create_or_edit_filter.cfm">
</form>