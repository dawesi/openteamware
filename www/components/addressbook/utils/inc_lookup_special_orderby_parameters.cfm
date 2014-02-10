<!--- //

	Component:     Address Book
	Action:		   ShowAllContacts
	Description:   Check the special order by commands and
				   create filters according to this settings ...
	
	Parameters

// --->

<cfswitch expression="#arguments.orderby#">
	<cfcase value="lastdisplayed">
	
	<!--- load the last displayed contacts
		and create a CRM filter for this type ... --->
		
	<cfmodule template="/common/person/getuserpref.cfm"
		entrysection = "addressbook"
		entryname = "lastshown.entrykeys#arguments.filterdatatypes#"
		defaultvalue1 = ""
		forceloadfromdatabase = true
		userid = #arguments.securitycontext.myuserid#
		setcallervariable1 = "sEntrykeys_lastshown_contacts">
		
	<cfif Len(sEntrykeys_lastshown_contacts) GT 0>
	
		<!--- Now add the entrykeys to filter ... arguments.crmfilter --->		
		<cfset arguments.crmfilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = arguments.crmfilter,
				area = 2,
				internaldatatype = 0,
				operator = 7,
				internalfieldname = 'entrykey',
				comparevalue = sEntrykeys_lastshown_contacts) />
			
	</cfif>
	</cfcase>
	<cfcase value="ownitems">
	<!--- the own items of the user ... --->

	<!--- contact / string / userkey / IS / compare to userkey --->	
	<cfset arguments.crmfilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = arguments.crmfilter,
			area = 2,
			internaldatatype = 0,
			operator = 0,
			internalfieldname = 'userkey',
			comparevalue = arguments.securitycontext.myuserkey) />
	
	</cfcase>
	<cfcase value="latelyadded">
	<!--- lately added ... --->
	<!--- <cfset arguments.orderby = '-dt_created' /> --->
	
	<!--- contact / date / dt_created / greater / compare to three weeks ago --->	
	<cfset arguments.crmfilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = arguments.crmfilter,
			area = 2,
			internaldatatype = 3,
			operator = 2,
			internalfieldname = 'dt_created',
			comparevalue = DateAdd('d', -30, Now())) />
	</cfcase>
</cfswitch>

