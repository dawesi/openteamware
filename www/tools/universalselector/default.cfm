<!--- //

	Module:        Universalselector
	Description:   This directory *only* holds inpage files
				   for common tasks
				   
	
// --->

<!--- type of selector --->
<cfparam name="url.type" type="string" default="">

<!--- form id --->
<cfparam name="url.formid" type="string" default="">

<!--- input id (with real value) --->
<cfparam name="url.inputid" type="string" default="">

<!--- current input value --->
<cfparam name="url.inputvalue" type="string" default="">

<!--- display id --->
<cfparam name="url.displayid" type="string" default="">

<!--- display type (input or div) --->
<cfparam name="url.displaytype" type="string" default="input">

<!--- servicekey / objectkey of manipulated object --->
<cfparam name="url.servicekey" type="string" default="">
<cfparam name="url.objectkey" type="string" default="">

<cfswitch expression="#url.type#">
	<cfcase value="workgroupshares">
		<cfinclude template="workgroupshares/dsp_select_inpage.cfm">
	</cfcase>
	<cfcase value="language">
		<cfinclude template="language/dsp_select_inpage.cfm">
	</cfcase>
	<cfcase value="categories">
		<cfinclude template="categories/dsp_select_inpage.cfm">
	</cfcase>
	<cfcase value="criteria">
		<cfinclude template="criteria/dsp_select_inpage.cfm">
	</cfcase>
	<cfcase value="assignedusers">
		<cfinclude template="assignedusers/dsp_select_inpage.cfm">
	</cfcase>
	<cfcase value="nancecode">
		<cfinclude template="nacecode/dsp_select_inpage.cfm">
	</cfcase>
	<cfcase value="account">
		<cfinclude template="account/dsp_select_inpage.cfm">
	</cfcase>
	<cfcase value="superior">
		<cfinclude template="superior/dsp_select_inpage.cfm">
	</cfcase>
	<cfcase value="contact">
		<cfinclude template="contact/dsp_select_inpage.cfm">
	</cfcase>
	<cfdefaultcase>
		<!--- do nothing ... --->
		unknown request
	</cfdefaultcase>
</cfswitch>

