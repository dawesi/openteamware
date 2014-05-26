<html>
<head>
<script type="text/javascript">
<!--
  function OpenAssignWindow(servicekey,objectkey,title) {
    var options = "width=500,height=300,";
    options += "resizable=yes,scrollbars=yes,status=yes,";
    options += "menubar=no,toolbar=no,location=no,directories=no";
    var newWin = window.open('show_popup.cfm?servicekey='+escape(servicekey)+'&objectkey='+escape(objectkey)+'&title='+escape(title), 'wd_assignwindow', options);
    newWin.focus();
  }
//-->
</script>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfinvoke component="#request.a_str_component_assigned_items#" method="AddAssignment" returnvariable="a_bol_return">
	<cfinvokeargument name="servicekey" value="service">
	<cfinvokeargument name="objectkey" value="123">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>		

<cfinvoke component="#request.a_str_component_assigned_items#" method="GetAssignments" returnvariable="q_select">
	<cfinvokeargument name="servicekey" value="service">
	<cfinvokeargument name="objectkeys" value="123">
</cfinvoke>

<cfdump var="#q_select#">

<a href="javascript:OpenAssignWindow('service', '123', 'titel');">123</a>

</body>
</html>