<!--- //

	Module:		Framework
	Description:Bottom frame
	
// --->

<cfinclude template="../../../login/check_logged_in.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<cfset a_int_nt_randommode = GetUserPrefPerson('newsticker', 'randommode', '0', '', false) />

<cfset tmp = ExportTranslationValuesAsJS('cm_ph_preloading_resource') />
<html>
	<head>
		<cfinclude template="/style_sheet.cfm">
		
		<!--- include javascripts ... --->
		<script src="/common/js/display.js" type="text/javascript"></script>
		<script src="/common/js/bottom.js" type="text/javascript"></script>
		<script src="/common/js/jquery-1.2.js" type="text/javascript"></script>
		
		<script type="text/javascript">
			function DoOnLoadThings() {
				AdjustHeight();
				// StartLoadNTTimer(2500);
				// StartNTScroll();
				DisplayCurrentData();
				}
		</script>
		
		<title>Info</title>
	</head>
<body class="bottomframe" onload="window.setTimeout('DoOnLoadThings()', 2000);">

<!--- cache all possible things ... --->
<cfinclude template="inc/inc_cache.cfm">

<table class="tbl_bottom_view" border="0" cellspacing="0" id="id_tbl_bottom_view">
  <tr>
    <td id="id_div_bottom_email"></td>
	
	<td class="td_bottom_spacer"><img src="/images/space_1_1.gif" alt="" vspace="0" hspace="0" /></td>
    
	<td id="id_div_bottom_calendar"></td>
	
	<td id="idinfo">
		<cfoutput>#GetLangVal('cm_ph_preloading_resource')#</cfoutput> 1
	</td>
  </tr>
</table>

</body>
</html>