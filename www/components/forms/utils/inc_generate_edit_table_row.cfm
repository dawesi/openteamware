<!--- //

	Component:	Forms
	Function:
	Description:generate editing table row

				this is an absolut dummy procedure

				all values have to be generated before this routine!



// --->

<!--- hide empty select boxes ... --->
<cfif (a_struct_form_element.datatype IS 'options') AND
	  (ArrayLen(a_struct_form_element.options) IS 0)>
	<!--- no items are available for this option, so hide the select box/radio box ... --->
	<cfset a_struct_form_element.datatype = 'hidden' />
</cfif>

<!--- get the device type (pda, www, wap) --->
<cfset a_str_device_type = a_struct_form_element.usersettings.device.type />

<!--- the number of columns needed --->
<cfset a_int_colspan = a_struct_form_element.colspan />

<!--- hidden input field? --->
<cfif a_struct_form_element.datatype IS 'hidden'>

	<cfsavecontent variable="a_str_edit_table_row">
		<cfoutput>
		<input type="hidden" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#" value="#htmleditformat(a_struct_form_element.input_value)#" />
		</cfoutput>
	</cfsavecontent>

	<cfexit method="exittemplate">
</cfif>

<!--- linebreak ... check if we have already reached the
		end of the row or not --->
<cfif a_struct_form_element.datatype IS 'linebreak'>

	<cfif request.a_struct_form_properties.current_col_index IS request.a_struct_form_properties.columns_no>
		<!--- nothing to do, everything is OK (last col in row) --->
		<cfset a_str_edit_table_row = ''/>
		<cfexit method="exittemplate">
	<cfelse>
		<!--- break line ... --->
		<cfset a_str_edit_table_row = '</tr>'/>

		<!--- reset column index --->
		<cfset request.a_struct_form_properties.current_col_index = 1 />
		<cfexit method="exittemplate">
	</cfif>

</cfif>

<!--- span ... with diviver --->
<cfif a_struct_form_element.datatype IS 'span'>
	<cfsavecontent variable="a_str_edit_table_row">
		<cfoutput>
			<tr class="mischeader">
				<td colspan="#(request.a_struct_form_properties.columns_no * 2)#">
					#htmleditformat(a_struct_form_element.field_name)#
				</td>
			</tr>

			<!--- reset col index ... --->
			<cfset request.a_struct_form_properties.current_col_index = 1>
		</cfoutput>
	</cfsavecontent>

	<cfexit method="exittemplate">
</cfif>

<!--- full custom output ... without any special formatting or escaping! --->
<cfif a_struct_form_element.datatype IS 'custom_full'>
	<cfsavecontent variable="a_str_edit_table_row">
	<cfoutput>#a_struct_form_element.input_value#</cfoutput>
	</cfsavecontent>

	<cfexit method="exittemplate">
</cfif>

<!--- Submit Button --->
<cfif a_struct_form_element.datatype IS 'submit'>
	<cfsavecontent variable="a_str_edit_table_row">
		<cfoutput>
			<tr>
				<td class="field_name"></td>
				<td colspan="#(request.a_struct_form_properties.columns_no)#">
					<input class="btn btn-primary" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#" type="submit" value="#htmleditformat(a_struct_form_element.field_name)#" />

					<cfif IsInPagePopupOrActionPageCall()>
						<cfset a_str_onclick_cancel = 'CloseSimpleModalDialog();return false;' />
					<cfelse>
						<cfset a_str_onclick_cancel = 'ShowSimpleConfirmationDialog(''#JsStringFormat(ReturnRedirectURL())#'');' />
					</cfif>

					<input style="width:auto;" type="button" class="btn" value="#GetLangVal('cm_wd_cancel')#" onclick="#a_str_onclick_cancel#" />


				</td>
			</tr>

			<!--- reset col index ... --->
			<cfset request.a_struct_form_properties.current_col_index = 1>
		</cfoutput>
	</cfsavecontent>

	<cfexit method="exittemplate">
</cfif>

<!--- default datatypes ... do the ordenary things ... --->
<cfsavecontent variable="a_str_edit_table_row">
<cfoutput>

<!--- if index = 1, start new row ... with ID if needed --->
<cfif request.a_struct_form_properties.current_col_index IS 1>
	<tr<cfif Len(a_struct_form_element.tr_id) GT 0>id="#a_struct_form_element.tr_id#"</cfif>>
</cfif>
	<td class="field_name field_label_#a_struct_form_element.input_name#">

		<!--- do not display field name in case of button ... --->
		<cfif ListFindNoCase('submit,button', a_struct_form_element.datatype) IS 0>

			<cfif ListFindNoCase(request.a_struct_form_properties.missing_required_fields_input_names, a_struct_form_element.input_name) GT 0>
				<span class="glyphicon glyphicon-exclamation-sign"></span>
			</cfif>
			#htmleditformat(a_struct_form_element.field_name)#
		</cfif>

	</td>

	<!--- colspan? --->
	<td<cfif a_int_colspan GT 1> colspan="#(a_int_colspan + 1)#"</cfif> class="field_control_#a_struct_form_element.input_name#">

		<!--- output only or real input field --->
		<cfif a_struct_form_element.output_only AND (a_struct_form_element.datatype NEQ 'custom')>

			<cfif FindNoCase('%LANG_', a_struct_form_element.input_value) GT 0>
				<cfset a_str_lang_entryname = ReplaceNoCase(ReplaceNoCase(a_struct_form_element.input_value, '%LANG_', ''), '%', '') />
				#GetLangVal(a_str_lang_entryname)#
			<cfelse>
				#htmleditformat(a_struct_form_element.input_value)#
			</cfif>

		<cfelse>


			<!--- check datatype and create according input element --->
			<cfswitch expression="#a_struct_form_element.datatype#">
				<cfcase value="memo">
					<!--- create a textarea --->
					<textarea id="#a_struct_form_element.input_name#" name="#a_struct_form_element.input_name#" cols="70" rows="5">#htmleditformat(a_struct_form_element.input_value)#</textarea>
				</cfcase>
				<cfcase value="colorselector">

					<cfset a_str_style_bg_color = ''>
					<cfif Len(a_struct_form_element.input_value) GT 0>
						<cfset a_str_style_bg_color = 'background-color:' & a_struct_form_element.input_value />
					</cfif>

					<input style="#a_str_style_bg_color#" type="text" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#" value="#htmleditformat(a_struct_form_element.input_value)#" size="10" />
					<br/>
					<cfinclude template="inc_generate_edit_table_row_colorselector.cfm">
				</cfcase>
				<cfcase value="fileupload">
					<!--- File upload ... --->
					<input type="file" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#">
				</cfcase>
				<cfcase value="simplediv">
					<!--- create a simple div --->
					<div id="#a_struct_form_element.input_name#"></div>
				</cfcase>
				<cfcase value="radio">
					<!--- create a radio group ... --->
					<cfloop from="1" to="#ArrayLen(a_struct_form_element.options)#" index="ii">
						<input #WriteCheckedElement(a_struct_form_element.options[ii].value, a_struct_form_element.input_value)# style="width:auto;" name="#a_struct_form_element.input_name#" type="radio" value="#htmleditformat(a_struct_form_element.options[ii].value)#" class="noborder" /> #htmleditformat(a_struct_form_element.options[ii].name)# <br/>
					</cfloop>
				</cfcase>
				<cfcase value="options">
					<!--- create a select box --->

					<cfif listFindNocase(a_struct_form_element.parameters, 'bigsize') GT 0>
						<cfset a_int_select_size = ArrayLen(a_struct_form_element.options) />
					<cfelse>
						<cfset a_int_select_size = 1 />
					</cfif>

					<select <cfif Len(a_struct_form_element.onchange) GT 0>onChange="#a_struct_form_element.onchange#"</cfif> size="#a_int_select_size#" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#">
						<cfloop from="1" to="#ArrayLen(a_struct_form_element.options)#" index="ii">
							<option #WriteSelectedElement(a_struct_form_element.options[ii].value, a_struct_form_element.input_value)# value="#htmleditformat(a_struct_form_element.options[ii].value)#">#htmleditformat(a_struct_form_element.options[ii].name)#</option>
						</cfloop>
					</select>
				</cfcase>
				<cfcase value="date,datetime">
					<!--- open calendar ... --->
					<cfset a_str_date_value = a_struct_form_element.input_value />
					<cfset a_str_time_hour = 0 />
					<cfset a_str_time_minutes = 0 />

					<!--- check if date ... and format! --->
					<cfif IsDate(a_str_date_value)>
						<cfset a_dt_date_value = ParseDateTime(a_str_date_value) />

						<!--- test ... fix format instead of arguments.usersettings.default_dateformat --->
						<cfset a_str_date_value = LSDateFormat(a_dt_date_value, 'dd.mm.yyyy') />

						<cfset a_str_time_hour = Hour(a_dt_date_value) />
						<cfset a_str_time_minutes = Minute(a_dt_date_value) />
					<cfelse>
						<cfset a_str_date_value =  '' />
					</cfif>

					<!--- smaller if date + time --->
					<cfif a_struct_form_element.datatype IS 'datetime'>
						<cfset a_str_style_date_input = 'width:140px;' />
					<cfelse>
						<cfset a_str_style_date_input = '' />
					</cfif>

					<!--- www --->
					<input class="" style="#a_str_style_date_input# " readonly="yes" type="text" size="8" id="#a_struct_form_element.input_name#" name="#a_struct_form_element.input_name#" value="#htmleditformat(a_str_date_value)#" />

					<!--- <cfset a_str_anchor_name = 'anchor_' & ReplaceNoCase(CreateUUID(), '-', '', 'ALL') />
					<cfset a_str_cal_name = 'cal_' & ReplaceNoCase(CreateUUID(), '-', '', 'ALL') />

					<a onClick="#a_str_cal_name#.select(document.#request.a_struct_form_properties.form_id#.#a_struct_form_element.input_name#,'#a_str_anchor_name#','dd.MM.yy'); return false;" href="##" id="#a_str_anchor_name#"><img alt="..." src="/images/si/calendar.png" width="16" height="16" border="0" align="top" vspace="0" hspace="0" /></a>

					<cfsavecontent variable="a_str_js_cal">var #a_str_cal_name# = new CalendarPopup();</cfsavecontent>

					<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js_cal) /> --->

					<cfset a_str_add_cal_name = RandRange(1, 9999) />

					<cfsavecontent variable="a_str_js_to_add">
						function DoAddCal<cfoutput>#a_str_add_cal_name#</cfoutput>() {
						$('###a_struct_form_element.input_name#').calendar();
						}
					</cfsavecontent>

					<cfset AddJSToExecuteAfterPageLoad('DoAddCal#a_str_add_cal_name#()', a_str_js_to_add) />

					<!--- write time selector? --->
					<cfif a_struct_form_element.datatype IS 'datetime'>
						<select style="width:auto; " name="#a_struct_form_element.input_name#_time_hour" id="#a_struct_form_element.input_name#_time_hour">
							<cfloop from="0" to="23" index="ii">
								<option #WriteSelectedElement(ii, a_str_time_hour)#  value="#ii#">#ii#</option>
							</cfloop>
						</select>

						<select style="width:auto; " name="#a_struct_form_element.input_name#_time_minute" id="#a_struct_form_element.input_name#_time_minute">
							<cfloop from="0" step="5" to="59" index="ii">
								<option #WriteSelectedElement(ii, a_str_time_minutes)# value="#ii#">#ii#</option>
							</cfloop>
						</select>
					</cfif>

				</cfcase>
				<cfcase value="submit">
					<input class="btn btn-primary" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#" type="submit" value="#htmleditformat(a_struct_form_element.field_name)#" />
				</cfcase>
				<cfcase value="boolean">
					<!--- checkbox with 0/1 --->
					<input style="width:auto;" #WriteCheckedElement(a_struct_form_element.input_value, 1)# type="checkbox" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#" class="noborder" value="1" />
				</cfcase>
				<cfcase value="custom">
					<!--- custom content ... no escape! --->
					#a_struct_form_element.input_value#
				</cfcase>
				<cfcase value="selector">
					<!--- a selector ... real value in hidden field, display in
						input field and offer select button ...

						display_value will be displayed as VALUE, the "real" input field receives
						the value from the database --->

					<input type="hidden" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#" value="#htmleditformat(a_struct_form_element.input_value)#"/>
					<input <cfif listFindNocase(a_struct_form_element.parameters, 'readonly') GT 0>readonly="true"</cfif> <cfif Len(a_struct_form_element.onchange) GT 0>onChange="#a_struct_form_element.onchange#"</cfif> class="smaller_input_text" type="text" name="#a_struct_form_element.input_name#_display" id="#a_struct_form_element.input_name#_display" value="#htmleditformat(a_struct_form_element.display_value)#"/>

					<!--- parameters:
						function CallUniversalSelectorInpage(datatype,formid,inputid,inputvalue,displayid,displaytype,servicekey,objectkey,displayvalue)
						see also forms guide --->

					<cfif a_struct_form_element.useuniversalselectorjsfunction IS 1>
						<cfset a_str_js_selector_fn = 'CallUniversalSelectorInpage' />
					<cfelse>
						<cfset a_str_js_selector_fn = a_struct_form_element.selectorJSFunction />
					</cfif>

					<cfset a_str_js_call = a_str_js_selector_fn & '(''' & a_struct_form_element.useuniversalselectorjsfunction_type & ''',''' & request.a_struct_form_properties.form_id & ''',''' & a_struct_form_element.input_name & ''', document.' & request.a_struct_form_properties.form_id & '.' & a_struct_form_element.input_name & '.value' & ',''' & a_struct_form_element.input_name & '_display''' & ',' & '''input''' & ',''' & request.a_struct_form_properties.servicekey & ''',''' & request.a_struct_form_properties.objectkey & ''', document.' & request.a_struct_form_properties.form_id & '.' & a_struct_form_element.input_name & '_display.value,''frmcompany'');' />

					<input class="btn" style="width:auto;" type="button" value="#GetLangval('cm_wd_selector_btn_caption')#" onclick="#a_str_js_call#" />

				</cfcase>
				<cfcase value="rating">
					<!--- some sort of rating ... --->
					<input type="hidden" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#" value="#htmleditformat(a_struct_form_element.input_value)#" />

					<a href="##" onclick="ResetRatingToUnknownValue('#jsstringformat(a_struct_form_element.input_name)#');return false;" class="nl"><img border="0" src="/images/si/bullet_black.png" /></a>

					<span id="id_div_rating_images_#a_struct_form_element.input_name#">
					<cfloop from="1" to="5" index="a_int_rating">
						<a class="nl" href="##" onclick="DoSetCurrentRating('#jsstringformat(a_struct_form_element.input_name)#', '#a_int_rating#');return false;"><img id="#a_struct_form_element.input_name#_#a_int_rating#" class="nl" src="/images/si/bullet_orange.png" border="0" /></a>
					</cfloop>
					</span>
				</cfcase>
				<cfdefaultcase>
					<!--- string and all other --->
					<input <cfif Len(a_struct_form_element.onchange) GT 0>onChange="#a_struct_form_element.onchange#"</cfif> type="text" name="#a_struct_form_element.input_name#" id="#a_struct_form_element.input_name#" value="#htmleditformat(a_struct_form_element.input_value)#" size="40" />
				</cfdefaultcase>
			</cfswitch>

			<cfif a_struct_form_element.required IS 1>
				<span style="color:##990000;">*</span>

				<!--- add to list of required fields ... --->
				<cfset request.a_struct_form_properties.required_fields_in_use = ListAppend(request.a_struct_form_properties.required_fields_in_use, a_struct_form_element.input_name) />

			</cfif>

		</cfif>
	</td>

<!--- in the current column index --->
<cfset request.a_struct_form_properties.current_col_index = request.a_struct_form_properties.current_col_index + a_int_colspan />

<!--- if max. number of columns has been reached, insert a linebreak --->
<cfif request.a_struct_form_properties.current_col_index GT request.a_struct_form_properties.columns_no>
	</tr>
</cfif>

<cfif request.a_struct_form_properties.current_col_index GT request.a_struct_form_properties.columns_no>
	<cfset request.a_struct_form_properties.current_col_index = 1 />
</cfif>

</cfoutput>
</cfsavecontent>





