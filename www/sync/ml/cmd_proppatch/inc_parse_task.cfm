	<cfscript>
		elements = XmlSearch(request.a_struct_action.a_xml_obj, "//D:prop");
		propElems = elements[1].XmlChildren;
		
		request.a_struct_task = StructNew();
		request.a_struct_task.title = propElems[3].XmlText; //HN:subject
		request.a_struct_task.notice = propElems[5].XmlText; //HN:textdescription
		request.a_struct_task.priority = 2;
		request.a_struct_task.percentdone = 0;
		request.a_struct_task.status = 1;
		request.a_struct_task.projectkeys = '';
		request.a_struct_task.actualwork = 0;
		request.a_struct_task.totalwork = 0;
		request.a_struct_task.categories = '';
		request.a_struct_task.due = GetWebDavDate(propElems[6].XmlText); //EX:date
		request.a_struct_task.linked_contacts = '';
		request.a_struct_task.linked_files = '';
		request.a_struct_task.assignedtouserkeys = '';
		request.a_struct_task.dt_start = Now();
	</cfscript>
