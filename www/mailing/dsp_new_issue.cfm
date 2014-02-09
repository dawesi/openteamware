<cfparam name="url.listkey" type="string" default="">
<cfparam name="url.templatekey" type="string" default="">


<cfset CreateEditIssue = StructNew() />
<cfset CreateEditIssue.TemplateKey = url.templatekey>
<cfinclude template="dsp_inc_create_edit_issue.cfm">