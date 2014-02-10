<cfscript>	
	function CheckEntryExistsAndReturnValue(structure, element_name)
		{
				
		
		if (StructKeyExists(structure, element_name))
			{
			return structure[element_name];
			}
				else return '';
		}

</cfscript>