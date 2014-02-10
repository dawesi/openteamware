<!--- //

	Component:	Render
	Function:	GenerateCustomHTMLHeader
	Description:Output custom html header
	
// --->

<cfif StructKeyExists(request, 'a_struct_current_service_action')>
	<!--- check if we've got some html headers to include --->

	
	<cfif StructKeyExists(url, 'printmode') AND url.printmode>
		<script type="text/javascript">
			a_bol_printmode = 1;
		</script>
	</cfif>
	
	
	
	<!--- custom includes --->
	<cfif ListFindNoCase( "40049B7D-875C-4515-AEF61EDD4FE2DEE1,C8EC440D-0571-4EF7-9FFDF0CB87E78544", request.STSECURITYCONTEXT.MYCOMPANYKEY) GT 0>
	
		<style type="text/css" media="all">
			.field_label_frmsuperiorcontactkey, .field_label_frmnance_code, .field_control_frmnance_code, .field_control_frmsuperiorcontactkey {
				display:none;
				}
		</style>
	
	</cfif>
	
</cfif>