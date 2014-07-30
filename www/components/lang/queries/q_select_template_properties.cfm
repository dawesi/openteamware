<cfquery name="q_select_template_properties" cachedwithin="#CreateTimeSpan(0, 0, 5, 0)#">
SELECT
	entrykey,
	template_name,
	section,
	content
FROM
	templates
WHERE
	(langno = #val(arguments.langno)#)
	AND
	(template_name = '#arguments.template_name#')
;
</cfquery>