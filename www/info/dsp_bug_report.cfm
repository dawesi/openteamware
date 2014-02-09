<!--- //

	Module:		Info
	Action:		Bugreport
	Description: 
	

// --->

<cfprocessingdirective pageencoding="utf-8">

<cfparam name="url.exceptionkey" type="string" default="">
<cfparam name="url.errormessage" type="string" default="">

<cfset tmp = SetHeaderTopInfoString('File a bug report') />

<form action="default.cfm?action=DoFileBugReport" method="post">
<input type="hidden" name="frmexceptionkey" value="<cfoutput>#htmleditformat(url.exceptionkey)#</cfoutput>" />

<table class="table_details table_edit_form">
	<tr>
		<td class="field_name"></td>
		<td>
			Bitte verfassen Sie einen möglichst detaillierten Bugreport.
			<br /><br /> 
			Screenshots usw mailen Sie bitte direkt an feedback@openTeamWare.com 
		</td>
	</tr>
	<tr>
		<td class="field_name">
			Service/Dienst
		</td>
		<td>
			<input type="text" value="" name="frmservice" />
		</td>
	</tr>
	<tr>
		<td class="field_name">
			Fehlermeldung
		</td>
		<td>
			<input type="text" value="" name="frmerrormsg" />
		</td>
	</tr>
	<tr>
		<td class="field_name">
			Beschreibung
		</td>
		<td>
			<textarea name="frmdescription"></textarea>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			Ihr Browser
		</td>
		<td>
			<input type="text" value="" name="frmbrowser" />
		</td>
	</tr>
	<tr>
		<td class="field_name"></td>
		<td>
			<input type="submit" value="Absenden" class="btn" />
		</td>
	</tr>
</table>
</form>

