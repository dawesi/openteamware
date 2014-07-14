


<form action="dsp_new_search.cfm" method="post">
<table border="0" cellspacing="0" cellpadding="4">
  <tr>
  	<td>
		Ordner:
	</td>
	<td>
		<select name="frmfolder">
			<option value="">Alle</option>
			<option value="INBOX">Posteingang</option>
		</select>
	</td>
  </tr>
  <tr>
    <td>Von:</td>
    <td>
		<input type="text" name="frmfrom">
	</td>
  </tr>
  <tr>
    <td>An:</td>
    <td>
		<input type="text" name="frmto">
	</td>
  </tr>
  <tr>
    <td>Betreff:</td>
    <td>
		<input type="text" name="frmsubject">
	</td>
  </tr>
  <tr>
    <td>Nachricht:</td>
    <td>
		<input type="text" name="frmessage">
	</td>
  </tr>  
  <tr>
  	<td>
		Alter
	</td>
	<td>
		<select name="frmage">
			<option value="0">unbegrenzt</option>
		</select>
	</td>
  </tr>
  <tr>
  	<td>
		
	</td>
	<td>
		<input type="checkbox" name="frmcb_flagged" value="1">
		&nbsp;
		markiert
	</td>
  </tr>
  <tr>
  	<td>
		
	</td>
	<td>
		<input type="checkbox" name="frmcb_attachments" value="1">
		&nbsp;
		Attachments vorhanden
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" value="Start ...">
	</td>
  </tr>
</table>

</form>