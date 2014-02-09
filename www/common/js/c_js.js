/*

	
	
	*/
	
var a_current_jsrs_array;
var a_current_jsrs_array_fieldlist;
var a_current_row_number = 0;
	
function Get_JSRS_Record(arr, rownumber)
	{
	// den record in ein array schreiben
	a_current_row_number = rownumber;
	return arr[rownumber];
	}
	
function GetCurrentRowNumber()
	{
	return a_current_row_number;
	}
	
function SetCurrent_JSRS(arr)
	{
	a_current_jsrs_array = eval(arr);
	a_current_jsrs_array_fieldlist = eval(arr + '_fields');
	}
function Get_JSRS_FieldValue(array_row, fieldname)
	{
	var jj;
	var fieldindex = -1;
			
	var a_index = eval('a_fieldname_index_' + fieldname.toLowerCase());
	
	return array_row[a_index];		
	}
		