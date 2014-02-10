<!--- //

	Module:		Forms
	Function:	GetFormFields
	Description:Load form fields of the given form
	
	header:		

// --->

<cfquery name="q_select_form_fields" datasource="#request.a_str_db_tools#" cachedwithin="#CreateTimeSpan(0, 0, 20, 0)#">
SELECT
	id,
	entrykey,
	formkey,
	input_name,
	datatype,
	field_name,
	internal_description,
	addvalidation,
	defaultvalue,
	parameters,
	dt_created,
	options,
	visible_description,
	orderno,
	db_fieldname,
	db_fieldname_selector_displayvalue,
	required,
	output_only,
	tr_id,
	onchange,
	CallBackFunctionName,
	CallBackFunctionNameNecessaryArguments,
	default_parameter_scope,
	default_parameter_name ,
	colspan,
	css,
	jsselectorfunction,
	useuniversalselectorjsfunction,
	useuniversalselectorjsfunction_type,
	ignorebydefault
FROM
	form_fields
WHERE
	formkey = '#arguments.formkey#'
ORDER BY
	orderno
;
</cfquery>

