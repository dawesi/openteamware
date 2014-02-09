<fieldset class="bg_fieldset">
	<legend>
		<a href="http://www.google.at/search?q=sourceid=mozilla-search" target="_blank"><img align="absmiddle" src="/images/icon/img_search_32x32.gif" width="32" height="32" hspace="2" vspace="2" border="0"> <cfoutput>#GetLangVal('start_ph_websearch_caption')#</cfoutput></a>		
	</legend>
	
	
<div class="div_startpage_contentbox_content">

<table width="100%" border="0" cellspacing="0" cellpadding="2">
<!---<tr>
	<td>
		<img src="/images/icon/img_search_32x32.gif" vspace="2" hspace="2" align="absmiddle">
	</td>
	<td class="addinfotext" width="100%">
		<div class="bb">
	 		<b><cfoutput>#GetLangVal('start_ph_websearch_caption')#</cfoutput></b>
	 	</div>
	</td>
</tr>--->
  <form action="/rd/toolbar/search/search.cfm" method="get" target="_blank" name="formwebsearch">
  <tr>
  	<td colspan="2">
	
	<table border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td><cfoutput>#GetLangVal('start_wd_search_websearch')#</cfoutput>:</td>
		<td>
			<input type="text" name="search" size="10">
			&nbsp;
			<select name="searchengine">
				<option value="google">Google</option>	
				<option value="alltheweb">AllTheWeb</option>							
				<option value="altavista">Altavista</option>
			</select>
			&nbsp;
			<a href="javascript:document.formwebsearch.submit();"><img src="/images/icon/magnifier.gif" width="12" height="12" border="0" align="absmiddle" vspace="3" hspace="3"> <cfoutput>#GetLangVal('start_wd_search_websearch')#</cfoutput></a>
		</td>
	  </tr>
	</table>
	
	</td>
  </tr>
  </form>
</table>

</div>

</fieldset>
