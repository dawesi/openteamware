<!--- //

	// --->
	
<cfset SelectCompanyNewsRequest.SelectTopNewsOnly = 1>
<cfinclude template="queries/q_select_news.cfm">

<cfif q_select_news.recordcount GT 0>
	<div class="mischeader bb" style="background-color:#FFCC66;padding:6px;">
	
	<b>Wichtige Mitteilung:</b>
	<cfoutput query="q_select_news">
		<a href="#q_select_news.href#" target="_blank">#q_select_news.title#</a>
	</cfoutput>

	</div>
	
	<!--- check if this popup has been shown before ... --->
	<cfmodule template="/common/person/getuserpref.cfm"
		entrysection = "companynewsticker"
		entryname = "#q_select_news.entrykey#"
		defaultvalue1 = "1">
		
	<!---<cfoutput>#a_str_person_entryvalue1#</cfoutput>--->
	
	<cfif a_str_person_entryvalue1 IS 1>
		<script type="text/javascript">
   			var url;
    		url = '/content/pages/companynewsticker/popup/';
    		var mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=170,HEIGHT=140");
    		mywin.window.focus();
		</script>
	</cfif>
	
	<cfmodule template="/common/person/saveuserpref.cfm"
		entrysection = "companynewsticker"
		entryname = "#q_select_news.entrykey#"
		entryvalue1 = #(a_str_person_entryvalue1 + 1)#>	
</cfif>