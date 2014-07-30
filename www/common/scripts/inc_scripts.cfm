<!--- //

	Description:Various helper functions
	
// --->


<!--- display a string ... and shorten it with "abc ..." if necessary --->
<cfscript>
	
// return the database name for a certain operation
// works without any parameters
// optional:
// 1st parameter ... operation ... e.g. SELECT, UPDATE, DELETE ... default is always SELECT
// 2nd parameter: securitycontext (otherwise securitycontext stored in request scope is taken)
// 3rd parameter: ?
function GetDSName() {
	var a_str_request_servicekey = '';
	var a_ds_name = '';
	var a_str_operation = 'SELECT';
	var stSecurityContext = 0;
	
	// logged in user?
	if (StructKeyExists(request, 'stSecurityContext')) {
		stSecurityContext = request.stSecurityContext;
		}
	
	if (ArrayLen(arguments) GTE 1) a_str_operation = arguments[1];
	if (ArrayLen(arguments) GTE 2) stSecurityContext = arguments[2];
	
	// called from a component? there in the var scope the servicekey is stored
	// otherwise use the default request service key
	if (StructKeyExists(variables, 'sServiceKey')) {
		a_str_request_servicekey = variables.sServiceKey;
		} else a_str_request_servicekey = request.sCurrentServiceKey;
	
	switch (a_str_request_servicekey)
		{
		case '52227624-9DAA-05E9-0892A27198268072': {
			a_ds_name = request.a_str_db_crm;
			break;
			}
		case 'form': {
			aResult = form;
			break;
			}
		}
		
	return(a_ds_name);
	
	}
	
// check if a user is logged in the simply way ...
// we do this by checking if the structure "stSecurityContext" exists
// in the request scope
// returns true / false
function CheckSimpleLoggedIn() {
	return StructKeyExists(request, 'stSecurityContext');
	}
	
// check if the usersettings structure exists in request scope
function CheckUserSettingsStructExists() {
	return StructKeyExists(request, 'stUserSettings');
	}
	
// Return the redirect URL after an action ...
// Go through the possible actions and return URL for CFLOCATION tag
// written by hansjoerg posch
function ReturnRedirectURL() {
	var a_bol_usersettings_exist = CheckUserSettingsStructExists();
	
	// 1st possibility: last page is stored in usersettings in request scope
	if (a_bol_usersettings_exist) {
		if ((StructKeyExists(request.stUserSettings, 'LastPageRequest')) AND (Len(request.stUserSettings.LastPageRequest) GT 0)) {
			return request.stUserSettings.LastPageRequest;
			}
		}	
	
	// 2nd possibility: get last page from default file
	if (StructKeyExists(request, 'a_struct_current_service_actions')) {
		return 'index.cfm?action=' & request.a_struct_current_service_actions.defaultaction;
		}
	
	// 3rd possibility: use cgi.http_referer
	return cgi.http_referer;
	}
	
// copy all necessary structure of the security/userpref/personaldata structures
// from the session scope to the request scope, so that these data
// can be accessed without the usage of cflocks
//
// Important: Must be called form a cflocked function because we're accessing
// session vars
function CopyUserStructuresFromSession2RequestScope() {

	if (StructKeyExists(session, 'stSecurityContext')) {
		request.stSecurityContext = Duplicate(session.stSecurityContext);
		}
		
	if (StructKeyExists(session, 'stUserSettings')) {
		request.stUserSettings = Duplicate(session.stUserSettings);
		}
		
	if (StructKeyExists(session, 'a_struct_personal_properties')) {
		request.a_struct_personal_properties = Duplicate(session.a_struct_personal_properties);
		}

	return true;
	}
	
// returns an unique lock name for usage in "name" property of cflock
function ReturnUniqueCFLockName() {
	return "cflcock_" & CreateUUID();
	}

// return a user perference value from 
// section: section
// name: name
// defaultvalue: default return value in case value does not exist
// userparameter: e.g. url.filterkey ... load data from given parameter
// savesetting: boolean ... save setting to person table
//
// works only with logged in users!
function GetUserPrefPerson(section, name, defaultvalue, userparameter, savesetting) {
	var areturn = defaultvalue;
	// has a value been found?
	var a_bol_value_found = false;
	// generate hash value for caching ...
	var a_str_hash_id = Hash(UCase(request.stSecurityContext.myuserid & section & name));
	// does the cached value exist?
	var a_bol_value_cached = StructKeyExists(request, 'stUserSettings') AND StructKeyExists(request.stUserSettings.cached_personal_properties, a_str_hash_id);
	// user parameter exists?
	var a_bol_user_parameter_exists = ((Len(userparameter) GT 0) AND (IsDefined(userparameter)));
	
	// return user definied value if it exists	
	if (a_bol_user_parameter_exists) {
		areturn = Evaluate(userparameter);
		a_bol_value_found = true;
		}
		
	// next try, check cached value and database ...
	if (NOT a_bol_value_found) {
		
		// does cached value exist?
		if (a_bol_value_cached) {
			areturn =  request.stUserSettings.cached_personal_properties[a_str_hash_id];
			a_bol_value_found = true;
			} else {
					// no cached version available ... load directly from database
					areturn = application.components.cmp_person.GetUserPreference(userid = request.stSecurityContext.myuserid,
																section = section,
																name = name,
																defaultvalue = defaultvalue);
					}
		
		}
		
	// save settings?		
	if (savesetting) {
		application.components.cmp_person.SaveUserPreference(userid = request.stSecurityContext.myuserid, section = section, name = name, value = areturn);
		
		// delete property in session and request!
		if (a_bol_value_cached) {
			StructDelete(session.stUserSettings.cached_personal_properties, a_str_hash_id);
			StructDelete(request.stUserSettings.cached_personal_properties, a_str_hash_id);
			}
		}
		
	return areturn;
	}


// add an item to a structure only if it is not empty
function AddToStructIfNotEmpty(struct, item, value) {
	var stReturn = Duplicate(struct);
	if (Len(value) GT 0) {stReturn.item = value;}
	return stReturn;
	}

// get translation value for a certain language
function GetLangValByLangNo(langno, id) {
	var result = '';
	
	if (StructKeyExists(Application.langdata['lang' & langno], id)) {
		result =  Application.langdata['lang' & langno][id];
		}
	
	return result;
	}

// get translation value
function GetLangVal(id) {
	var result = '';
	// default language ... use the one stored in the app settings
	var iLangNo = application.a_struct_appsettings.properties.DefaultLanguage;
	var aCurrentLangStruct = 0;
	var a_bol_client_lang_set = StructKeyExists(client, 'langno');
	var a_bol_lang_loaded = false;
	
	// use user-set language if possible ...
	if (a_bol_client_lang_set) { iLangNo = client.langno; }
	
	/* always take langdata ... a_bol_lang_loaded = StructKeyExists(Application, 'lang' & iLangNo);
	if (a_bol_lang_loaded) {
		aCurrentLangStruct = Application['lang' & iLangNo];
		} else aCurrentLangStruct = Application.lang0;*/
	
	// if lang has not yet been set as cookie, do this now
	//if (NOT StructKeyExists(cookie, 'user_language')) {
	//	application.components.cmp_tools.SetCookie(name = 'user_language', value = iLangNo, expires = 'never');	
	//	}
	
	// return translation data if exists (otherwise return default language version)
	if (StructKeyExists(Application.langdata['lang' & iLangNo], id)) {
		result = Application.langdata['lang' & iLangNo][id];
		}
			else {
				if (a_bol_client_lang_set GT 0) {
					result = GetLangValByLangNo(application.a_struct_appsettings.properties.DefaultLanguage, id);
					}
				}
	return result;
	}
	
// get lang val in JS format
function GetLangValJS(e) {
	return jsstringformat(GetLangVal(e));
	}	
// get current lang no
function GetLangNo() {
	return client.langno;
	}

function DisplayNiceEmailAddress(s) {
	var sReturn = s;
	var ii = 0;
	// if no name exists, use default ...
		
	// if only simple address, return original string
	if (ListLen(sReturn, '"') LT 2) {
		return sReturn;
		}
			
	ii = FindNoCase('"', sReturn);
		
	sReturn = Mid(sReturn, ii+1, Len(sReturn));
		
	ii = FindNoCase('"', sReturn);
		
	// if empty "" sender then use original
	if (ii LTE 2) return s;
	
	sReturn = Mid(sReturn, 1, ii-1);
		
	return sReturn;
	}
	
/**
	 * Convert the query into a CSV format using Java StringBuffer Class.
	 * 
	 * @param query 	 The query to convert. (Required)
	 * @param headers 	 A list of headers to use for the first row of the CSV string. Defaults to all the columns. (Optional)
	 * @param cols 	 The columns from the query to transform. Defaults to all the columns. (Optional)
	 * @return Returns a string. 
	 * @author Qasim Rasheed (qasimrasheed@hotmail.com) 
	 * @version 1, March 23, 2005 
	 */
	function QueryToCSV2(query){
		var csv = createobject( 'java', 'java.lang.StringBuffer');
		var i = 1;
		var j = 1;
		var cols = "";
		var headers = "";
		var endOfLine = chr(13) & chr(10);
		if (arraylen(arguments) gte 2) headers = arguments[2];
		if (arraylen(arguments) gte 3) cols = arguments[3];
		if (not len( trim( cols ) ) ) cols = query.columnlist;
		if (not len( trim( headers ) ) ) headers = cols;
		headers = listtoarray( headers );
		cols = listtoarray( cols );
		
		for (i = 1; i lte arraylen( headers ); i = i + 1)
			csv.append( '"' & headers[i] & '";' );
		csv.append( endOfLine );
		
		for (i = 1; i lte query.recordcount; i= i + 1){
			for (j = 1; j lte arraylen( cols ); j=j + 1){
				if (isNumeric( query[cols[j]][i] ) )
					csv.append( query[cols[j]][i] & ';' );
				else
					csv.append( '"' & query[cols[j]][i] & '";' );
				
			}
			csv.append( endOfLine );
		}
		return csv.toString();
	}
	
function ShortenString(astr, alen) {
	var aResult = "";
	
	aResult = astr;
	
	if (Len(astr) GT alen) {
		aResult = Mid(astr, 1, alen) & '...';
		}
	
	return(aResult);
	}
	
// ** show "nice" mobile number
function BeautifyNumber(Number){
	Number = ReplaceNoCase(Number, " ", "", "ALL");	
	Number = ReplaceNoCase(Number, "-", "", "ALL");	
	Number = ReplaceNoCase(Number, "/", "", "ALL");	
	Number = ReplaceNoCase(Number, "(", "", "ALL");	
	Number = ReplaceNoCase(Number, ")", "", "ALL");	
	return Number;
	}
/**
 * Converts a query object into an array of structures.
 * 
 * @param query 	 The query to be transformed 
 * @return This function returns a structure. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, September 27, 2001 
 */
function QueryToArrayOfStructures(theQuery){
	var theArray = arraynew(1);
	var cols = ListtoArray(theQuery.columnlist);
	var row = 1;
	var thisRow = "";
	var col = 1;
	for(row = 1; row LTE theQuery.recordcount; row = row + 1){
		thisRow = structnew();
		for(col = 1; col LTE arraylen(cols); col = col + 1){
			thisRow[cols[col]] = theQuery[cols[col]][row];
		}
		arrayAppend(theArray,duplicate(thisRow));
	}
	return(theArray);
}
	
/* return the scope from the scope name ... we try to avoid the ugly evaluate function */
function GetScopeByScopeName(scopename) {
	switch (scopename)
		{
		case 'url': {
			aResult = url;
			break;
			}
		case 'form': {
			aResult = form;
			break;
			}
		case 'request': {
			aResult = request;
			break;
			}
		case 'session': {
			aResult = session;
			break;
			}
		case 'client': {
			aResult = client;
			break;
			}
		case 'variables': {
			aResult = variables;
			break;
			}				
		default: {
			aResult = Evaluate(scopename);
			break;
			}
		}
	return(aResult);
	}
	
function GetInBoxccPriorityFromOutlookPriority(apriority) {
	var a_int_result = 2;
	switch (apriority)
		{
		case "2":
			{
			a_int_result = "3";
			break;
			}
		case "1":
			{
			a_int_result = "2";
			break;
			}
		case "0":
			{
			a_int_result = "1";
			break;
			}					
		}
		
	return(a_int_result);
	}
	
function GetInBoxccStatusFromOutlookStatus(astatus){
	var a_int_result = 1;
	switch (astatus)
		{
		case "2":
			{
			a_int_result = "0";
			break;
			}
		case "4":
			{
			a_int_result = "3";
			break;
			}
		case "1":
			{
			a_int_result = "2";
			break;
			}			
		case "0":
			{
			a_int_result = "1";
			break;
			}
		case "3":
			{
			a_int_result = "4";
			break;
			}
		
		}
		
	return(a_int_result);
	}
		
/**
 * Removes rows from a query.
 * Added var col = "";
 * No longer using Evaluate. Function is MUCH smaller now.
 * 
 * @param Query 	 Query to be modified 
 * @param Rows 	 Either a number or a list of numbers 
 * @return This function returns a query. 
 * @author Raymond Camden (ray@camdenfamily.com) 
 * @version 2, October 11, 2001 
 */
function QueryDeleteRows(Query,Rows) {
	var tmp = QueryNew(Query.ColumnList);
	var i = 1;
	var x = 1;

	for(i=1;i lte Query.recordCount; i=i+1) {
		if(not ListFind(Rows,i)) {
			QueryAddRow(tmp,1);
			for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) {
				QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][i]);
			}
		}
	}
	return tmp;
}

/**
*   Returns single row from query which contains value in current field (from arguments)
*	        only if query contains one record which satisfied condition (first occurrence)
*	@param Query   Query to be used
*   @param field   Column name of Query
*	@param value   value which will be compared	
*
*/


function GetSingleRowFromQuery(Query, field, value) {
	var tmp = QueryNew(Query.ColumnList);
	var i = 1;
	var x = 1;
	var cols = ListtoArray(Query.columnlist);
	
	for(i=1;i lte Query.recordCount; i=i+1) {    // loops all records
		
		if(Query['#field#'][i] EQ value) {
			
			QueryAddRow(tmp,1);
			
			for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) {
					QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][i]);
			}
			return tmp;
		}
	
	}
	return tmp;
	
}

// extract email address
function ExtractEmailAdr(astr) {
	var aExtractedEmailAdr = '';
	var AReResult = arraynew(2);
	
	AReResult = ReFindNoCase('[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*',astr,1,TRUE);
	
	if (AReResult.pos[1] gt 0) {
		aExtractedEmailAdr = Mid(astr, AReResult.pos[1], AReResult.len[1]);
		} else aExtractedEmailAdr = "";
	
	return(aExtractedEmailAdr);
	}

/**
 * Applies a simple highlight to a word in a string.
 * 
 * @param string 	 The string to format. 
 */
 
function highLight(str,word) {
	var front = "<span style=""background-color: yellow;"">";
	var back = "</span>";
	var matchCase = false;
	if(ArrayLen(arguments) GTE 3) front = arguments[3];
	if(ArrayLen(arguments) GTE 4) back = arguments[4];
	if(ArrayLen(arguments) GTE 5) matchCase = arguments[5];
	if(NOT matchCase) return REReplaceNoCase(str,"(#word#)","#front#\1#back#","ALL");
	else return REReplace(str,"(#word#)","#front#\1#back#","ALL");
}
	
// check if a string is "0" - if yes return "kein betreff"
function CheckZeroString(s)	{
	var astr = "";
	
	astr = s;
	
	if (len(trim(s)) is 0) {
		// return the local version of "no subject"
		astr = GetLangVal("cm_ph_no_subject");
		}
	
	return astr;
	}
	
// replace parameter for a loop (f.e. goto page 1, 2, 4
function ReplaceOrAddURLParameter(querystring, parameter, newvalue){
	var astr = "";
		
	if (FindNoCase(parameter, querystring) gt 0) {
		astr = REReplaceNoCase(querystring, "&"&parameter&"=[^&]*", "&"&parameter&"="&urlencodedformat(newvalue), "ALL");
		
		} else astr = querystring&"&"&parameter&"="&urlencodedformat(newvalue);
	
	return astr;
	}
// write selected if param 1 = param 2 
function WriteSelectedElement(Param1, Param2) {
	if (ComparenoCase(Param1, Param2) is 0)
		{
		return "selected";
		} else return "";
	}
	
// write checked if param 1 = param 2
function WriteCheckedElement(Param1, Param2) {
	if (ComparenoCase(Param1, Param2) is 0)
		{
		return "checked";
		} else return "";
	}
	
function WriteBackgroundHighlight(Param1, Param2) {
	if (ComparenoCase(Param1, Param2) is 0)
		{
		return "class=""mischeader""";
		} else return "";
	}

function GetUTCTime(Adt) {
	var a_tz_info = GetTimeZoneInfo();
	
	return DateAdd("h", a_tz_info.utcHourOffset, Adt);
	}
	
// return UTC now in ODBC tz format
function GetODBCUTCNow() {
	return CreateODBCDateTime(GetUTCTime(Now()));
	}
	
function GetUTCTimeFromUserTime(Adt) {
	return DateAdd('h', request.stUserSettings.utcdiff, adt);
	}	
	
function GetUTCTimeFromArgumentsUserTime(Adt) {
	return DateAdd('h', arguments.usersettings.utcdiff, adt);
	}
	
function GetLocalTime(Adt) {	
	return DateAdd('h', -request.stUserSettings.utcdiff, adt);
	}

/**
 * Removes HTML from the string.
 * 
 * @param string 	 String to be modified. 
 * @return Returns a string. 
 * @author Raymond Camden (ray@camdenfamily.com) 
 * @version 1, December 19, 2001 
 */
function StripHTML(str) {
	return REReplaceNoCase(str,"<[^>]*>","","ALL");
}

// ** return friendly foldername instead of IMAP name ** // */
function Returnfriendlyfoldername(str) {
	var areturn = str;
	
	if (ListFindNoCase('INBOX,INBOX.Drafts,INBOX.Junkmail,INBOX.Sent,INBOX.Trash', str) IS 0) {
		// custom folder
		areturn = ReplaceNoCase(str, 'INBOX.', '');
		
		if (FindNoCase('.', areturn) GT 0) {
			areturn = ListLast(areturn, '.');
			}		
			
		return areturn;
		}
		
	switch(str) {
		case "INBOX":
			{
			areturn = GetLangVal("mail_wd_folder_inbox");
			break;
			}
		case "INBOX.Drafts":
			{
			areturn = GetLangVal("mail_wd_folder_draft");
			break;
			}
		case "INBOX.Junkmail":
			{
			areturn = "Junkmail";
			break;
			}			
		case "INBOX.Sent":
			{
			areturn = GetLangVal("mail_wd_folder_sent");
			break;
			}
		case "INBOX.Trash":
			{
			areturn = GetLangVal("mail_wd_folder_trash");
			break;
			}
		
		}
		
		//areturn = ReplaceNoCase(areturn, "INBOX.", "");
		
		
		return areturn;
		}
		
// *** remove the url parameter from the query string
//
// querystring ... the cgi.QUERY_STRING
// parameter: the parameter=value pair to remove from querystring
//
// returned is a clean parameter
function RemoveURLParameter(querystring, parameter)
	{
	var sReturn = "";
	sReturn = querystring;
	
	if (len(querystring) gt 0)
		{
				
		sReturn = ReReplaceNoCase(querystring, parameter&"=[^\&]*", "", "ALL");
		
		// remove double &&
		// sReturn = ReplaceNoCase(sReturn, "&&", "&", "ALL");
		
		if (Len(sReturn) GT 0)
			{
			if (CompareNoCase(Mid(sReturn, len(sReturn), 1), "&") is 0)
				{
				sReturn = mid(sReturn, 1, len(sReturn)-1);
				}
			}			
		}
			
	return sReturn;		
	}

// return the mailbox name without special chars
function ReturnStringWithOnlyAZ09(s) {
	return ReReplaceNoCase(s, '[^a-z,0-9]*', '', 'ALL');
	}

function ReturnStringWithOnly_AZ09(str) {
	return ReReplaceNoCase(str, '[^a-z,0-9]*_]', '', 'ALL');
	}

function GetBeautyfulMailboxname(str) {
	var astr = "";
	astr = htmleditformat(str);
	astr = rereplacenocase(str, "[^A-Za-z]*", "", "ALL");
		
	return astr;
	}

/**
 * Wraps a chunk of text at a given character count.
 * 
 * @param str 	 The string to format. 
 * @param maxline 	 Length of each line, defaults to 40. 
 * @param br 	 The newline string. Defaults to &lt;br&gt;. 
 * @param breaklongwords 	 Boolean to break words longer than maxline. Defaults to true. 
 * @author Dave Pomerance (dpomerance@mos.org) 
 * @version 2, November 30, 2001 
 */


/** NEW
 * Wraps a chunk of text at a given character count.
 * Note that this function needs to be renamed if you are going to use it on a CF MX 6.1 server since 6.1 now has a native wrap() function (that serves a different purpose).
 * 
 * @param str 	 The string to format. (Required)
 * @param maxline 	 Length of each line, defaults to 40. (Optional)
 * @param br 	 The newline string. Defaults to &lt;br&gt;. (Optional)
 * @param breaklongwords 	 Boolean to break words longer than maxline. Defaults to true. (Optional)
 * @return Returns a string. 
 * @author Dave Pomerance (dpomerance@mos.org) 
 * @version 2, August 19, 2003 
 */
function WrapText(str) {
	var maxline = 40;
	var br = "<br />";
	var breaklongwords = 1;
	var filetype = "pc";
	var eol = chr(13) & chr(10);
	var lineofstr = "";
	var returnstr = "";
	var pos = "";

	//check optional args
	if(ArrayLen(arguments) eq 2) {
		maxline = arguments[2];
	} 
	else if(ArrayLen(arguments) eq 3) {
		maxline = arguments[2];
		br = arguments[3];
	}
	else if(ArrayLen(arguments) eq 4) {
		maxline = arguments[2];
		br = arguments[3];
		breaklongwords = arguments[4];
	}

	// determine file type
	if (find(chr(10), str)) {
		if (find(chr(13), str)) {
			filetype = "pc";
			eol = chr(13) & chr(10);
		} else {
			filetype = "unix";
			eol = chr(10);
		}
	} else if (find(chr(13), str)) {
		filetype = "mac";
		eol = chr(13);
	}

	// add space due to CF "feature" of ignoring list elements of length 0
	str = replace(str, eol, " #chr(13)#", "ALL") & " ";
	
	for (i=1; i lte listlen(str, chr(13)); i=i+1) {
		lineofstr = listgetat(str, i, chr(13));
		if (lineofstr eq " ") {
			returnstr = returnstr & br;
			lineofstr = "";
		} else {
			// remove the space
			if (len(lineofstr) GTE 2)
			{
			lineofstr = left(lineofstr, len(lineofstr)-1);
			}
		}
		while (len(lineofstr) gt 0) {
			// determine wrap point
			if (len(lineofstr) lte maxline) pos = len(lineofstr);
			else {
				pos = maxline - find(" ", reverse(left(lineofstr, maxline))) + 1;
				if (pos gt maxline) {
					if (breaklongwords) pos = maxline;
					else {
						pos = find(" ", lineofstr, 1);
						if (pos eq 0) pos = len(lineofstr);
					}
				}
			}
			// add line to returnstr
			returnstr = returnstr & left(lineofstr, pos) & br;
			// remove line from lineofstr
			lineofstr = removechars(lineofstr, 1, pos);
		}
	}

	return returnstr;
}

/* write an image link for an image of the SI collection */
/* params: image-name without path and extension, e.g. "information" */
function si_img(imagename) {
	return '<img src="/images/si/' & imagename & '.png" class="si_img" alt="' & htmleditformat(imagename) & '" />';
	}

/**
 * Parses subjects returned by CFPOP.
 * 
 * @param subject 	 Subject string to parse. (Required)
 * @return Returns a structure. 
 * @author Axel Glorieux (axel@misterbuzz.com) 
 * @version 1, September 27, 2002 
 */
function parsepopsubject(subj){
	var re = "=\?([^?]+)\?([BbQq])\?([^?]+)\?=";
	var re2 ="=([[:xdigit:]]{2})";
	var tmp = refind(re,subj,1,true);
	var obj = structnew();
	var type = "";
	var start = 1;
	var eos = false;
	var tmp2 = "";
	var newch = "";
	if (arraylen(tmp.pos) NEQ 4){
		obj.subject = subj;
		obj.encoding = "";
		return obj.subject;
	}
	
	obj.encoding = mid(subj,tmp.pos[2],tmp.len[2]);
	obj.subject = mid(subj,tmp.pos[4],tmp.len[4]);
	type = mid(subj,tmp.pos[3],tmp.len[3]);
	switch (type){
		case "b":{
			obj.subject = tostring(tobinary(obj.subject));
			break;
		}
		case "q":{
			while (NOT eos){
				obj.subject = replace(obj.subject,"_"," ","ALL");
				tmp2 = refind(re2,obj.subject,start,true);
				if (tmp2.pos[1]){
					newch = chr(inputbasen(mid(obj.subject,tmp2.pos[2],tmp2.len[2]),16));
					obj.subject = removechars(obj.subject,tmp2.pos[1],tmp2.len[1]);
					obj.subject = insert(newch,obj.subject,tmp2.pos[1]-1);
					start = tmp2.pos[2];
				}
				else {
					eos = true;
				}
			}
			break;
		}
	}
	return obj.subject;
}


// ******************************************************************************* //
// return the content of the html body
// input: string ... full html document
// output: content of the body
function GetHTMLBody(s)
		{
		var a_str_result = "";
		var ii = 0;
		
		a_str_result = s;
		
		ii = FindNoCase("<body", a_str_result, 1);
		
		if (ii gt 0)
			{
			a_str_result = Mid(a_str_result, ii+len("<body"), len(a_str_result));
			} else return s;
		
		ii = FindNoCase(">", a_str_result, 1);
		
		if (ii gt 0)
			{
			a_str_result = Mid(a_str_result, ii+1, len(a_str_result));
			}
		
		ii = FindNoCase("</body>", a_str_result, 1);
		
		if (ii gt 0)
			{
			a_str_result = Mid(a_str_result, 1, ii-1);		
			}
		
		return trim(a_str_result);
		}

		
function GetUsernameFromEmailAddress(s)
	{
	var sReturn = "";
	var ii = 0;
	
	sReturn = s;
	
	ii = FindNoCase("@", s);
	
	if (ii GT 0)
		{
		sReturn = Mid(s, 1, ii - 1);
		}
	return sReturn;
	}

/**
 * Pass in a value in bytes, and this function converts it to a human-readable format of bytes, KB, MB, or GB.
 * Updated from Nat Papovich's version.
 * 01/2002 - Optional Units added by Sierra Bufe (sierra@brighterfusion.com)
 * 
 * @param size 	 Size to convert. 
 * @param unit 	 Unit to return results in.  Valid options are bytes,KB,MB,GB. 
 * @return Returns a string. 
 * @author Paul Mone (paul@ninthlink.com) 
 * @version 2.1, January 7, 2002 
 */
function byteConvert(num) {
	var result = 0;
	var unit = "";
	
	// Set unit variables for convenience
	var bytes = 1;
	var kb = 1024;
	var mb = 1048576;
	var gb = 1073741824;

	// Check for non-numeric or negative num argument
	if (not isNumeric(num) OR num LT 0)
		return "Invalid size argument";
	
	// Check to see if unit was passed in, and if it is valid
	if ((ArrayLen(Arguments) GT 1)
		AND ("bytes,KB,MB,GB" contains Arguments[2]))
	{
		unit = Arguments[2];
	// If not, set unit depending on the size of num
	} else {
		  if      (num lt kb) {	unit ="bytes";
		} else if (num lt mb) {	unit ="KB";
		} else if (num lt gb) {	unit ="MB";
		} else                {	unit ="GB";
		}		
	}
	
	// Find the result by dividing num by the number represented by the unit
	result = num / Evaluate(unit);
	
	// Format the result
	if (result lt 10)
	{
		result = NumberFormat(Round(result * 100) / 100,"0.00");
	} else if (result lt 100) {
		result = NumberFormat(Round(result * 10) / 10,"90.0");
	} else {
		result = Round(result);
	}
	// Concatenate result and unit together for the return value
	return (result & " " & unit);
}

function FileSize(filename){
	var daFile = createObject("java", "java.io.File");
	daFile.init(JavaCast("string", filename));
	return daFile.length();
	}


// return the action switches for the currently used service
function GetActionSwitchesForCurrentService() {
	if (StructKeyExists(application.actionswitches, request.sCurrentServiceKey)) {
		return application.actionswitches[request.sCurrentServiceKey];
		} else return StructNew();
	}

// get switches for the current action	
function GetServiceActionSwitch(servicestruct,action) {
	if (StructKeyExists(servicestruct.actions, action)) {
		return Duplicate(servicestruct.actions[action]);
		} else
			// return the default action 
			return Duplicate(servicestruct.actions[servicestruct.defaultaction]);
	}
		
function ListDeleteDuplicates(list) {
  var i = 1;
  var delimiter = ',';
  var returnValue = '';
  if(ArrayLen(arguments) GTE 2)
    delimiter = arguments[2];
  list = ListToArray(list, delimiter);
  for(i = 1; i LTE ArrayLen(list); i = i + 1)
    if(NOT ListFind(returnValue, list[i], delimiter))
      returnValue = ListAppend(returnValue, list[i], delimiter);
  return returnValue;
}
function AddUserkeyToURL()
	{
	if (Compare(url.userkey, request.stSecurityContext.myuserkey) NEQ 0)
		{
		WriteOutput('&userkey='&url.userkey);
		}
	}		
function ListLeft(list, start, numElements){
  var tempList='';
  var i=0;
  var c = 0;
  
  c = start + numElements;
  
  if (c GT ListLen(list))
  	{
	c = ListLen(list);
	}
  if (numElements gte ListLen(list)){
    return list;
  }
  for (i=start; i LTE c; i=i+1){
    tempList=ListAppend(tempList, ListGetAt(list, i));
  }
  return tempList;
}		
/**
 * Removes null entries from lists.
 * 
 * @param list 	 List to parse. (Required)
 * @param delim 	 List delimiter. Defaults to a comma. (Optional)
 * @return Returns a string. 
 * @author Craig Fisher (craig@altainteractive.com) 
 * @version 1, May 26, 2003 
 */
function ListRemoveNulls(list) {
  var delim = ",";
       
  if(arrayLen(arguments) gt 1) delim = arguments[2];
  while (Find(delim & delim, list) GT 0){
      list = replace(list, delim & delim, delim, "ALL");
  }
  
  //if (left(list, 1) eq delim) list = right(list, Len(list) - 1);
  //if (right(list, 1) eq delim) list = Left(list, Len(list) - 1);
  return list;
}
/**
 * Fixes a list by replacing null entries.
 * This is a modified version of the ListFix UDF 
 * written by Raymond Camden. It is significantly
 * faster when parsing larger strings with nulls.
 * Version 2 was by Patrick McElhaney (pmcelhaney@amcity.com)
 * 
 * @param list 	 The list to parse. (Required)
 * @param delimiter 	 The delimiter to use. Defaults to a comma. (Optional)
 * @param null 	 Null string to insert. Defaults to "". (Optional)
 * @return Returns a list. 
 * @author Steven Van Gemert (svg2@placs.net) 
 * @version 3, February 17, 2004 
 */
function listFix(list) {
var delim = ",";
  var null = "NULL";
  var special_char_list      = "\,+,*,?,.,[,],^,$,(,),{,},|,-";
  var esc_special_char_list  = "\\,\+,\*,\?,\.,\[,\],\^,\$,\(,\),\{,\},\|,\-";
  var i = "";
       
  if(arrayLen(arguments) gt 1) delim = arguments[2];
  if(arrayLen(arguments) gt 2) null = arguments[3];

  if(findnocase(left(list, 1),delim)) list = null & list;
  if(findnocase(right(list,1),delim)) list = list & null;

  i = len(delim) - 1;
  while(i GTE 1){
	delim = mid(delim,1,i) & "_Separator_" & mid(delim,i+1,len(delim) - (i));
	i = i - 1;
  }

  delim = ReplaceList(delim, special_char_list, esc_special_char_list);
  delim = Replace(delim, "_Separator_", "|", "ALL");

  list = rereplace(list, "(" & delim & ")(" & delim & ")", "\1" & null & "\2", "ALL");
  list = rereplace(list, "(" & delim & ")(" & delim & ")", "\1" & null & "\2", "ALL");
	  
  return list;
}

// function for creating the default return structure
function GenerateReturnStruct() {
	var s = StructNew();
	
	s.result = false;
	s.error = 0;
	s.errormessage = '';
	
	return s;
	}
		
// se	t the error code ...
function SetReturnStructErrorCode(struct, code) {
	var stReturn = arguments.struct;
	
	if (ArrayLen(arguments) GTE 3) {
		stReturn.errormessage = arguments[3];
		}
	stReturn.error = code;
	stReturn.result = false;
	return stReturn;
	}
	
// set OK answer
function SetReturnStructSuccessCode(struct) {
	var stReturn = arguments.struct;
	stReturn.error = 0;
	stReturn.result = true;
	stReturn.errormessage = '';
	return stReturn;
	}
	
// use data from another structure
function CopyReturnStructData(struct_dest, struct_source) {
	struct_dest.error = struct_source.error;
	struct_dest.result = struct_source.result;
	struct_dest.errormessage = struct_source.errormessage;
	return struct_dest;
	}
		
function GenerateReturnArray() {
	var s = ArrayNew(1);
		
	s[1] = 0;
	s[2] = '';
	
	return s;
	}		
		
function QueryToXMLData(q)
	{
  	var MyDoc = XmlNew();
	var i = 0;
	var j = 0;
  	MyDoc.xmlRoot = XmlElemNew(MyDoc,'result');
  
	a_str_columnlist = q.columnlist;
	a_int_listlen = ListLen(a_str_columnlist);  
  
  	for (i = 1; i LTE q.recordcount; i = i + 1)
    		{
    		MyDoc.result.XmlChildren[i] = XmlElemNew(MyDoc,'record');
			xml_node = MyDoc.result.XmlChildren[i];
	
			for (j = 1; j LTE a_int_listlen; j = j + 1)
				{
				a_col_name = ListGetAt(a_str_columnlist, j);
		
				xml_node.xmlchildren[j] = XmlElemNew(MyDoc, lcase(a_col_name));
				xml_node.xmlchildren[j].xmlText = xmlFormat(q[a_col_name][i]);
				}
			
    		}
			
	return MyDoc;
	}		

/**
 * Removes potentially nasty HTML text.
 * Version 2 by Lena Aleksandrova - changes include fixing a bug w/ arguments and use of REreplace where REreplaceNoCase should have been used.
 * 
 * @param text 	 String to be modified. (Required)
 * @param strip 	 Boolean value (defaults to false) that determines if HTML should be stripped or just escaped out. (Optional)
 * @param badTags 	 A list of bad tags. Has a long default list. Consult source. (Optional)
 * @param badEvents 	 A list of bad HTML events. Has a long default list. Consult source. (Optional)
 * @return Returns a string. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 3, March 19, 2003 
 */
function safetext(text) {
	//default mode is "escape"
	var mode = "escape";
	//the things to strip out (badTags are HTML tags to strip and badEvents are intra-tag stuff to kill)
	//you can change this list to suit your needs
	var badTags = "SCRIPT,OBJECT,APPLET,EMBED,FORM,LAYER,ILAYER,FRAME,IFRAME,FRAMESET,PARAM,META";
	var badEvents = "onClick,onDblClick,onKeyDown,onKeyPress,onKeyUp,onMouseDown,onMouseOut,onMouseUp,onMouseOver,onBlur,onChange,onFocus,onSelect,javascript:";
	var stripperRE = "";
	
	//set up variable to parse and while we're at it trim white space 
	var theText = trim(text);
	//find the first open bracket to start parsing
	var obracket = find("<",theText);		
	//var for badTag
	var badTag = "";
	//var for the next start in the parse loop
	var nextStart = "";
	//if there is more than one argument and the second argument is boolean TRUE, we are stripping
	if(arraylen(arguments) GT 1 AND isBoolean(arguments[2]) AND arguments[2]) mode = "strip";
	if(arraylen(arguments) GT 2 and len(arguments[3])) badTags = arguments[3];
	if(arraylen(arguments) GT 3 and len(arguments[4])) badEvents = arguments[4];
	//the regular expression used to stip tags
	stripperRE = "</?(" & listChangeDelims(badTags,"|") & ")[^>]*>";	
	//Deal with "smart quotes" and other "special" chars from MS Word
	theText = replaceList(theText,chr(8216) & "," & chr(8217) & "," & chr(8220) & "," & chr(8221) & "," & chr(8212) & "," & chr(8213) & "," & chr(8230),"',',"","",--,--,...");
	//if escaping, run through the code bracket by bracket and escape the bad tags.
	if(mode is "escape"){
		//go until no more open brackets to find
		while(obracket){
			//find the next instance of one of the bad tags
			badTag = REFindNoCase(stripperRE,theText,obracket,1);
			//if a bad tag is found, escape it
			if(badTag.pos[1]){
				theText = replace(theText,mid(TheText,badtag.pos[1],badtag.len[1]),HTMLEditFormat(mid(TheText,badtag.pos[1],badtag.len[1])),"ALL");
				nextStart = badTag.pos[1] + badTag.len[1];
			}
			//if no bad tag is found, move on
			else{
				nextStart = obracket + 1;
			}
			//find the next open bracket
			obracket = find("<",theText,nextStart);
		}
	}
	//if not escaping, assume stripping
	else{
		theText = REReplaceNoCase(theText,stripperRE,"","ALL");
	}
	//now kill the bad "events" (intra tag text)
	theText = REReplaceNoCase(theText,(ListChangeDelims(badEvents,"|")),"","ALL");
	//return theText
	return theText;
}

// return the CFQUERYPARAM datatype from the internal datatype
function GetCFDataTypeFromInternalType(s) {
		var areturn = 'CF_SQL_VARCHAR';
		
		switch(s)
			{
			case 0:
				{
				areturn = 'CF_SQL_VARCHAR';
				break;
				}
				
			case 1:
				{
				areturn = 'cf_sql_integer';
				break;
				}		
				
			case 2:
				{
				areturn = 'cf_sql_integer';
				break;
				}		
				
			case 3:
				{
				areturn = 'cf_sql_timestamp';
				break;
				}												
			}
			
		return areturn;
		}
		
	function GetSQLOperatorFromInternalOperatorNumber(i) {
		var areturn = '=';
		
		switch(i)
			{
			// is
			case '0':
				{
				areturn = '=';
				break;
				}
				
			// different
			case '1':
				{
				areturn = '<>';
				break;
				}
				
			// bigger
			case '2':
				{
				areturn = '>';
				break;
				}			
			// smaller
			case '3':
				{
				areturn = '<';
				break;
				}
			// contains
			case '4':
				{
				areturn = 'LIKE';
				break;
				}			
			// beginning with ...
			case '5':
				{
				areturn = 'LIKE';
				break;
				}	
			case '6':
				{
				areturn = 'IN';
				break;
				}	
			case '-6':
				{
				areturn = 'NOT IN';
				break;
				}												
			}
			
		return areturn;		
		}
	function GetDatabaseOperatorFromTextOperator(s)
		{
		var areturn = '=';
		
		s = lcase(s);
		
		switch(s)
			{
			case 'is':
				{
				areturn = '=';
				break;
				}
			case 'isnot':
				{
				areturn = '<>';
				break;
				}
			case 'greater':
				{
				areturn = '>';
				break;
				}			
			case 'less':
				{
				areturn = '<';
				break;
				}
			}
			
		return areturn;
		}
		
// check if a certain language (by shortname) is supported by openTeamWare.com (= platform has been translated into this platform)
function IsLanguageSupportedBySystem(shortname) {
	return (ListFindNoCase('en,de,cz,ro,sk,pl', shortname) GT 0);
	}
	
		
function GetDatabaseDataTypeFromStringname(s)
		{
		var areturn = 0;
		
		s = lcase(s);
		
		switch(s)
			{
			case 'string':
				{
				areturn = 0;
				break;
				}
			case 'int':
				{
				areturn = 1;
				break;
				}
			case 'date':
				{
				areturn = 3;
				break;
				}		
			case 'criteria':
				{
				// internal: string
				areturn = 0;
				break;
				}							
			}
			
		return areturn;
		}
		
// return AND or OR as return string
function ReturnSQLConnectorStringByNumber(i) {
	var areturn = 'AND';
		
	switch(i)
			{
			case '0': {
				areturn = 'AND';
				break;
				}
			case '1':
				{
				areturn = 'OR';
				break;
				}
			case '2':
				{
				areturn = 'AND NOT';
				break;
				}		
			}
			
	return areturn;
	}
		
function ListSameItems(list1,list2)	{
  var delimiters	= ",";
  var listReturn = "";
  var position = 1;

  // default list delimiter to a comma unless otherwise specified
  if (arrayLen(arguments) gte 3){
    delimiters	= arguments[3];
  }
		
  //checking list1
  for(position = 1; position LTE ListLen(list1,delimiters); position = position + 1) {
    value = ListGetAt(list1, position , delimiters );
    if (ListFindNoCase(list2, value , delimiters ) GT 0)
      listReturn = ListAppend(listReturn, value , delimiters );
    }
		
    //checking list2
    for(position = 1; position LTE ListLen(list2,delimiters); position = position + 1)	{
      value = ListGetAt(list2, position , delimiters );
      if (ListFindNoCase(list1, value , delimiters ) GT 0)
        listReturn = ListAppend(listReturn, value , delimiters );
  }
  return listReturn;
}		
function WriteMainContentTopHeaderLine(l) {
	var a_right = '';
	
	if(arraylen(arguments) GT 1) a_right = arguments[2];
	
	WriteOutput('<div class="bb PageBanner" style="padding:2px; ">');
	
	if (Len(a_right) GT 0) {
		WriteOutput('<span style="float:right " class="PageBannerSmall">' & htmleditformat(a_right) & '</span>');
		}
	
	WriteOutput(htmleditformat(l));
	WriteOutput('</div>');
	}
	
// return the currently used style
function GetCurrentStyleUsed() {
	if	(StructKeyExists(request, 'stUserSettings') AND Len(request.stUserSettings.style) GT 0)
		{
		return request.stUserSettings.style;
		}
			else return request.a_str_default_style;
	}		
		
// create an javascript array out of a coldfusion query
function CreateJSArrayOfQuery(query, arrayname, writescripttag, startrow, maxrows)
	{
	var areturn = '';
	var a_array_name = '';
	var a_str_row = '';
	var a_str_columnlist = query.Columnlist;
	var a_str_columnlist_tmp = '';
	var a_int_listlen_cols = ListLen(query.Columnlist);
	var a_str_field = '';
	
	a_array_name = arrayname;
	
	if (writescripttag)
		{
		areturn = areturn & '<script type="text/javascript">';
		}
	
	// the array holding the rows
	areturn = areturn & 'var ' & a_array_name & ' = new Array(0);';
	
	// the array holding the field index and the column name
	areturn = areturn & 'var ' & a_array_name & '_fields = new Array(0);';
	
	a_str_columnlist_tmp = a_str_columnlist;
	
	for(ii = 1; ii LTE a_int_listlen_cols; ii = ii + 1)
		{
		a_str_field = LCase(ListFirst(a_str_columnlist_tmp));
		a_str_columnlist_tmp = ListRest(a_str_columnlist_tmp);			
		
		areturn = areturn & 'var a_fieldname_index_' & a_str_field &' = "' & (ii - 1) & '";';
		//areturn = areturn & a_array_name & '_fields[' & (ii -1) & '] = "' & jsstringformat(ListGetAt(query.Columnlist, ii)) & '";';
		}
	
	// ok, and now write the data
	for(row = 1; row LTE query.recordcount; row = row + 1)
		{
		a_str_row = '';
								
		// loop through the columns and build a list
		a_str_columnlist_tmp = a_str_columnlist;
		
		for(ii = 1; ii LTE a_int_listlen_cols; ii = ii + 1)
			{
			a_str_field = ListFirst(a_str_columnlist_tmp);
			a_str_columnlist_tmp = ListRest(a_str_columnlist_tmp);
			
			//a_struct_row[ListGetAt(a_str_columnlist, ii)
			a_str_row = ListAppend(a_str_row, '"' & jsstringformat(query[a_str_field][row]) & '"');
			}
		
		areturn = areturn & a_array_name & '[' & (row -1) & '] = new Array(' & a_str_row & ');';
		}
		
	if (writescripttag)
		{			
		areturn = areturn & '</scri' & 'pt>';
		}
	
	// return the hash value
	return areturn;
	}		

// if we've got a custom target ... use this instead of nothing
function WriteCurrentTargetForLink()
		{
		
		if (NOT StructKeyExists(request, 'a_str_link_current_target'))
			{
			writeoutput('');
			return;
			}
			
		if (Len(request.a_str_link_current_target) GT 0)
			{
			writeoutput('target="' & request.a_str_link_current_target & '"');
			return;
			}
		return;
		
		}		
		
// use data from parent contact is data is empty
function CheckParentContactData(struct_holding_contact_data, query_parent_contact, itemname)
	{
	var sReturn = '';
	var a_str_value_contact = '';
	
	// check if the item exists in the structure of the contact
	if (StructKeyExists(struct_holding_contact_data, itemname) IS TRUE)
		{
		a_str_value_contact = struct_holding_contact_data[itemname];
		}
			else
				{
				a_str_value_contact = '';
				}
	
	// if the value is empty and exists in the parent contact, use this one
	if ((Len(a_str_value_contact) IS 0) AND (ListFindNoCase(query_parent_contact.columnlist, itemname) GT 0))
		{
		sReturn = query_parent_contact[itemname][1];
		}
	
	return sReturn;
	}		

	// check if there are still variables in the string ...
	function VariableStillExistsInString(s)
		{
		a_arr_find_variables = ReFindNoCase('%[^%]*%', s, 1, true);
		
		return (a_arr_find_variables.pos[1] GT 0);
		}
	// return the variable item name ...
	function GetVariableItemName(s)
		{
		var a_str_item = '';
		
		a_arr_find_variables = ReFindNoCase('%[^%]*%', s, 1, true);
		a_str_item = Mid(s, a_arr_find_variables.pos[1], a_arr_find_variables.len[1]);
		a_str_item = ReplaceNoCase(a_str_item, '%', '', 'ALL');
		
		return a_str_item;
		}	
		
// check if the current IP is an iternal IP or hp@openTeamware.com is the currently logged on user
function IsInternalIPOrUser() {
	var a_bol_ip = (ListFind('85.126.159.98,85.124.239.104,85.124.239.100', cgi.REMOTE_ADDR) GT 0);
	var a_bol_user = (StructKeyExists(request, 'stSecurityContext') AND (ListFindNoCase('hp@openTeamware.com,crm@musterfirma.at', request.stSecurityContext.myusername) GT 0));

	return (a_bol_ip OR a_bol_user);
	}
	
function WriteClassNameIfNotLastRow(q, class_name) {
	if (q.recordcount NEQ q.currentrow) writeoutput(class_name);
	}
		
// add a javascript function to call after the page has been loaded
// OnRequestEnd will check everything ...
function AddJSToExecuteAfterPageLoad(js_function_2call, js_function) {
	var i = 0;

	writeOutput( '<script>' & js_function & '</script><script>' & js_function_2call & '</script>');
	return;

	// if the array does not exists yet, create it
	if (NOT StructKeyExists(request, 'a_arr_js_scripts_to_execute_on_load')) {
		request.a_arr_js_scripts_to_execute_on_load = ArrayNew(1);
		}
	
	i = ArrayLen(request.a_arr_js_scripts_to_execute_on_load) + 1;
	
	request.a_arr_js_scripts_to_execute_on_load[i] = StructNew();
	request.a_arr_js_scripts_to_execute_on_load[i].js_function_2call = trim(js_function_2call);
	request.a_arr_js_scripts_to_execute_on_load[i].js_function = js_function;
	}
		
// return a very simple div with id and and nothing else **
function GenerateSimpleDivWithID(id) {
	return '<div style="padding:0px;" id="' & id & '"></di' & 'v>';
	}	
		
// write a new content box ...
// TODO : improve parameters ...
function WriteNewContentBox(title, button_area, content) {
	var sReturn = '';
	var a_box_id = '';
	var a_str_content = content;
	var a_str_params = '';
	
	if (ArrayLen(arguments) GT 3) {
		// use the 4th parameter as ID of the content box
		a_box_id = arguments[4];
		}
		
	if (ArrayLen(arguments) GT 4) {
		// use the 5th parameter as parameter with various options ...
		a_str_params = arguments[5];
		}
	
	sReturn = '<div class="panel panel-default"';
	
	if (Len(a_box_id) GT 0) {
		// include box id if given
		sReturn = sReturn & ' id="' & a_box_id & '"';
		}
	
	// go through parameters ... 
	if (ListFindNoCase('hidden', a_str_params) GT 0) {
		sReturn = sReturn & 'style="display:none;"';
		}
	
	sReturn = sReturn & '>';
	
	sReturn = sReturn & '<div class="panel-heading">';
	
		// title
		sReturn = sReturn & '<div class="panel-title">';
		sReturn = sReturn & htmleditformat(title);		
		
		
		
		// buttons
		if (Len(button_area) GT 0) {
			sReturn = sReturn & '<div class="btn-group pull-right">';
			sReturn = sReturn & button_area;
			sReturn = sReturn & '</div>';
			}
	
	sReturn = sReturn & '</div>';//close caption
	
	sReturn = sReturn & '</div>';

	// content
	sReturn = sReturn & '<div class="panel-body">';
	sReturn = sReturn & a_str_content;
	sReturn = sReturn & '</div>';
	
	sReturn = sReturn & '</div>';
	
	return sReturn;
	}	

		
// create a uuid without -
function CreateUUIDJS() {
	return ReplaceNoCase(CreateUUID(), '-', '', 'ALL');
	}
		
function MakeFirstCharUCase(s) {
	if (Len(s) IS 0) return '';
	return UCase(Left(s, 1)) & Mid(s, 2, Len(s));
	}	
		
// write a simple header ...
function WriteSimpleHeaderDiv(txt) {
	writeOutput('<div class="mischeader bb" style="padding:4px;font-weight:bold;">');
	writeOutput(trim(txt));
	writeOutput('</div>');
	}
	
// add parameter to string ... used for addressbook caching
function AddParamStringItem(param_string, item, value) {
	return ListAppend(param_string, item & '=' & urlencodedformat(value), '&');
	}
		
function SetHeaderTopInfoString(s) {
	writeoutput('<div class="page-header"><h1>' & htmleditformat( s ) & '</h1></div>');
	return true;
	}
// read an entry of properties file and return default value if empty
function ReadPropertiesFileProperty(section, property, defaultvalue) {
	var sReturn = '';
	var a_str_server_os = server.OS.Name;
	
	var a_str_ini_file = GetDirectoryFromPath( GetCurrentTemplatePath() ) & 'configuration/openteamware.properties';
	
	sReturn = GetProfileString(a_str_ini_file, arguments.section, arguments.property);
	
	if (Len(sReturn) IS 0) {
		sReturn = arguments.defaultvalue;
		}
	
	return sReturn;
	}
		
/**
 * Fixes an oversight in the jsstringformat() function
 */
function jsStringFormatEx(mystring) {
	return Replace(jsstringformat(ReplaceNoCase(mystring, '"', '''', 'ALL')),"/","\/","ALL"); 
}

// when loading multiple preferences items, add them to the array
function AddNewGetMultiPrefItem(arr, entrysection, entryname, defaultvalue, setcallervariable) {
	var a_arr_return = arr;
	var i = (ArrayLen(a_arr_return) + 1);
	
	a_arr_return[i] = StructNew();
	a_arr_return[i].entrysection = entrysection;
	a_arr_return[i].entryname = entryname;
	a_arr_return[i].defaultvalue = defaultvalue;
	a_arr_return[i].setcallervariable = setcallervariable;
	
	return a_arr_return;
	}
	
// return the currently used dir separator
function ReturnDirSeparatorOfCurrentOS() {
	var sReturn = '/';
	
	if (CompareNoCase(server.os.Name, 'Windows') IS 0) {sReturn = '\';}
	
	return sReturn;
	}
		
// start a new js popup composing ...
function StartNewJSPopupMenu(popup_name) {
	request.a_str_current_js_popup = StructNew();
	request.a_str_current_js_popup.name = popup_name;
	request.a_str_current_js_popup.jsstring = 'var ' & popup_name & ' = new cActionPopupMenuItems();';
	}
		
// add new item
function AddNewJSPopupMenuItem(caption,action) {
	request.a_str_current_js_popup.jsstring = request.a_str_current_js_popup.jsstring & request.a_str_current_js_popup.name & '.AddItem(' & '''' &  jsstringformat(caption) & '''' & ',' & '''' & action & '''' & ');';
	return true;
	}

// write generated string and remove element from request scope
function AddNewJSPopupMenuToPage() {
	AddJSToExecuteAfterPageLoad('', request.a_str_current_js_popup.jsstring);
	tmp = StructDelete(request, 'a_str_current_js_popup');
	return true;
	}
	
// delete the element if found in the list
function DeleteItemFromListIfFound(list2check, item2search) {
	var i = ListFindNoCase(list2check, item2search);
	
	if (i GT 0) {
		list2check = ListDeleteAt(list2check, i);
		}
		
	return list2check;
	}// write the default url parameter with the given error code from the return structure
function WriteIBXErrorURL(returnstructure) {
	return '&ibxerrorno=' & returnstructure.error & '&ibxerrormsg=' & urlencodedformat(returnstructure.errormessage);
	}
	
// take the given translation data and add to html header for further use in JS functions
// TODO: document in guidelines
function ExportTranslationValuesAsJS(entrynames) {
	var a_return = '';
	var ii = 0;
	
	 For (ii=1;ii LTE ListLen(entrynames); ii=ii+1) {
	 	a_return = a_return & 'var vl_ibx_langdata_' & ListGetAt(entrynames, ii) & '="' & JsStringFormatEx(GetLangVal(ListGetAt(entrynames, ii))) & '"; ';
	 	}
	
	AddJSToExecuteAfterPageLoad('', a_return);
	return true;
	}
	
// write out all url parameters as hidden fields and exclude the given fieldnames
// this functions is needed in the various inpage popups
function CreateHiddenFieldsOfURLParameters(execludeparameters) {
	var sReturn = '';
	var a_str_name = '';
	var a_str_value = '';
	var a_url_items = StructKeyList(url);
	var i = 0;
	
	For (i=1;i LTE ListLen(a_url_items); i=i+1) {
		a_str_name = ListGetAt(a_url_items, i);
		a_str_value = url[a_str_name];

		if (ListFindNoCase(execludeparameters, a_str_name) IS 0) {			
			sReturn = sReturn & '<input type="hidden" name="' & a_str_name & '" id="' & a_str_name & '" value="' & htmleditformat(a_str_value) & '" />';
			}
		}
	
	return sReturn;
	}
	
// in smartload mode?
function SmartLoadEnabled() {
	return (StructKeyExists(url, 'smartload') AND (url.smartload IS 1));
	}
	
// inpage or action call (no "ordenary call")?
function IsInPagePopupOrActionPageCall() {
	return (StructKeyExists(request, 'a_struct_current_service_action') AND (ListFindNoCase('inpage,action', request.a_struct_current_service_action.type) GT 0));
	}

// return true of false on values 1 or 0
function ReturnTrueFalseOnZeroOne(v) {
	if (v IS '1')
		{return 'true';} else {return 'false';}
	}
	
function ReturnZeroOneOnTrueFalse(v) {
	if (v IS TRUE)
		{return 1;} else {return 0;}
	}
	
// return the date/time according to the current usersettings
function FormatDateTimeAccordingToUserSettings(date_value) {
	var a_str_date_format = '';
	var a_str_time_format = '';
	var a_str_today_formatted = '';
	var a_str_given_date_formatted = '';
	
	if (StructKeyExists(request, 'a_str_today_formatted')) {
		a_str_today_formatted = request[a_str_today_formatted];
		} else {
			a_str_today_formatted = DateFormat(Now(), 'ddmmyyyy');
			}
			
	// use user preferences?
	if (StructKeyExists(request, 'stUserSettings') AND StructKeyExists(request.stUserSettings, 'default_timeformat')) {
		a_str_date_format = request.stUserSettings.default_dateformat;
		a_str_time_format = request.stUserSettings.default_timeformat;
		} else {
			a_str_date_format = 'dd.mm.yy';
			a_str_time_format = 'HH:mm';
			}
	
	// format now
	if (NOT IsDate(date_value)) {
		return '';
		} else {
			
			a_str_given_date_formatted = DateFormat(date_value, 'ddmmyyyy');
			
			if (Compare(a_str_given_date_formatted, a_str_today_formatted) IS 0) {
				return TimeFormat(date_value, a_str_time_format);
				}
			
			if ((Hour(date_value) IS 0) AND (Minute(date_value) IS 0)) {
				return LSDateFormat(date_value, a_str_date_format);
				} else return LSDateFormat(date_value, a_str_date_format) & ' ' & TimeFormat(date_value, a_str_time_format);
			}
	}

// check structure for a certain item and return given default if the item does not exist
function CheckStructureForItem(struct, item, defaultvalue) {
	if (StructKeyExists(struct, item)) {
		return struct[item];
		} else {return defaultvalue; }
	}
	
function FormatTextToHTML(s) {
	var areturn = s;
	
	// replace double line breaks ...
	areturn = ReplaceNoCase(areturn, chr(10) & chr(10), '', 'ALL');
	
	return ReplaceNoCase(htmleditformat(areturn), chr(10), '<br />', 'ALL');
	}
	
// for the administration tool ...
function WriteURLTags() {
	var a_str_companykey = '';
	var a_str_resellerkey = '';
	
	if (StructKeyExists(url, 'resellerkey')) {
		a_str_resellerkey = url.resellerkey;
		}
		
	if (StructKeyExists(url, 'companykey')) {
		a_str_companykey = url.companykey;
		}
	
	return '&companykey=' & urlencodedformat(a_str_companykey) & '&resellerkey=' & urlencodedformat(a_str_resellerkey);
	}
function WriteURLTagsfromForm() {
	return '&companykey='&urlencodedformat(form.frmcompanykey)&'&resellerkey='&urlencodedformat(form.frmresellerkey);
	}// Returns the date for The start of Daylight Saving Time for a given year.
function GetDaylightSavingTimeStart() {
	Var TheYear=Year(Now());
  	if(ArrayLen(Arguments)) 
  	  TheYear = Arguments[1];	

	//return CreateDate(TheYear,3,GetNthOccOfDayInMonth(5,1,3,TheYear));
	return CreateDate(TheYear,3,GetNthOccOfDayInMonth(1,1,4,TheYear));
	}
	
/**
 * Returns the date for the End of Daylight Saving Time for a given year.
 * This function requires the GetLastOccOfDayInMonth() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to return the end of Daylight Saving Time. 
 * @return Returns a date object. 
 * @author Ken McCafferty (mccjdk@yahoo.com) 
 * @version 1.0, September 7, 2001 
 **/
function GetDaylightSavingTimeEnd() {
	Var TheYear=Year(Now());
  	if(ArrayLen(Arguments)) 
  	  TheYear = Arguments[1];
	return CreateDate(TheYear,10,GetLastOccOfDayInMonth(1,10,TheYear));
	}
	
// Returns the day of the month(1-31) of Last Occurrence of a day (1-sunday,2-monday etc.)
// in a given month.
function GetLastOccOfDayInMonth(TheDayOfWeek,TheMonth,TheYear) {
  //Find The Number of Days in Month
  Var TheDaysInMonth=DaysInMonth(CreateDate(TheYear,TheMonth,1));

  //find the day of week of Last Day
  Var DayOfWeekOfLastDay=DayOfWeek(CreateDate(TheYear,TheMonth,TheDaysInMonth));

  //subtract DayOfWeek
  Var DaysDifference=DayOfWeekOfLastDay - TheDayOfWeek;

  //Add a week if it is negative
  if(DaysDifference lt 0){
    DaysDifference=DaysDifference + 7;
  }
  return TheDaysInMonth-DaysDifference;
}

// Returns the day of the month(1-31) of an Nth Occurrence of a day (1-sunday,2-monday etc.)in a given month.
function GetNthOccOfDayInMonth(NthOccurrence,TheDayOfWeek,TheMonth,TheYear) {
  Var TheDayInMonth=0;
  if(TheDayOfWeek lt DayOfWeek(CreateDate(TheYear,TheMonth,1))){
    TheDayInMonth= 1 + NthOccurrence*7  + (TheDayOfWeek - DayOfWeek(CreateDate(TheYear,TheMonth,1))) MOD 7;
  }
  else{
    TheDayInMonth= 1 + (NthOccurrence-1)*7  + (TheDayOfWeek - DayOfWeek(CreateDate(TheYear,TheMonth,1))) MOD 7;
  }

  //If the result is greater than days in month or less than 1, return -1
  if(TheDayInMonth gt DaysInMonth(CreateDate(TheYear,TheMonth,1)) OR   TheDayInMonth lt 1){
    return -1;
  }
  else{
    return TheDayInMonth;
  }
}

/**
 * Makes a row of a query into a structure.
 * 
 * @param query 	 The query to work with. 
 * @param row 	 Row number to check. Defaults to row 1. 
 * @return Returns a structure. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, December 11, 2001 
 */
function queryRowToStruct(query){
	//by default, do this to the first row of the query
	var row = 1;
	//a var for looping
	var ii = 1;
	//the cols to loop over
	var cols = listToArray(query.columnList);
	//the struct to return
	var stReturn = structnew();
	//if there is a second argument, use that for the row number
	if(arrayLen(arguments) GT 1)
		row = arguments[2];
	//loop over the cols and build the struct from the query row
	for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
		stReturn[cols[ii]] = query[cols[ii]][row];
	}		
	//return the struct
	return stReturn;
}

/**
 * Takes a week number and returns a date object of the first day of that week.
 * Added ISOFormat, RCamden, 3/19/2002
 * 
 * @param weekNum 	 The week number. 
 * @param weekYear 	 The year. 
 * @param ISOFormat 	 Use ISO for first day of week. Defaults to false. 
 * @return Returns a date object. 
 * @author David Murphy (dmurphy52@lycos.com) 
 * @version 1, March 19, 2002 
 */
function weekStartDate(weekNum,weekYear) {
	var weekDate = dateAdd("WW",weekNum-1,"1/1/" & weekYear);
	var toDay1 = dayofweek(weekDate)-1;
	var weekStartDate = dateAdd("d",-toDay1,weekDate);
	if(arrayLen(arguments) gte 3 and arguments[3]) weekStartDate = dateAdd("d",1,weekStartDate);
	return weekStartDate;	
 }

function GetISOWeek(thedate)
	{
	var i = 0;
	
	i = DayOfWeek(thedate);
	i = i - 1;
	
	if (i IS 0)
		{
		return Week(thedate)-1;
		}
		else
			{
			return Week(thedate);
			}	
	}
	
/**
 * Returns the weeknumber according to the ISO standard.
 * 
 * @param inputDate 	 Date object. (Required)
 * @return Returns a number. 
 * @author Ron Pasch (pasch@cistron.nl) 
 * @version 1, January 12, 2004 
 */
function CalculateRealStandardISOWeek(inputDate) {  
    var d = StructNew();
	var d2 = 0;
	var days = 0;
	d.yday = DayOfYear(inputDate);
	d.wday = DayOfWeek(inputDate)-1;
	d.year = Year(inputDate);
    days = d.yday - ((d.yday - d.wday + 382) MOD 7) + 3;
    if(days LT 0) {
        d.yday = d.yday + 365 + isLeapYear(d.year-1);
        days = d.yday - ((d.yday - d.wday + 382) MOD 7) + 3;
    } else {
        d.yday = (d.yday - 365) + isLeapYear(d.year);
        d2 = d.yday - ((d.yday - d.wday + 382) MOD 7) + 3;
        if (0 LTE d2) {
            days = d2;
        }
    }
	return int((days / 7) + 1);
}	

</cfscript>


