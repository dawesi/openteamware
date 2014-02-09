<!--- //

	forum
	
	// --->
	
<cfinclude template="../dsp_inc_select_company.cfm">


<cfparam name="url.subaction" type="string" default="ShowWelcome">


<cfswitch expression="#url.subaction#">
	<cfcase value="createnewforum">
		<cfinclude template="dsp_new_forum.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="dsp_welcome.cfm">
	</cfdefaultcase>
</cfswitch>