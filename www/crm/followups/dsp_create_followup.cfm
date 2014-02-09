<!--- //

	Service:	CRM
	Action:		CreateFollowup
	Description:Create a new follow up item
	
	Header:		

// --->

<cfparam name="url.servicekey" type="string" default="">
<cfparam name="url.objectkey" type="string" default="">
<cfparam name="url.title" type="string" default="">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">
<cfparam name="url.projectkey" type="string" default="">

<!--- get a proper title for this item ... --->
<cfif Len(url.title) IS 0>

	<cfswitch expression="#url.servicekey#">
		
		<cfcase value="52227624-9DAA-05E9-0892A27198268072">
			<!--- get name of contact ... --->
			
			<cfset url.title = application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = url.objectkey) />
			
		</cfcase>
	
	</cfswitch>

</cfif>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('crm_ph_enable_follow_up') & ' ' & url.title) />

<cfset CreateEditFollowupJob = StructNew() />
<cfinclude template="dsp_inc_create_edit_followup.cfm">

