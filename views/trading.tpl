{{template "header"}}
<title>交易平台分析</title>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    {{template "navbar" .}}
    {{template "slider" .}}
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <form class="layui-form search-padding" action="">
            <div class="layui-form-item">
                <label class="layui-form-label">起止时间</label>
                <div class="layui-input-inline">
                    <input type="text" name="timeStart" class="layui-input" readonly id="timeStart"
                           placeholder="yyyy-MM-dd">
                </div>
                <span class="fl" style="line-height: 38px;margin-right: 10px"> -  </span>
                <div class="layui-input-inline">
                    <input type="text" name="timeEnd" class="layui-input" readonly id="timeEnd"
                           placeholder="yyyy-MM-dd">
                </div>
                <label class="layui-form-label">平台类型</label>
                <div class="layui-inline">
                    <select id="trad" lay-filter="trad">
                    </select>
                </div>
                <div class="layui-inline">
                    <span class="layui-btn submit-map" type="button">查询</span>
                </div>
            </div>
        </form>
        <!-- 表格 -->
        <div class="table-content">
            <table class="layui-hide" id="test"></table>
        </div>
        <!-- charts图 -->
        <div class="chartMap chartMap-1 clearfix">
            <div class="map-detail-1">

            </div>
            <div id="bar-chart1">

            </div>
        </div>
    </div>
    {{template "footer"}}
</div>
<script>
    +function () {
        function loadLayui() {
            layui.use(['form', 'laydate'], function () {
                var form = layui.form;
                var laydate = layui.laydate;
                form.render();
                laydate.render({
                    elem: '#timeStart',
                    format: 'yyyy-MM-dd',
                    value: '2016-12-01'
                });
                laydate.render({
                    elem: '#timeEnd',
                    format: 'yyyy-MM-dd',
                    value: '2018-12-01'
                });
            });
        }
        loadLayui();
        // 获取下拉选项
        $.ajax({
            type: "get",
            url: "/trading/trad",
            data: "",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                chosen(result.Data);
            },
            error: function (err) {
                console.log(err);
            }
        });
        // 下拉选项获取
        function chosen(data) {
            var content = '';
            data.forEach(function (ele) {
                content +=  `<option value="` + ele.Trads + `">` + ele.Trads + `</option>`
            });
            $('#trad').html(content);
            loadLayui();
            $('.submit-map').click();
        }
        // 获取平台数据
        $('.submit-map').click(function () {
            var map = {
                timeStart: $('#timeStart').val() + " 00:00:00",
                timeEnd: $('#timeEnd').val() + " 00:00:00",
                list: $('#trad').val(),
                types: "平台"
            };
            layui.use('table', function () {
                var table = layui.table;
                table.render({
                    elem: '#test',
                    url: "/trading/tradDetail",
                    where: map,
                    toolbar: true,
                    parseData: function (res) {
                        console.log(res)
                        return {
                            "code": res.Code,
                            "msg": res.Msg,
                            "count": res.Count,
                            "data": res.Data
                        };
                    },
                    cols: [
                        [
                            {field: 'zizeng', title: '序号', type: 'numbers', rowspan: 3},
                            {field: 'DataMonth', title: '时间', rowspan: 3},
                            {field: 'Name', title: '时间', rowspan: 3},
                            {align: 'center', title: '网络零售额', colspan: 6},
                            {align: 'center', title: '实用商品网络销售额', colspan: 6}
                        ],
                        [
                            {align: 'center', title: '当期', colspan: 3},
                            {align: 'center', title: '累计', colspan: 3},
                            {align: 'center', title: '当期', colspan: 3},
                            {align: 'center', title: '累计', colspan: 3}
                        ],
                        [
                            {field: 'OrCur', title: '绝对量', sort: true},
                            {field: 'OrCurYoy', title: '同比', sort: true},
                            {field: 'OrCurZb', title: '占比', sort: true},
                            {field: 'OrAcc', title: '绝对量', sort: true},
                            {field: 'OrAccYoy', title: '同比', sort: true},
                            {field: 'OrAccZb', title: '占比', sort: true},
                            {field: 'KindCur', title: '绝对量', sort: true},
                            {field: 'KindCurYoy', title: '同比', sort: true},
                            {field: 'KindCurZb', title: '占比', sort: true},
                            {field: 'KindAcc', title: '绝对量', sort: true},
                            {field: 'KindAccYoy', title: '同比', sort: true},
                            {field: 'KindAccZb', title: '占比', sort: true},
                        ]
                    ],
                    page: true,
                    limit: 6
                });
            });
        });
    }()
</script>
</body>
</html>
