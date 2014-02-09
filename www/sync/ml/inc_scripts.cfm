<!--- //

	Module:		WebDAV for SyncML Server
	Description:Specific scripts
	

// --->
<cfscript>
	function GetWebDavDate(s) {
		a_str_date = Mid(s, 1, 10);
		a_str_time = Mid(s, 12, 8);
		return ParseDateTime(a_str_date & ' ' & a_str_time);
		}
	
	/* look for a specific element in the xml file and return it as element of a coldfusion strucute if found */
	function CheckExchangeElementAndAddToStructure(returnstruct, exchangeTag, IBXElementName) {		
		a_arr_search = XmlSearch(request.a_struct_action.a_xml_obj, '//D:propertyupdate/D:set/D:prop/' & exchangeTag);
		
		// if element has been found add it to the structure
		if (ArrayLen(a_arr_search) IS 1) {
			tmp = StructInsert(returnstruct, IBXElementName, a_arr_search[1].xmltext, true);
			}
			
		return returnstruct;
		}
		
	/* check if a certain element exists and return it's value if true ... otherwise return empty string */
	function CheckStructkeyExistsAndReturnValue(s, k)
		{
		if (StructKeyExists(s, k)) {
			return s[k];
			} else return '';
		}
		
	// parse SQL for attributes ...
	function GetWebDAVSqlWhereAttribute(sql, sqlfieldname) {
		// default return: null
		var sReturn = '';
		var a_struct_re = StructNew();
		var ii = 0;
		var type = 'contact';
		
		// do a regEx for = comparison
		
		// example for contacts
		// urn:schemas:contacts:givenName"='Mayer'
		if (FindNoCase('urn:schemas:contacts', sqlfieldname) GT 0) {
			
			a_struct_re = ReFindNoCase(sqlfieldname & '\"=''[^'']*', sql, 1, true);
			
			if (a_struct_re.pos[1] GT 0)
				{
				// hit			
				sReturn = Mid(sql, a_struct_re.pos[1], a_struct_re.len[1]);
				
				ii = Find('=', sReturn);
				
				if (ii GT 0)
					{
					sReturn = Mid(sReturn, ii+2, Len(sReturn));
					}
					else sReturn = '';
				}
			}
			
		// example for calendar:
		// urn:schemas:calendar:dtstart"=CAST("2005-08-26T11:00:00.000Z" as ''dateTime'')
		if (FindNoCase('urn:schemas:calendar', sqlfieldname) GT 0)
			{
			a_struct_re = ReFindNoCase(sqlfieldname & '\"=CAST\(\"[^\"]*', sql, 1, true);
			
			if (a_struct_re.pos[1] GT 0)
				{
				// hit			
				sReturn = Mid(sql, a_struct_re.pos[1], a_struct_re.len[1]);
				
				ii = Find('CAST("', sReturn);
				
				if (ii GT 0)
					{
					sReturn = Mid(sReturn, ii + Len('CAST("'), Len(sReturn));
					
					// get a timestamp from the webdav date
					if (Len(sReturn) GT 10)
						{
						sReturn = GetWebDavDate(sReturn);
						} else sReturn = '';
					}
				}
			}	
			
		// we do not have to check for "is null" comparions because they would
		// simple return a zero length string in coldfusion and that's all
		// we have got here.
			
		return trim(sReturn);
		}		
</cfscript> 


