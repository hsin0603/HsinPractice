var cust_Content = '<div id="alertBox" class="alertBox" style="display: none;"><h2 id="alertTitle">提醒視窗</h2><p id="alertMsg"></p><div class="btnGroup"><a onclick="closeAlertBox()" class="w50">確定</a><a id="alertDivCancel" onclick="$(\'#alertDiv\').hide();" class="w50">取消</a></div></div><div class="mask" id="al" style="display:none"></div>';

$(function () {
    $('.container').append(cust_Content);
})
var checkEvent = null;

/*
title : 標題，若不需要指定則帶null
msg : 要顯示的訊息
Event : 按確定要執行的function，若無則帶null
isConfirm : true(confirm) or false(alert)
*/
function openAlertBox(title,msg,Event,isConfirm)
{
	//標題
	if(title !== null) $("#alertTitle").html(title);
	//訊息
	$("#alertMsg").html(msg);
	//確認按鈕
	checkEvent = Event;
	//取消按紐要不要顯示
	if(isConfirm)
	{
		$("#alertDivCancel").show();
	}
	else
	{
		$("#alertDivCancel").hide();
	}
	//開啟alert訊息框
    $("#alertBox").show();
    $("#al").show(); 
}

function closeAlertBox()
{
    $("#alertBox").hide();
    $("#al").hide(); 
	if (typeof checkEvent === 'function')
	{
		checkEvent();
	}
	$("#alertTitle").html("提醒視窗");
	checkEvent = null;
}

//連接表單
function FormSelect (num) {
    if (num != "") {
        window.open("http://172.17.120.139/BPM/OpenForm.ashx?k=" + num);
    }
}

//匯出Excel
function fnExcelReport (tablename,filename) {
    var tab_text = "<table border='2px'><tr bgcolor='#cccccc'>";
    var textRange;
    var j = 0;
    tab = document.getElementsByName(tablename);
    for (i = 1; i < tab[0].rows[0].cells.length; i++) {
        tab_text += "<td>" + tab[0].rows[0].cells[i].innerHTML + "</td>";
    }
    tab_text += "</tr>";
    for (j = 1; j < tab[0].rows.length; j++) {
        tab_text += "<tr>";
        for (i = 1; i < tab[0].rows[j].cells.length; i++) {
            tab_text += "<td>" + tab[0].rows[j].cells[i].innerHTML + "</td>";
        }
        tab_text += "</tr>";
    }
    tab_text = tab_text + "</table>";
    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE ");
    var edge = ua.indexOf("Edge/");
    if (edge > 0 || window.navigator.msSaveOrOpenBlob)      // If Internet Explorer
    {
        var fileData = [tab_text];
        var blobObject = new Blob(fileData);
        window.navigator.msSaveOrOpenBlob(blobObject, filename+'.xls');
    }

    else {
        //other browser not tested on IE 11
        //sa = window.open('data:application/vnd.ms-excel.12,' + encodeURIComponent(tab_text));
        var a = document.createElement('a');
        a.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(tab_text);
        a.download = filename+'.xls';
        a.click();
        //return (sa);
    }
}