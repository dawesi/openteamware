<!--- //

	Module:		Address Book
	Action:		OwnContactCard
	Description:Allow to create / edit the own contact card
	

// --->

<cfset SetHeaderTopInfoString(GetLangVal('adrb_ph_own_contactcard')) />
<cfset CreateEditItem = StructNew() />

<!--- datatype = own vcard ... --->
<cfset CreateEditItem.Datatype = 9 />

<!--- create a new contact! ... --->
<cfset url.datatype = 0 />

<cfset sEntrykey_of_own_vcard = application.components.cmp_addressbook.GetOwnContactCardEntrykey(request.stSecurityContext.myuserkey) />

<div style="padding:10px;">
	<img src="/images/si/information.png" class="si_img" />
	
	www.openTeamWare.com/vcard/Hansjoerg_Posch/
</div>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#sEntrykey_of_own_vcard#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="create_exclusive_default_lock" value="true">
	<cfinvokeargument name="options" value="DoNotLoadSubItems">
</cfinvoke>

<cfif (Len(sEntrykey_of_own_vcard) GT 0) OR NOT (stReturn.result)>
	<!--- contact does not exist yet ... load personal data ... --->

	<cfset CreateEditItem.action = 'create' />
	<cfset CreateEditItem.Query = QueryNew('firstname,surname,title,email_prim,b_city,b_country,b_street,b_zipcode,sex') />
	
	<cfset QueryAddRow(CreateEditItem.Query, 1) />
	
	<!--- load userdata and set in query object .. --->
	<cfset q_select_user_data = application.components.cmp_user.GetUserData(request.stSecurityContext.myuserkey) />
	
	<cfset QuerySetCell(CreateEditItem.Query, 'firstname', q_select_user_data.firstname) />
	<cfset QuerySetCell(CreateEditItem.Query, 'surname', q_select_user_data.surname) />
	<cfset QuerySetCell(CreateEditItem.Query, 'email_prim', q_select_user_data.username) />
	<cfset QuerySetCell(CreateEditItem.Query, 'title', q_select_user_data.title) />
	<cfset QuerySetCell(CreateEditItem.Query, 'b_city', q_select_user_data.city) />
	<cfset QuerySetCell(CreateEditItem.Query, 'b_country', q_select_user_data.country) />
	<cfset QuerySetCell(CreateEditItem.Query, 'b_street', q_select_user_data.address1) />
	<cfset QuerySetCell(CreateEditItem.Query, 'b_zipcode', q_select_user_data.zipcode) />
	<cfset QuerySetCell(CreateEditItem.Query, 'sex', q_select_user_data.sex) />
	
<cfelse>
	<!--- contact exists --->
	<cfset CreateEditItem.action = 'edit' />
	
	<!--- create or edit? --->
	<cfset CreateEditItem.Action = 'update' />
	<cfset CreateEditItem.Query = stReturn.q_select_contact />
	<cfset CreateEditItem.Entrykey = stReturn.q_select_contact.entrykey />
	<cfset CreateEditItem.Datatype = 9 />
	
</cfif>

<cfinclude template="dsp_inc_create_edit_item.cfm">

