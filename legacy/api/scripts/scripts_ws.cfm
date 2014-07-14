<cfif NOT StructKeyExists(request, 'a_str_request_uuid')>
	<cfset request.a_str_request_uuid = CreateUUID()>
</cfif>

<cfscript>
	/*	
		return the default return structure 		
		*/
		
	function GenerateDefaultReturnStructure()
		{
		var stReturn = StructNew();
		
		stReturn = SetErrorMessageByNumber(-1, stReturn);
		
		if (StructKeyExists(request, 'a_str_request_uuid'))
			{
			stReturn.requestkey = request.a_str_request_uuid;
			}
		
		return stReturn;
		}
	
	/* result is ok */
	function SetResultOK(structure)
		{
		structure.error = 0;
		structure.errormessage = '';
		
		return structure;
		}
		
	/* check if input string is xml */
	function CheckIfInputDataIsXML(xml_string)
		{		
		return IsXML(xml_string);
		}
		
	/* return the error message identified by the code */
	function SetErrorMessageByNumber(number, a_struct)
		{
		var a_str_error_message = '';
		
		a_struct.error = number;
		
		switch(number) {
				/* various errors */
				case '20':
					a_str_error_message = 'Invalid XML document';
					break;
				case '40':
					a_str_error_message = 'Item does not exist or permission denied.';
					break;					
				/* authentification */
				case '100':
					a_str_error_message = 'User does not exist (any more) or login is forbidden.';
					break;
				/* 600 ... contacts */
				case '601':
					a_str_error_message = 'No data of contacts provided in your XML.';
					break;
					
				/* 900 ... sms */
				case '900':
					a_str_error_message = 'SMS could not be sent because an error occured.';
					break;				
				case '901':
					a_str_error_message = 'SMS length must between 1 and 160 chars.';
					break;		
				case '902':
					a_str_error_message = 'Recipient in correct form is needed.';
					break;				
				default:
					a_str_error_message = 'Unknown error';
			}
		a_struct.errormessage = a_str_error_message;
		
		return a_struct;
		}
		
	/* combine several methods */
	function SetErrorMessageByNumberAndReturnXMLResponse(number, a_struct)
		{
		a_struct = SetErrorMessageByNumber(number, a_struct);
		return GenerateReturnXMLDocumentFromReturnStructure(a_struct);
		}
		
	/* check if the structure contains a known error (that means NOT the default return value of -1) */
	function CheckReturnStructureForError(a_struct)
		{
		return (a_struct.error GT 0);
		}
		
	// handle a query
	function HandleQuery(q)
		{
		var sReturn = '';
		var a_str_record = '';
		var i = 0;
		var j = 0;
		var a_arr_rows = ArrayNew(1);
		var a_arr_record = ArrayNew(1);
		var a_str_columnlist = q.columnlist;
		var a_int_listlen = ListLen(a_str_columnlist);  
		var a_struct_record = StructNew();
  
  		for (i = 1; i LTE q.recordcount; i = i + 1)
    		{
			// array holding the record
			// ArrayClear(a_arr_record);
			
			a_str_record = '<item>';
			
			for (j = 1; j LTE a_int_listlen; j = j + 1)
				{
				
				a_col_name = lcase(ListGetAt(a_str_columnlist, j));
				
				// a_arr_record[j] = '<' & a_col_name & '>' & xmlFormat(q[a_col_name][i]) & '</' & a_col_name & '>';				
				
				a_str_record = a_str_record & '<' & a_col_name & '>' & xmlFormat(q[a_col_name][i]) & '</' & a_col_name & '>';	
				}
				
				
			// compose the record xml
			// a_str_record = '<item>' & a_str_record & ArrayToList(a_arr_record, '') & '</item>';			
			a_str_record = a_str_record & '</item>';			
				
			a_arr_rows[i] = a_str_record;
    		}		
			
		sReturn = sReturn & ArrayToList(a_arr_rows, '');
		
		return sReturn;
		}
		
	function HandleSubArray(a, item_name)
		{
		var sReturn = '';
		var a_str_item = '';
		
		for (y = 1; y LTE ArrayLen(a); y=y+1)
			{
			
			// after the first item, always open a new tag ...
			if (y GT 1)
				{
				sReturn = sReturn & '<' & item_name & '>';
				}			
			
			if (IsSimpleValue(a[y]))
				{
				sReturn = sReturn & xmlformat(a[y]);
				}
				
			if (IsStruct(a[y]))
				{
				sReturn = sReturn & HandleSubStructure(a[y]);
				}
				
			if (IsArray(a[y]))
				{
				sReturn = sReturn & HandleSubArray(a[y]);
				}				
				
			// if not the last item, close the tag ...
			if (y LT ArrayLen(a))
				{
				sReturn = sReturn & '</' & item_name & '>';
				}
			
			}
			
		
		return sReturn;
		}
		
	function HandleSubStructure(s)
		{
		var sReturn = '';
		var a_str_item = '';
		var a_str_keylist = StructKeyList(s);
		
		for (x = 1; x LTE ListLen(a_str_keylist); x=x+1)
			{
			
			a_str_item = ListGetAt(a_str_keylist, x);
			
			a_str_item = LCase(a_str_item);
			
			sReturn = sReturn & '<' & a_str_item & '>';
			
			// simple value ...
			if (IsSimpleValue(s[a_str_item]))
				{
				sReturn = sReturn & xmlformat(s[a_str_item]);
				}
				
			// sub structure
			if (IsStruct(s[a_str_item]))
				{
				sReturn = sReturn & HandleSubStructure(s[a_str_item]);
				}
				
			// array ...
			if (IsArray(s[a_str_item]))
				{
				sReturn = sReturn & HandleSubArray(s[a_str_item], a_str_item);
				}
				
			// query
			if (IsQuery(s[a_str_item]))
				{
				sReturn = sReturn & HandleQuery(s[a_str_item]);
				}
				
			sReturn = sReturn & '</' & a_str_item & '>';				
			
			}		
			
		return sReturn;
		
		}

</cfscript>

<cffunction access="public" name="GenerateReturnXMLDocumentFromReturnStructure" output="false" returntype="string">
	<cfargument name="structure" type="struct" required="yes">
	
		<cfset var a_str_xml = ''>
		<cfset var a_str_whole_xml = ''>
		
		<cflog text="creating return structure: #(GetTickCount() - request.a_tc_begin)#" type="Information" log="Application" file="ib_ws">
	
		<cfsavecontent variable="a_str_whole_xml">
			<result>			
				<cfoutput>#HandleSubStructure(arguments.structure)#</cfoutput>
			</result>
		</cfsavecontent>
		
		<cflog text="creating return structure: done - #(GetTickCount() - request.a_tc_begin)#" type="Information" log="Application" file="ib_ws">
		
		<cfxml variable="a_str_xml">
		<cfoutput>#a_str_whole_xml#</cfoutput>
		</cfxml>
		
		<cflog text="cfxml done - #(GetTickCount() - request.a_tc_begin)#" type="Information" log="Application" file="ib_ws">
		
		<cfreturn tostring(a_str_xml)>
</cffunction>