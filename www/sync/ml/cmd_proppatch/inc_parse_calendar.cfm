<cfset a_struct_data = StructNew()>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:dtstart', 'date_start')>
<cfset a_struct_data.date_start = GetWebDavDate(a_struct_data.date_start)>

<!--- make UTC date/time ... only if not Nokia --->
<cfif FindNoCase('Nokia', request.q_select_device.manufactor_model) IS 0>
	<cfset a_struct_data.date_start = DateAdd('h', request.stUserSettings.utcdiff, a_struct_data.date_start)>
</cfif>

<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:dtend', 'date_end')>
<cfset a_struct_data.date_end = GetWebDavDate(a_struct_data.date_end)>

<cflog text="request.q_select_device.manufactor_model: #request.q_select_device.manufactor_model#" type="Information" log="Application" file="ib_syncml">

<cfif FindNoCase('Nokia', request.q_select_device.manufactor_model) IS 0>
	<cfset a_struct_data.date_end = DateAdd('h', request.stUserSettings.utcdiff, a_struct_data.date_end)>
</cfif>

<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HN:subject', 'title')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HN:textdescription', 'description')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:department', 'department')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:profession', 'position')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:location', 'location')>

<cfset request.a_struct_calendar = a_struct_data>