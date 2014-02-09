<!--- //

	eigene texte plazieren lassen ...
	
	// --->
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "content.addressbook"
	entryname = "remoteedit"
	defaultvalue1 = "">	
	
<cfset a_str_remote_edit = a_str_person_entryvalue1>

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "content.calendar"
	entryname = "invitation"
	defaultvalue1 = "0">	
	
<cfset a_str_invitation_text = a_str_person_entryvalue1>
	
<cf_disp_navigation mytextleft="Eigene Texte">
<br>
Eigene Text fuer die Funktion "RemoteEdit" im Adressbuch:<br>
<form action="act_save_own_text.cfm" method="post">
	<textarea name="frmtext" cols="40" rows="5"><cfoutput>#htmleditformat(a_str_remote_edit)#</cfoutput></textarea>
	<br>
	<input type="submit" value="Speichern">
</form>