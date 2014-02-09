<!--- //

	demo: javascript version
	
	// --->
	

<cfoutput query="q_select_tasks" startrow="#url.startrow#" maxrows="#a_int_displayitemsperpage#">

</cfoutput>

<cfquery name="q_select_tasks" dbtype="query" maxrows="#a_int_displayitemsperpage#">
SELECT
	entrykey,status,title,priority
FROM
	q_select_tasks
;
</cfquery>

<cfinclude template="../tests/mx/js/js.cfm">

<cfsavecontent variable="a_str_js">
	<JS_LOOP var="ii_int_loop" argument="js_arr_tasks" type="array" set_bol_vars_false="surname_type">
	<JS_GET_RECORD var="arow" index="ii_int_loop" array="js_arr_tasks">
	
	<JS_IF field="priority" array="js_arr_tasks" compare="3" method="is">
		<tr style="background-color:##FBDEC4;" onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);" ID="idtr
		<JS_ROWNUMBER output="true"/>
		">
	<JS_ELSE>
		<tr onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);" ID="idtr
		<JS_ROWNUMBER output="true"/>
		">
	</JS_IF>

		<td class="bb">
			<input class="noborder" type="Checkbox" name="frmcbtasks" value="
			<JS_OUTPUT field="entrykey" type="query">
			">
		</td>
		<td class="bb">
			<a 
			<JS_IF field="status" array="js_arr_tasks" compare="0" method="is">
				class="statusdone"
			</JS_IF>
			href="default.cfm?action=ShowTask&entrykey=
			<JS_OUTPUT field="entrykey" type="query">
			">
			<JS_OUTPUT field="title" type="query">
			</a>
		</td>
	</tr>
	</JS_LOOP>
</cfsavecontent>

<cfoutput>#CreateJSArrayOfQuery(q_select_tasks, 'js_arr_tasks', true, 1, 0)#</cfoutput>

<script type="text/javascript">

SetCurrent_JSRS('js_arr_tasks');
var anfang = new Date().getTime();
<cfoutput>
#BuildJSOutput(a_str_js)#
</cfoutput>
var ende = new Date().getTime();
var zeit = ende - anfang;
document.write('<h1>' +zeit + '</h1>');

</script>