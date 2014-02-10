<!---//

	generate editing table row
	
	//--->
	
<cfsavecontent variable="sReturn">
<cfoutput>

<!--- new row ... with ID if needed --->
<tr<cfif Len(arguments.tr_id) GT 0>id="#arguments.tr_id#"</cfif>>
	<td class="field_name">
		#htmleditformat(field_name)#
	</td>
	<td>

		<!--- output only or real input field --->
		<cfif arguments.output_only>
			
			#htmleditformat(arguments.input_value)#
			
		<cfelse>
		
			<!--- check datatype and create according input element --->
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="memo">
					<!--- create a textarea --->
					<textarea id="#arguments.input_name#" name="#arguments.input_name#" cols="70" rows="3">#htmleditformat(arguments.input_value)#</textarea>
				</cfcase>
				<cfcase value="date_____">
					<!--- date --->
				</cfcase>
				<cfcase value="radio">
					<!--- create a radio group ... --->
					<cfloop from="1" to="#ArrayLen(arguments.options)#" index="ii">
						<input #WriteCheckedElement(arguments.options[ii].value, arguments.input_value)# style="width:auto;" name="#arguments.input_name#" type="radio" value="#htmleditformat(arguments.options[ii].value)#" class="noborder"> #htmleditformat(arguments.options[ii].name)# <br/>
					</cfloop>				
				</cfcase>
				<cfcase value="options">
					<!--- create a select box --->
					
					<cfif listFindNocase(arguments.parameters, 'bigsize') GT 0>
						<cfset a_int_select_size = ArrayLen(arguments.options)>
					<cfelse>
						<cfset a_int_select_size = 1>
					</cfif>
					
					<select size="#a_int_select_size#" name="#arguments.input_name#" id="#arguments.input_name#">
						<cfloop from="1" to="#ArrayLen(arguments.options)#" index="ii">
							<option #WriteSelectedElement(arguments.options[ii].value, arguments.input_value)# value="#htmleditformat(arguments.options[ii].value)#">#htmleditformat(arguments.options[ii].name)#</option>
						</cfloop>
					</select>
				</cfcase>
				<cfdefaultcase>
					<!--- string and all other --->
					<input type="text" name="#arguments.input_name#" id="#arguments.input_name#" value="#htmleditformat(arguments.input_value)#" size="40"/>
				</cfdefaultcase>
			</cfswitch>
	
		</cfif>
	</td>
</tr>
</cfoutput>
</cfsavecontent>