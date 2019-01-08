{{template "header"}}
<title>交易方式分析</title>
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
                <label class="layui-form-label">交易方式</label>
                <div class="layui-inline">
                    <select id="trad" lay-filter="trad">
                        <option value="B2C">B2C</option>
                        <option value="C2C">C2C</option>
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
        <div class="chartMap clearfix">
            <div id="pie-1">

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
        $('.submit-map').click(function () {
            layui.use('table', function () {
                var table = layui.table;
                table.render({
                    elem: '#test',
                    url: "/transaction/getTrad",
                    where: {
                        types: '交易类型',
                        trad: $('#trad').val(),
                        timeStart: $('#timeStart').val() + " 00:00:00",
                        timeEnd: $('#timeEnd').val() + " 00:00:00"
                    },
                    toolbar: true,
                    parseData: function (res) {
                        console.log(res);
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
                            {align: 'center', title: $('#trad').val(), colspan: 6},
                        ],
                        [
                            {align: 'center', title: '当期', colspan: 3},
                            {align: 'center', title: '累计', colspan: 3}
                        ],
                        [
                            {field: 'OrCur', title: '绝对量', sort: true},
                            {field: 'OrCurYoy', title: '同比', sort: true},
                            {field: 'OrCurZb', title: '占比', sort: true},
                            {field: 'OrAcc', title: '绝对量', sort: true},
                            {field: 'OrAccYoy', title: '同比', sort: true},
                            {field: 'OrAccZb', title: '占比', sort: true}
                        ]
                    ],
                    page: true,
                    limit: 6
                });
            });
            $.ajax({
                type: "get",
                url: "/transaction/getTradAll",
                data: {
                    types: '交易类型',
                    trad: $('#trad').val(),
                    timeStart: $('#timeStart').val() + " 00:00:00",
                    timeEnd: $('#timeEnd').val() + " 00:00:00"
                },
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    dataReset(result.Data);
                },
                error: function (err) {
                    console.log(err)
                }
            });
        });
        function dataReset(data) {
            var dom = echarts.init(document.getElementById('pie-1'));
            var bar1 = [],bar2 = [],date = [];
            data.forEach(function (ele) {
                bar1.push(ele.OrCur / 100000000);
                bar2.push(ele.OrAcc / 100000000);
                date.push(ele.DataMonth.split("T")[0]);
            });
            barOption(dom, date, bar1, bar2, $('#trad').val() + "网络销售额对比")
        }

        function barOption(echartsDom, date, bar1, bar2, title) {
            echartsDom.clear();
            echartsDom.setOption(
                    {
                        color: ['#008000'],
                        title: {
                            text: title,
                            left: "center"
                        },
                        legend: {
                            data:['当期','累计'],
                            bottom: "2%"
                        },
                        grid: {
                            left: '5%',
                            right: '6%',
                            bottom: '25%'
                        },
                        tooltip: {
                            trigger: 'axis'
                        },
                        xAxis: {
                            type: 'category',
                            data: date
                        },
                        yAxis: [
                            {
                                type: 'value',
                                name: "绝对量（亿元）"
                            }
                        ],
                        dataZoom: [{
                            type: 'inside',
                            start: 20,
                            end: 70
                        }, {
                            start: 20,
                            end: 70,
                            bottom: '8%',
                            handleSize: '80%',
                            handleStyle: {
                                color: '#fff',
                                shadowBlur: 3,
                                shadowColor: 'rgba(0, 0, 0, 1)',
                                shadowOffsetX: 2,
                                shadowOffsetY: 2
                            }
                        }],
                        series: [
                            {
                                name: '当期',
                                type: 'bar',
                                itemStyle: {
                                    barBorderRadius: 2,
                                    color: new echarts.graphic.LinearGradient(
                                            0, 0, 0, 1,
                                            [
                                                {offset: 0, color: '#7bc1f9'},
                                                {offset: 1, color: '#2F9cf3'}

                                            ]
                                    )
                                },
                                data: bar1
                            }, {
                                name: '累计',
                                type: 'bar',
                                itemStyle: {
                                    barBorderRadius: 2,
                                    color: new echarts.graphic.LinearGradient(
                                            0, 0, 0, 1,
                                            [
                                                {offset: 0, color: '#D53A35'},
                                                {offset: 1, color: '#C23531'}

                                            ]
                                    )
                                },
                                data: bar2
                            }
                        ]
                    }
            );
        }

        $('.submit-map').click();
    }()
</script>
</body>
</html>
