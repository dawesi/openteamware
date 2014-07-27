<!--- //
    Version:

    Created by hansjp

    Description:
    	template executed on request end ... maybe there
		are some javascripts to execute now (add to html head)
		do some cleanup if necessary

    Parameters:
    	request.a_arr_js_scripts_to_execute_on_load ... array of
			javascripts to execute on page load


// --->
<!--- are there some javascripts to execute? --->
<cfif StructKeyExists(request, 'a_arr_js_scripts_to_execute_on_load') AND
	  (ArrayLen(request.a_arr_js_scripts_to_execute_on_load) GT 0)>

	  <cfparam name="url.smartload" type="numeric" default="0">

	  <cfset a_str_uuid_js = ReplaceNoCase(CreateUUID(), '-', '', 'ALL') />

	  <!--- special mode means inpage request or action) --->
	  <cfset a_bol_special_mode = (SmartLoadEnabled() OR IsInPagePopupOrActionPageCall()) />

	<!--- save everything in a string variable ... --->
	<cfsetting enablecfoutputonly="true">

	<cfsavecontent variable="a_str_js_to_exec_in_header">

		<cfoutput><script></cfoutput>

		<!--- output functions --->
		<cfloop from="1" to="#ArrayLen(request.a_arr_js_scripts_to_execute_on_load)#" index="ii">
			<cfoutput>#request.a_arr_js_scripts_to_execute_on_load[ii].js_function#</cfoutput>
		</cfloop>

		<!--- the start timer function --->
		<cfoutput>function StartFnOnPageLoad#a_str_uuid_js#() {</cfoutput>


			<cfloop from="1" to="#ArrayLen(request.a_arr_js_scripts_to_execute_on_load)#" index="ii">
				<cfif Len(request.a_arr_js_scripts_to_execute_on_load[ii].js_function_2call) GT 0>
					<cfoutput>#request.a_arr_js_scripts_to_execute_on_load[ii].js_function_2call#</cfoutput>

					<!--- add separator if necessary --->
					<cfif Right(request.a_arr_js_scripts_to_execute_on_load[ii].js_function_2call, 1) NEQ ';'>
						<cfoutput>;</cfoutput>
					</cfif>
				</cfif>
			</cfloop>

			<cfoutput>}</cfoutput>

		<!--- load event ... in case of smartload, no OnLoad Event is fired and therefore a direct timer has to be started --->
		<cfif NOT a_bol_special_mode>
			<cfoutput>$(document).ready(function(){StartFnOnPageLoad#a_str_uuid_js#()});</cfoutput>
		<cfelse>
			<cfoutput>StartFnOnPageLoad#a_str_uuid_js#();</cfoutput>
		</cfif>

		<cfoutput></script></cfoutput>

	</cfsavecontent>

	<cfsetting enablecfoutputonly="false">

	<!--- trim string --->
	<cfset a_str_js_to_exec_in_header = Trim(a_str_js_to_exec_in_header) />

	<!--- if nothing special, try to output in html header, otherwise as string --->
	<cfif NOT a_bol_special_mode>
		<cftry>
			<!--- try as html header --->
			<cfhtmlhead text="#a_str_js_to_exec_in_header#">
			<cfcatch type="any">
				<!--- output it in an ordenary way ... if a cfflush has been fired e.g. --->
				<cfoutput>#a_str_js_to_exec_in_header#</cfoutput>
			</cfcatch>
		</cftry>

	<cfelse>
		<!--- default output string --->
		<cfoutput>#a_str_js_to_exec_in_header#</cfoutput>
	</cfif>

</cfif>

