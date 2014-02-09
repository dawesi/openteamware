<h4><cfoutput>#GetLangVal('adm_ph_create_new_customer')#</cfoutput></h4>

<cfinclude template="dsp_inc_select_reseller.cfm">

<cfif request.q_select_reseller.recordcount is 1>
	<cfset url.resellerkey = request.q_select_reseller.entrykey>
</cfif>

<cfinclude template="dsp_inc_edit_or_create_customer.cfm">

<script type="text/javascript">
    Calendar.setup({
        inputField     :    "frmdt_trialphase_end",     // id of the input field
        ifFormat       :    "dd.mm.yy",      // format of the input field
        button         :    "f_trigger_c",  // trigger for the calendar (button ID)
        align          :    "B1",           // alignment (defaults to "Bl")
        singleClick    :    true
    });
</script>