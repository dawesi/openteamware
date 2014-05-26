<!--- //

	Module:		Projects
	Action:		CloseProject
	Description: 
	

// --->

<cfparam name="url.title" type="string" default="">
<cfparam name="url.entrykey" type="string" default="">

<cfif cgi.REQUEST_METHOD IS 'POST'>
	
	<cfset a_struct_data = StructNew() />
	<cfset a_struct_data.dt_closed = Now() />
	<cfset a_struct_data.closed = 1 />
	<cfset a_struct_data.closedbyuserkey = request.stSecurityContext.myuserkey />
	<cfset a_struct_data.status = form.frmstatus />
	<cfset a_struct_data.percentdone = 100 />

	<cfinvoke component="#application.components.cmp_projects#" method="UpdateProject" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="entrykey" value="#url.entrykey#">
		<cfinvokeargument name="data" value="#a_struct_data#">
	</cfinvoke>

	<cfoutput>#GetLangVal('prj_ph_project_has_been_closed')#</cfoutput>
	
	<br /> 
	<cfoutput>
	<input class="btn" type="button" value="#GetLangVal('cm_wd_close_btn_caption')#" onclick="GotoLocHref('index.cfm');" />
	</cfoutput>
	
	<cfexit method="exittemplate">
</cfif>

<cfoutput>
<form class="frm_inpage" action="#cgi.SCRIPT_NAME#?#cgi.query_string#" name="form123" id="form123" method="post" onsubmit="DoHandleAjaxForm(this.id);return false;">
<input type="hidden" name="frmprojectkey" value="#htmleditformat(url.entrykey)#" />
<input type="hidden" name="frmdoclose" value="true" />
<table class="table_details table_edit_form">
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_title')#
		</td>
		<td>
			#htmleditformat(url.title)#
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_stage')#
		</td>
		<td>
			<select name="frmstatus">
				<option value="60">#GetLangVal('crm_wd_sales_stage_60')#</option>
				<option value="70">#GetLangVal('crm_wd_sales_stage_70')#</option>
			</select>
		<td>
	</tr>
	<tr>
		<td class="field_name">
			
		</td>
		<td>
			<input type="submit" name="frmsubmit" class="btn" value="#GetLangVal('prj_ph_close_project')#" />
		</td>
	</tr>
</table>
</form>
</cfoutput>

