<!--- //

	Module:		Address Book
	Action:		Edit item (contact, account, ...)
	Description:
	

	
	
	Edit an account, contact or lead ... load data and call edit form
	
	Set the default exclusive lock
	
// --->

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="create_exclusive_default_lock" value="true">
	<cfinvokeargument name="options" value="DoNotLoadSubItems">
	<cfinvokeargument name="loadmetainformations" value="true">
</cfinvoke>

<!--- check for errors ... --->
<cfif NOT stReturn.result>
	
	<cfswitch expression="#stReturn.error#">
		<cfcase value="5300">
			<!--- A lock could not be obtained. --->
			<cfset a_str_custom_msg = application.components.cmp_locks.GenerateLockDefaultInformationString(entrykey = stReturn.lock_information.lock.entrykey) />
			
			<cflocation addtoken="false" url="index.cfm?action=ShowItem&entrykey=#url.entrykey#&ibxerrorno=5300&ibxerrormsg=#urlencodedformat(a_str_custom_msg)#">			
		</cfcase>
		<cfdefaultcase>
			an error occured ... TODO: default handling
		</cfdefaultcase>
	</cfswitch>
	
	<cfexit method="exittemplate">
</cfif>

<cfif NOT stReturn.rights.edit>
	Not allowed.
	<cfexit method="exittemplate">
</cfif>

<cfset tmp = SetHeaderTopInfoString(MakeFirstCharUCase(GetLangVal('cm_wd_edit'))) />

<cfset CreateEditItem = StructNew() />
<cfset CreateEditItem.Action = 'update' />
<cfset CreateEditItem.Query = stReturn.q_select_contact />
<cfset CreateEditItem.Entrykey = stReturn.q_select_contact.entrykey />
<cfset CreateEditItem.Datatype = stReturn.q_select_contact.contacttype />

<cfinclude template="dsp_inc_create_edit_item.cfm">


