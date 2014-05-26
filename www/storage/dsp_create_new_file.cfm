<!--- //

	Module:		Storage
	Action:		Create a new HTML file
	Description: 
	

// --->

<cfparam name="url.entrykey" type="string">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_ph_create_new_file'))>

<cfinvoke component="#application.components.cmp_storage#" method="GetDirectoryInformation" returnvariable="a_struct_dir">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="directorykey" value="#url.entrykey#">
</cfinvoke>


<cfset q_select_directory = a_struct_dir.q_select_directory />

<cfif q_select_directory.recordcount IS 0>
	n/a
	<cfexit method="exittemplate">
</cfif>


<form action="index.cfm?action=DoCreatenewFile" method="post" style="margin:0px; ">
<input type="hidden" name="frmdirectorykey" value="<cfoutput>#url.entrykey#</cfoutput>">
<table class="table_details table_edit_form">
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('sto_wd_directory')#</cfoutput>
		</td>
		<td>
			<cfoutput>#q_select_directory.directoryname#</cfoutput>
		</td>
	</tr>
  <tr>
    <td class="field_name">
		<cfoutput>#getlangval('sto_wd_filename')#</cfoutput>
	</td>
	<td>
		<input type="text" name="frmfilename" size="40">
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<cfoutput>#getlangval('sto_wd_description')#</cfoutput>
	</td>
	<td>
		<input type="text" name="frmdescription" size="40">
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<cfoutput>#getlangval('sto_wd_contenttype')#</cfoutput>
	</td>
	<td>
		text/html
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_text')#</cfoutput>
	</td>
    <td>
		<cfscript>
			fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
			fckEditor.instanceName	= "frmfilecontent";
			fckEditor.value			= "";
			fckEditor.width			= "100%";
			fckEditor.height		= 350;
			fckEditor.toolbarSet	= 'INBOX_Default';
			fckEditor.create(); // create the editor.
		</cfscript>	
	</td>
  </tr>
  <tr>
  	<td class="field_name"></td>
    <td>
		<input type="submit" value="<cfoutput>#getlangval('sto_wd_save')#</cfoutput>" class="btn" />
	</td>
  </tr>
</table>
</form>


