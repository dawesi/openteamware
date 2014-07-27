<!--- //

	Component:	Tool
	Action:		GeneratePageScroller
	Description:Ggenerate page scroller


// --->

<cfsavecontent variable="sReturn">
	<cfif arguments.center>
		<div style="text-align:right;padding:4px;">
	</cfif>

	<cfif arguments.current_record IS 1>
		<!--- starts with first record --->
		<img src="/images/si/resultset_first_disabled.png" class="si_img" />
		<img src="/images/si/resultset_previous_disabled.png" class="si_img" />
	<cfelse>

		<cfset a_int_tmp_index = arguments.current_record - arguments.step />

		<!--- JS style or default link? ... --->
		<cfif a_bol_js_link>

			<cfset a_str_link_first = ReplaceNoCase(arguments.current_url, "%startrow%", 1) />
			<cfset a_str_link_previous = ReplaceNoCase(arguments.current_url, "%startrow%", a_int_tmp_index) />

			<a class="nl" href="<cfoutput>#a_str_link_first#</cfoutput>"><img src="/images/si/resultset_first.png" class="si_img" /></a>
			<a class="nl" href="<cfoutput>#a_str_link_previous#</cfoutput>"><img src="/images/si/resultset_previous.png" class="si_img" /></a>

		<cfelse>

			<!--- default link ... --->
			<cfset a_str_link_first = ReplaceOrAddURLParameter(arguments.current_url, "startrow", 1) />
			<a class="nl" href="<cfoutput>#arguments.main_template_filename#</cfoutput>?<cfoutput>#a_str_link_first#</cfoutput>"><img src="/images/si/resultset_first.png" class="si_img" /></a>

			<cfset a_str_link_previous = ReplaceOrAddURLParameter(arguments.current_url, "startrow", a_int_tmp_index) />
			<a class="nl" href="<cfoutput>#arguments.main_template_filename#</cfoutput>?<cfoutput>#a_str_link_previous#</cfoutput>"><img src="/images/si/resultset_previous.png" class="si_img" /></a>

		</cfif>

	</cfif>

	<!--- display where we are ... --->
	<cfset a_tmp_display_current_number = arguments.current_record + arguments.step - 1>
	<cfif a_tmp_display_current_number GT arguments.recordcount>
		<cfset a_tmp_display_current_number = arguments.recordcount>
	</cfif>

	<cfif arguments.recordcount IS 0>
		<cfset arguments.current_record = 0>
	</cfif>

	<cfoutput>#arguments.current_record# - #a_tmp_display_current_number# #GetLangVal('cm_wd_page_scroller_of')# #arguments.recordcount#</cfoutput>

	<cfif (arguments.current_record + arguments.step) GTE arguments.recordcount>
		<img src="/images/si/resultset_next_disabled.png" class="si_img" />
		<img src="/images/si/resultset_last_disabled.png" class="si_img" />
	<cfelse>

		<cfif a_bol_js_link>

			<cfset a_int_tmp_index = arguments.current_record + arguments.step />
			<cfset a_str_link_next = ReplaceNoCase(arguments.current_url, "%startrow%", a_int_tmp_index) />

			<cfset a_int_tmp_index = arguments.recordcount - arguments.step />
			<cfset a_str_link_last = ReplaceNoCase(arguments.current_url, "%startrow%", a_int_tmp_index) />

			<a class="nl" href="<cfoutput>#a_str_link_next#</cfoutput>"><img src="/images/si/resultset_next.png" class="si_img" /></a>
			<a class="nl" href="<cfoutput>#a_str_link_last#</cfoutput>"><img src="/images/si/resultset_last.png" class="si_img" /></a>

		<cfelse>

			<!--- go to next page --->
			<cfset a_int_tmp_index = arguments.current_record + arguments.step />
			<cfset a_str_link_next = ReplaceOrAddURLParameter(arguments.current_url, "startrow", a_int_tmp_index) />
			<a class="nl" href="<cfoutput>#arguments.main_template_filename#</cfoutput>?<cfoutput>#a_str_link_next#</cfoutput>"><img src="/images/si/resultset_next.png" class="si_img" /></a>

			<cfset a_int_tmp_index = arguments.recordcount - arguments.step />
			<cfset a_str_link_last = ReplaceOrAddURLParameter(arguments.current_url, "startrow", a_int_tmp_index) />

			<a class="nl" href="<cfoutput>#arguments.main_template_filename#</cfoutput>?<cfoutput>#a_str_link_last#</cfoutput>"><img src="/images/si/resultset_last.png" class="si_img" /></a>
		</cfif>
	</cfif>

	<cfif arguments.center>
		</div>
	</cfif>
</cfsavecontent>

