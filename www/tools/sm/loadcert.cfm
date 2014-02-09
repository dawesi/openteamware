
<cfparam name="url.id" type="numeric" default="0">

<cfinvoke component="/components/tools/cmp_sm" method="GetCertFromATrust" returnvariable="a_bin_return">
	<cfinvokeargument name="id" value="#url.id#">
</cfinvoke>

<cfset a_str_file = request.a_str_temp_directory & createuuid()>

<cffile action="write" addnewline="no" file="#a_str_file#" output="#a_bin_return#" nameconflict="makeunique">

<cfcontent file="#a_str_file#" type="binary/unknown">