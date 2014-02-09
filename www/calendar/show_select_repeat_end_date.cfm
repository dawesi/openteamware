<HTML>
<HEAD>
<script type="text/javascript"><!--
function Calendar(Month,Year) {
    var output = '';
    
    output += '<FORM NAME="Cal"><TABLE BORDER=0><TR><TD ALIGN=LEFT WIDTH=100%>';
    output += '<FONT COLOR="#0000BB">' + names[Month] + ' ' + Year + '<\/FONT><\/TD><TD WIDTH=50% ALIGN=RIGHT>';
    output += '<SELECT NAME="Month" onChange="changeMonth();">';

    for (month=0; month<12; month++) {
        if (month == Month) output += '<OPTION VALUE="' + month + '" SELECTED>' + names[month] + '<\/OPTION>';
        else                output += '<OPTION VALUE="' + month + '">'          + names[month] + '<\/OPTION>';
    }

    output += '<\/SELECT><SELECT NAME="Year" onChange="changeYear();">';

    for (year=2001; year<2005; year++) {
        if (year == Year) output += '<OPTION VALUE="' + year + '" SELECTED>' + year + '<\/OPTION>';
        else              output += '<OPTION VALUE="' + year + '">'          + year + '<\/OPTION>';
    }

    output += '<\/SELECT><\/TD><\/TR><TR><TD ALIGN=CENTER COLSPAN=2>';

    firstDay = new Date(Year,Month,1);
    startDay = firstDay.getDay();

    if (((Year % 4 == 0) && (Year % 100 != 0)) || (Year % 400 == 0))
         days[1] = 29; 
    else
         days[1] = 28;

    output += '<TABLE CALLSPACING=0 CELLPADDING=0 BORDER=1 BORDERCOLORDARK="#FFFFFF" BORDERCOLORLIGHT="#C0C0C0"><TR>';

    for (i=0; i<7; i++)
        output += '<TD WIDTH=50 ALIGN=CENTER VALIGN=MIDDLE><FONT SIZE=-1 COLOR="#000000"><B>' + dow[i] +'<\/B><\/FONT><\/TD>';

    output += '<\/TR><TR ALIGN=CENTER VALIGN=MIDDLE>';

    var column = 0;
    var lastMonth = Month - 1;
    if (lastMonth == -1) lastMonth = 11;

    for (i=0; i<startDay; i++, column++)
        output += '<TD WIDTH=50 HEIGHT=30><FONT SIZE=-1 COLOR="#808080">' + (days[lastMonth]-startDay+i+1) + '<\/FONT><\/TD>';

    for (i=1; i<=days[Month]; i++, column++) {
        output += '<TD WIDTH=50 HEIGHT=30>' + '<A HREF="javascript:changeDay(' + i + ')"><FONT  COLOR="#0000FF">' + i + '<\/FONT><\/A>' +'<\/TD>';
        if (column == 6) {
            output += '<\/TR><TR ALIGN=CENTER VALIGN=MIDDLE>';
            column = -1;
        }
    }

    if (column > 0) {
        for (i=1; column<7; i++, column++)
            output +=  '<TD WIDTH=50 HEIGHT=30><FONT COLOR="#808080" >' + i + '<\/FONT><\/TD>';
    }

    output += '<\/TR><\/TABLE><\/FORM><\/TD><\/TR><\/TABLE>';

    return output;
}

function changeDay(day) {
    opener.day = day + '';
    opener.restartRepeat();
    self.close;
}

function changeMonth() {
    opener.month = document.Cal.Month.options[document.Cal.Month.selectedIndex].value + '';
    location.href = 'show_select_date.cfm';
}

function changeYear() {
    opener.year = document.Cal.Year.options[document.Cal.Year.selectedIndex].value + '';
    location.href = "show_select_date.cfm";
}

function makeArray0() {
    for (i = 0; i<makeArray0.arguments.length; i++)
        this[i] = makeArray0.arguments[i];
}

var names     = new makeArray0('Jaenner','Februar','Maerz','April','Mai','Juni','Juli','August','September','October','November','December');
var days      = new makeArray0(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var dow       = new makeArray0('So','Mo','Di','Mi','Do','Fr','Sa');
//--></SCRIPT>
<style>
	td,body,p{font-family:Verdana;font-size:11px;}
</style>
<title>Datum w&auml;hlen</title>
</HEAD>
<BODY bgcolor="#EEEEEE" >

<P><CENTER>

<script type="text/javascript"><!--
document.write(Calendar(opener.month,opener.year));
//--></SCRIPT>

</CENTER>
</BODY>
</HTML>