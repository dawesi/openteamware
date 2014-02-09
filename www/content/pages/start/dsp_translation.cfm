<!---
	
	get the home language of this user ... 

	--->


<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td class="b_all" style="letter-spacing:2px;font-size:10px;text-transform:uppercase;"> 
      &nbsp;<b><cfoutput>#GetLangVal("extras_wd_translation")#</cfoutput></b> </td>
  </tr>
  <form action="/extras/default.cfm?action=dotranslate" method="post" name="formtranslation">
    <tr> 
      	<td>


		<table border="0" cellspacing="0" cellpadding="2" width="100%">
		  <tr>
			<td align="right">Sprache:</td>
			<td>
			<select name="frmmode">
				<option value="en_fr">English -> French</option>
				<option value="en_de">English -> Deutsch</option>
				<option value="en_it">English -> Italian</option>
				<option value="en_pt">English -> Portugese</option>
				<option value="en_es">English -> Spanish</option>
				<option value="fr_en">French -> English</option>
				<option value="de_en" selected>Deutsch -> English</option>
				<option value="it_en">Italian -> English</option>
				<option value="pt_en">Portugese -> English</option>
				<option value="ru_en">Russian -> English</option>
				<option value="es_en">Spanish -> English</option>
			</select>
			</td>
		  </tr>
		  <tr>
			<td align="right" valign="top">Text:</td>
			<td valign="top">
			<textarea name="frmtext" cols="40" rows="5" style="width:80%;"></textarea>
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>
			<a href="javascript:document.formtranslation.submit();">Uebersetzen ...</a>
			</td>
		  </tr>
		</table>
		</td>
    </tr>
  </form>
</table>
