<?xml version="1.0" encoding="utf-8"?>
<!--- //

	submit outlook ids of entries which have to be deleted

	<io>
		<in>
			<param scope="form" name="datatype" type="integer" default="0">
				<description>
				where to delete the items
				
				1 = olAppointmentItem
				2 = olContactItem
				3 = olTask
				5 = olNotes
				
				</description>
			</param>
			
			<param scope="form" name="ids" type="string"default="">
				<description>
				the outlook ids of the items to delete
				</description>
			</param>
			
			<param scope="form" name="add_ib_infos" type="integer" default="1">
				<description>
				0 = do not add additional information
				1 = yes, add
				</description>
			</param>			
			
			<param scope="form" name="program_id" type="string"default="">
				<description>
				id of program
				</description>
		</param>			
</io>
	
	// --->
<cfparam name="form.datatype" default="-1" type="numeric">
	
<cfswitch expression="#form.datatype#">
	<cfcase value="1">
	<!--- olAppointmentItem: 1 --->
	<cfinclude template="inc_full_data_calendar.cfm">
	</cfcase>
	
	<cfcase value="2">
	<!--- contacts --->
	<cfinclude template="inc_full_data_contacts.cfm">
	</cfcase>
	
	<cfcase value="3">
	<!--- tasks --->
	<cfinclude template="inc_full_data_tasks.cfm">
	</cfcase>
	
	<cfcase value="5">
	<!--- notes --->
	<cfinclude template="inc_full_data_notes.cfm">
	</cfcase>

</cfswitch>