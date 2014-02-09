<cfparam name="url.resellerkey" type="string" default="">

<cfparam name="url.action" type="string" default="ShowWelcome">

<cfswitch expression="#url.action#">
	<cfcase value="ShowWelcome">
		<cfinclude template="dsp_welcome.cfm">
	</cfcase>
	
	<cfcase value="gencodes">
		<cfinclude template="dsp_gen_codes.cfm">
	</cfcase>
	
	<cfcase value="showcodes">
		<cfinclude template="dsp_show_codes.cfm">
	</cfcase>
</cfswitch>