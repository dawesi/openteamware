<table width="100%" border="0" cellspacing="0" cellpadding="4" class="NavLeftTable">

  <tr>

    <td>

	Jetzt noch &uuml;bersichtlicher! [ <a href="../scratchpad/" class="NavLeftTableLink">weiter ...</a> ]

	</td>

  </tr>

  <tr class="NavLeftTableHeader">

    <td class="NavLeftTableHeaderFont"><img src="/images/nav/button_vor.gif" hspace="2" vspace="2" border="0" align="absmiddle"> <a href="default.cfm?action=routeplanner" class="NavLeftTableHeaderLink">Routenplaner</a></td>

  </tr>  

  <tr>

    <td>

	Die komplette Route oder auch nur die genaue Standortanzeige in vielen EU-L&auml;ndern ausgeben. [ <a  class="NavLeftTableLink" href="default.cfm?action=routeplanner">weiter ...</a> ]

	</td>

  </tr>
  

  <tr class="NavLeftTableHeader">

    <td class="NavLeftTableHeaderFont"><img src="/images/nav/button_vor.gif" hspace="2" vspace="2" border="0" align="absmiddle"> <a href="default.cfm?action=shorturl" class="NavLeftTableHeaderLink">ShortURL</a></td>

  </tr>  

  <tr>

  	<td>

	Eine kurze Version f&uuml;r lange Internet-Adressen generieren - sehr praktisch f&uuml;r E-Mails. Das Ende von verst&uuml;mmelten Links!

	[ <a href="default.cfm?action=shorturl" class="NavLeftTableLink">weiter ...</a> ]

	</td>

  </tr>


<!---
  <tr class="NavLeftTableHeader">

    <td class="NavLeftTableHeaderFont"><img src="/images/nav/button_vor.gif" hspace="2" vspace="2" border="0" align="absmiddle"> <a href="default.cfm?action=translate" class="NavLeftTableHeaderLink">Online-&Uuml;bersetzer</a></td>

  </tr>  

  <tr>

    <td>

	Komplette Texte in zahlreiche Sprache &uuml;bersetzen lassen [ <a  class="NavLeftTableLink" href="default.cfm?action=translate">weiter ...</a> ]

	</td>

  </tr>  --->

  <cfif CheckSimpleLoggedIn() AND request.stSecurityContext.myuserid is 2>

  <!---<tr class="NavLeftTableHeader">

    <td class="NavLeftTableHeaderFont">Virenpr&uuml;fung</td>

  </tr>    --->

  <tr>

    <td><a href="default.cfm?action=viruscheck">vcheck</a></td>

  </tr>

  <tr>

  	<td><a href="default.cfm?action=compress">compress</a></td>

  </tr>

  <tr>

  	<td><a href="default.cfm?action=currencyconverter">currency converter</a></td>

  </tr>

  <tr>

  	<td><a href="default.cfm?action=translate">uebersetzen</a></td>

  </tr>

  </cfif>

<cfinclude template="../render/dsp_box_clickstream_left.cfm">
<cfinclude template="../tools/im/dsp_inc_box_left.cfm">
</table>

