<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true" CodeFile="earthquake.aspx.cs" Inherits="earthquake" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>顯著有感地震報告</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=yes" />
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

    <style>
        input[readonly] {
            background-color: #eee;
        }

        @media print {
            .searchBar {
                display: none;
            }

            .pathformWrapper > table .formList > thead {
                color: black;
                border: 1px solid black;
            }

            @page {
                margin: 0.5cm;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section id="earthquake-Main" class="container">
        <div id="MainSet">
            <div class="formWrapper">
                <table class="formContent">
                    <thead class="formTitle">
                        <tr>
                            <th colspan="4">
                                <h1>顯著有感地震報告</h1>
                            </th>
                        </tr>
                    </thead>
                    <tbody id="MainSys">
                        <tr>
                            <td width="11%" class="tdTitle">匯出</td>
                            <td width="39%">
                                <button id="exclebtn" type="button" class="btn" onclick="Excel()">Excel</button>
                            </td>
                            <td width="10%" class="tdTitle pt">列印表單</td>
                            <td width="40%" class="pt">
                                <button id="" type="button" class="btn" v-on:click="Print()">列印</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <%-- 主系統列表 --%>
            <div id="MainSearch" style="display: block">
                <div class="searchBar">
                    <select class="w100" id="SystemTypeS" name="SystemTypeS" v-model="SystemTypeS">
                        <option selected value="All">全部</option>
                        <option value="Yell">警示程度-黃色</option>
                        <option value="Green">警示程度-綠色</option>
                        <option value="Describe">說明</option>
                        <option value="Time">時間</option>
                    </select>
                    <input type="text" id="SystemTypeSText" name="SystemTypeSText" v-model="SystemTypeSText" class="w300">
                    <button type="button" v-on:click="SystemTypeListSelect()"></button>
                </div>
                <div class="pathformWrapper">
                    <table class="formList pathform" id="MainTable" name="MainTable">
                        <thead>
                            <tr>
                                <th width="10%">警示程度</th>
                                <th width="50%">說明</th>
                                <th width="20%">時間</th>
                                <th width="20%">深度</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="SystemTypeSL.length==0 && Loading==0">
                                <td colspan="4">無資料</td>
                            </tr>
                            <tr v-if="SystemTypeSL.length==0 && Loading==1">
                                <td colspan="4">
                                    <div class="loading">
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                    </div>
                                </td>
                            </tr>
                            <tr v-for="(data,i) in SystemTypeSL" v-on:click="SystemTypeChose(data.reportImageURI)" style="cursor: pointer;" v-bind:style= "data.reportColor == '綠色' ? 'color:green;'  : 'color:orange;'">
                                <td>{{data.reportColor}}</td>
                                <td>{{data.reportContent}}</td>
                                <td>{{data.earthquakeInfo.originTime}}</td>
                                <td>{{data.earthquakeInfo.depth.value}}{{data.earthquakeInfo.depth.unit}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="mask" id="db"></div>
    </section>
    <script type="text/javascript">
        $(function () {
            $('#db').on('click', function () {
                $('#db,.dialogBox').fadeOut();
            })
        })
        function Excel() {
            fnExcelReport("MainTable", "地震報告");
        }

        var Main = new Vue({
            el: '#earthquake-Main',
            data: {
               
                SystemTypeCode: "", //主系統
                SystemTypeName: "",//主系統名稱
                SystemTypeDescribe: "",//主系統說明
                SystemTypeALL: [],//主系統列表
                SystemTypeSL: [],//主系統列表篩選
                SystemTypeSText: [],//主系統列表篩選文字
                SystemTypeS: "All",//主系統列表篩選項目
                
                Loading: "0",
            },
            mounted: function () {
                this.datepicker();
                this.init();
            },
            methods: {
                init: function () {
                    this.datepicker();
                    this.GetSystemTypeList();
                },
                refresh: function () {

                },
           
                //列印
                Print: function () {
                    window.print();
                },
             
                //清除欄位
                clear: function () {
                    var self = this;
                },

                //主系統列表
                GetSystemTypeList: function () {
                    var self = this;
                    self.Loading = 1;
                    self.SystemTypeALL = [];
                    self.SystemTypeSL = [];
                    self.SystemTypeCode = "";
                    self.SystemTypeName = "";
                    self.SystemTypeDescribe = "";
                    $.ajax({
                        url: 'https://opendata.cwb.gov.tw/api/v1/rest/datastore/E-A0015-001?Authorization=rdec-key-123-45678-011121314',
                        type: "GET",
                        data: "",
                        success: function (datas) {
                            console.log(datas);
                            if (datas != null) {
                                self.SystemTypeALL = datas.records.earthquake;
                                self.SystemTypeSL = datas.records.earthquake;
                                console.log(self.SystemTypeALL);
                            }
                            else {
                                openAlertBox("訊息", "查無主系統列表", null, false);
                            }
                            self.Loading = 0;
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            openAlertBox("訊息", "系統讀取失敗", null, false);
                            self.Loading = 0;
                        }
                    });

                },
                //主系統篩選
                SystemTypeListSelect: function () {
                    var self = this;
                    self.SystemTypeSL = [];
                    if (self.SystemTypeS == "All") {
                        self.GetSystemTypeList();
                    } else if (self.SystemTypeS == "Yell") {
                        self.SystemTypeALL.forEach(function (item, index) {
                            if (item.reportColor=="黃色") {
                                self.SystemTypeSL.push(item);
                            }
                        });
                    } else if (self.SystemTypeS == "Green") {
                        self.SystemTypeALL.forEach(function (item, index) {
                            if (item.reportColor == "綠色") {
                                self.SystemTypeSL.push(item);
                            }
                        });
                    } else if (self.SystemTypeS == "Describe") {
                        self.SystemTypeALL.forEach(function (item, index) {
                            if ((item.reportContent).includes(self.SystemTypeSText)) {
                                self.SystemTypeSL.push(item);
                            }
                        });
                    } else if (self.SystemTypeS == "Time") {
                        self.SystemTypeALL.forEach(function (item, index) {
                            if ((item.earthquakeInfo.originTime).includes(self.SystemTypeSText)) {
                                self.SystemTypeSL.push(item);
                            }
                        });
                    }
                },
                //主系統確認
                SystemTypeChose: function (sys) {
                    var self = this;
                    window.open(sys);
                },
                
                //日歷
                datepicker: function () {
                    let vue = this;
                    $.datepicker.regional['zh-TW'] = {
                        dayNames: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
                        dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
                        monthNames: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
                        monthNamesShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
                    };
                    //將預設語系設定為中文
                    $.datepicker.setDefaults($.datepicker.regional["zh-TW"]);
                    $("#dateEnd").datepicker({
                        dateFormat: 'yy/mm/dd', changeMonth: true, changeYear: true, showMonthAfterYear: true, beforeShow: function () {
                            setTimeout(
                                function () {
                                    $('#ui-datepicker-div').css("z-index", 10);
                                }, 100
                            );
                        }
                    }).on('change', function () {
                        vue.dateEndUI = $("#dateEnd").val();
                        vue.dateEnd = $("#dateEnd").val().replace(/\//g, "-");
                        if (vue.dateStart > vue.dateEnd) { //防止開始日期大於結束日期
                            vue.dateEnd = vue.dateStart;
                            vue.dateEndUI = vue.dateStartUI;
                        }
                    });
                    $("#dateStart").datepicker({
                        dateFormat: 'yy/mm/dd', changeMonth: true, changeYear: true, showMonthAfterYear: true, beforeShow: function () {
                            setTimeout(
                                function () {
                                    $('#ui-datepicker-div').css("z-index", 10);
                                }, 100
                            );
                        }
                    }).on('change', function () {
                        vue.dateStartUI = $("#dateStart").val();
                        vue.dateStart = $("#dateStart").val().replace(/\//g, "-");
                        if (vue.dateStart > vue.dateEnd) { //防止開始日期大於結束日期
                            vue.dateStart = vue.dateEnd;
                            vue.dateStartUI = vue.dateEndUI;
                        }
                    });

                },
            }
        });
    </script>
</asp:Content>




