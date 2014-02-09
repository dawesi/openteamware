
<!--- javascripts for displaying further information ... --->

<cfset a_str_location = RemoveURLParameter(cgi.QUERY_STRING, "filtertimeframe", "")>

<script type="text/javascript">
	function ChangeFilterTimeframe(newvalue)
		{
		location.href="<cfoutput>#cgi.SCRIPT_NAME#?#a_str_location#</cfoutput>&filtertimeframe="+escape(newvalue);
		}
</script>

<cfset a_str_location = RemoveURLParameter(cgi.QUERY_STRING, "filterworkgroup", "")>

<script type="text/javascript">
	function ChangeFilterWorkgroup(newvalue)
		{
		location.href="<cfoutput>#cgi.SCRIPT_NAME#?#a_str_location#</cfoutput>&filterworkgroup="+escape(newvalue);
		}
</script>

<cfset a_str_location = RemoveURLParameter(cgi.QUERY_STRING, "filterstatus", "")>

<script type="text/javascript">
	function ChangeFilterStatus(newvalue)
		{
		location.href="<cfoutput>#cgi.SCRIPT_NAME#?#a_str_location#</cfoutput>&filterstatus="+escape(newvalue);
		}
</script>

<cfset a_str_location = RemoveURLParameter(cgi.QUERY_STRING, "filterpriority", "")>

<script type="text/javascript">
	function ChangeFilterPriority(newvalue)
		{
		location.href="<cfoutput>#cgi.SCRIPT_NAME#?#a_str_location#</cfoutput>&filterpriority="+escape(newvalue);
		}
</script>

<cfset a_str_location = RemoveURLParameter(cgi.QUERY_STRING, "assignedtouserkey", "")>

<script type="text/javascript">
	function ChangeAssignedtoFilter(newvalue)
		{
		location.href="<cfoutput>#cgi.SCRIPT_NAME#?#a_str_location#</cfoutput>&assignedtouserkey="+escape(newvalue);
		}
</script>

<cfset a_str_location = RemoveURLParameter(cgi.QUERY_STRING, "filtercategory", "")>

<script type="text/javascript">
	function ChangeFilterCategory(newvalue)
		{
		location.href="<cfoutput>#cgi.SCRIPT_NAME#?#a_str_location#</cfoutput>&filtercategory="+escape(newvalue);
		}
</script>

<cfset a_str_location = RemoveURLParameter(cgi.QUERY_STRING, "search", "")>

<script type="text/javascript">
	function DoSearch()
		{
		location.href="<cfoutput>#cgi.SCRIPT_NAME#?#a_str_location#</cfoutput>&search="+escape(document.formsearch.frmsearch.value);
		}
</script>