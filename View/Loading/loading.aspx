<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true" CodeFile="loading.aspx.cs" Inherits="loading" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <meta http-equiv="Content-Type" content="text/html; charset=big5" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=yes" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="../css/jquery-ui.min.css">
    <link rel="stylesheet" href="../css/main.css?v=<%=DateTime.Now.ToString("yyyyMMddhhmmss")%>">
    <script src="../js/vue-resource@1.5.1.js"></script>
    <script src="../js/httpVueLoader.js"></script>
    <script src="../js/vue.js"></script>
    <script src="../js/request.js"></script>
    <script src="../js/vuePublic.js"></script>
    <script src="../js/jquery-3.6.0.js"></script>
    <script src="../js/jquery-3.6.0.min.js"></script>
    <script src="../js/jquery-ui.min.js"></script>
    <script src="../js/cis_alert.js?v=<%=DateTime.Now.ToString("yyyyMMddhhmmss")%>"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
			var getUrlString = location.href;
			var url = new URL(getUrlString);
			var logon = url.searchParams.get('logon');
			var planname = url.searchParams.get('planname');
            var url = "http://172.17.120.139/OpenForm/OpenForm.ashx?logon="+logon+"&planname="+planname;
	alert(url);
 window.open(url);
 window.close();
        });
       
    </script>
</asp:Content>




