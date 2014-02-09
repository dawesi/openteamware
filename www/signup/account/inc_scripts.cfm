<cfscript>
	function CheckDataStored(s)
		{
		if (StructKeyExists(session, 'a_struct_data') AND StructKeyExists(session.a_struct_data, s))
			{
			return session.a_struct_data[s];
			}
				else return '';
		}
</cfscript>