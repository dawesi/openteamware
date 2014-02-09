<!--- 

	various helper scripts

 --->
<cfscript>
	function FieldHasBeenREEdited(field)
		{
		
		if (ListFindNoCase(a_str_edited_fields, field) GT 0)
			{
			return 'class="REChanged"';
			}
		
		}
		
	function WriteOriginalValue(field)
		{
		var astr = '';
		var avalue= '';
		
		if (CompareNoCase(EditOrCreateContact.action, 'edit') NEQ 0)
			{
			return '';
			}
			
		if (NOT IsDefined('a_struct_original_values'))
			{
			return '';
			}
		
		if (StructKeyExists(a_struct_original_values[1], field))
			{
			avalue = a_struct_original_values[1][field];
			
			if (ListFindNoCase('sex', field) GT 0)
				{
				return '';
				}
				
			if (compare(EditOrCreateContact.query[field][1], a_struct_original_values[1][field]) IS 0)
				{
				return '';
				}
			
			if (Len(avalue) IS 0)
				{
				return '';
				}
				
			if (isDate(avalue))
				{
				avalue = DateFormat(avalue, 'dd.mm.yy');
				}
				
			astr = '<font class="addinfotext">vormals: '&htmleditformat(avalue)&'</font><br>';
			
			}
		
		return astr;
		}
</cfscript>