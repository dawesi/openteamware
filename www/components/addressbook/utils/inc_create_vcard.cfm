<cfsavecontent variable="sVcard"><cfoutput>BEGIN:VCARD
VERSION:2.1
N:#q_select_contact.Surname#,#q_select_contact.firstname#
FN:#q_select_contact.Firstname# #q_select_contact.Surname#
ORG:#q_select_contact.company#;#q_select_contact.Department#
TITLE:#q_select_contact.aPosition#
TEL;WORK;VOICE:#q_select_contact.B_TELEPHONE#
TEL;WORK;FAX:#q_select_contact.B_FAX#
TEL;CELL;VOICE:#q_select_contact.b_MOBILE#
TEL;HOME;VOICE:#q_select_contact.P_TELEPHONE#
ADR;WORK:;;#q_select_contact.B_STREET#;#q_select_contact.B_CITY#;;#q_select_contact.b_zipcode#;#q_select_contact.B_COUNTRY#
ADR;HOME:;;#q_select_contact.P_STREET#;#q_select_contact.P_CITY#;;#q_select_contact.p_zipcode#;#q_select_contact.P_COUNTRY#
EMAIL;PREF;INTERNET:#q_select_contact.EMAIL_PRIM#
END:VCARD</cfoutput></cfsavecontent>