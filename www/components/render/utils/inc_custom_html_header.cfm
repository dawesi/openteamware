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
	
	
	
</cfif>