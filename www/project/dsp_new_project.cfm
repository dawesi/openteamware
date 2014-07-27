<!--- //

	Service:	Projects
	Function:	NewProject
	Description:
	
	Header:		

// --->

<cfparam name="url.type" type="numeric" default="0">
<cfparam name="url.contactkey" type="string" default="">

<cfset SetHeaderTopInfoString('Neues Projekt erstellen') />

<cfset CreateEditItem = StructNew() />
<cfset CreateEditItem.type = url.type />
<cfset CreateEditItem.contactkey = url.contactkey />

<cfinclude template="dsp_inc_edit_create_project.cfm">


