<!--- //

	Module:		Mailings
	Action:		NewProfile
	Description: 
	

// --->


<cfset tmp = SetHeaderTopInfoString('Newsletter') />

<cfset CreateEditNLProfile = StructNew() />
<cfinclude template="dsp_inc_edit_create_profile.cfm">

