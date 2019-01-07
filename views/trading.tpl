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
        <div class="chartMap clearfix">
            <div id="pie-1">

            </div>
            <div id="bar-chart1">

            </div>
        </div>
        <div class="chartMap clearfix" style="border-top: 1px solid #E6E6E6">
            <div id="pie-2">
            </div>
            <div id="bar-chart2">
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
                content += `<option value="` + ele.Trads + `">` + ele.Trads + `</option>`
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
                            {field: 'Name', title: '平台', rowspan: 3},
                            {align: 'center', title: '网络零售额', colspan: 6}
                        ],
                        [
                            {align: 'center', title: '当期', colspan: 3},
                            {align: 'center', title: '累计', colspan: 3},
                        ],
                        [
                            {field: 'OrCur', title: '绝对量', sort: true},
                            {field: 'OrCurYoy', title: '同比', sort: true},
                            {field: 'OrCurZb', title: '占比', sort: true},
                            {field: 'OrAcc', title: '绝对量', sort: true},
                            {field: 'OrAccYoy', title: '同比', sort: true},
                            {field: 'OrAccZb', title: '占比', sort: true},
                        ]
                    ],
                    page: true,
                    limit: 6
                });
            });
            // 请求饼图折线图数据
            $.ajax({
                type: "get",
                url: "/trading/GetTradMap",
                data: map,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    dataReset(result.Data);
                },
                error: function (err) {
                    console.log(err)
                }
            });
            // 饼图占比
            $.ajax({
                type: "get",
                url: "/trading/GetTradZb",
                data: {
                    timeStart: $('#timeStart').val() + " 00:00:00",
                    timeEnd: $('#timeEnd').val() + " 00:00:00",
                    trad: $('#trad').val(),
                    types: "当期"
                },
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    pieData(result.Data);
                },
                error: function (err) {
                    console.log(err)
                }
            });
        });

        function dataReset(data) {
            var list = _.sortBy(data, function (arr) {
                return arr.DataMonth
            });
            var bar1 = {
                date: [],
                line: [],
                bar: []
            };
            var bar2 = {
                date: [],
                line: [],
                bar: []
            };
            list.forEach(function (data, index) {
                bar1.date.push(data.DataMonth.split("T")[0]);
                bar1.bar.push((data.OrCur / 100000000).toFixed(2));
                bar1.line.push(data.OrCurYoy);
                bar2.date.push(data.DataMonth.split("T")[0]);
                bar2.bar.push((data.OrAcc / 100000000).toFixed(2));
                bar2.line.push(data.OrAccYoy);
            });
            var barDom1 = echarts.init(document.getElementById('bar-chart1'));
            var barDom2 = echarts.init(document.getElementById('bar-chart2'));
            barOption(barDom1, bar1, $('#trad').val() + "网络零售额当期走势图");
            barOption(barDom2, bar2, $('#trad').val() + "网络零售额累计走势图");
        }

        function barOption(echartsDom, map, title) {
            echartsDom.clear();
            echartsDom.setOption(
                    {
                        color: ['#008000'],
                        title: {
                            text: title,
                            left: "center"
                        },
                        tooltip: {
                            trigger: 'axis'
                        },
                        xAxis: {
                            type: 'category',
                            data: map.date
                        },
                        yAxis: [
                            {
                                type: 'value',
                                name: "绝对量（亿元）"
                            },
                            {
                                type: 'value',
                                name: "同比（%）"
                            }
                        ],
                        dataZoom: [{
                            type: 'inside',
                            start: 20,
                            end: 70
                        }, {
                            start: 20,
                            end: 70,
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
                                name: '绝对量',
                                type: 'bar',
                                barWidth: '50%',
                                itemStyle: {
                                    barBorderRadius: 5,
                                    color: new echarts.graphic.LinearGradient(
                                            0, 0, 0, 1,
                                            [
                                                {offset: 0, color: '#7bc1f9'},
                                                {offset: 1, color: '#2F9cf3'}
                                            ]
                                    )
                                },
                                data: map.bar
                            },
                            {
                                name: '同比',
                                yAxisIndex: 1,
                                type: 'line',
                                data: map.line
                            }
                        ]
                    }
            )
        }

        function pieData(data) {
            var date = [];
            data.forEach(function (ele) {
                date.push(ele.DataMonth.split("T")[0])
            });
            var dom = echarts.init(document.getElementById('pie-1'));
            var dom2 = echarts.init(document.getElementById('pie-2'))
            pieOption(dom, date, data, "当期网络销售额分交易平台占比");
            pieOption(dom2, date, data, "网络销售额累计分交易平台占比");
        }

        function pieOption(dom, date, result, title) {
            var seriesMap = [];
            var tradMap = {
                Tb: "淘宝网",
                Sn: "苏宁易购",
                Tm: "天猫商城",
                Wph: "唯品会",
                Ymx: "亚马逊(中国)",
                Ddw: "当当网",
                Gm: "国美在线",
                Jd: "京东商城",
                Jm: "聚美优品",
                Qt: "其他",
                Bbw: "贝贝网",
                Sk: "寺库网"
            };
            result.forEach(function (ele) {
                seriesMap.push({
                            title: {
                                text: ele.DataMonth.split("T")[0] + title,
                                left: 'center'
                            },
                            series: {
                                data: [
                                    {value: ele.Tb, name: tradMap['Tb']},
                                    {value: ele.Sn, name: tradMap['Sn']},
                                    {value: ele.Tm, name: tradMap['Tm']},
                                    {value: ele.Wph, name: tradMap['Wph']},
                                    {value: ele.Ymx, name: tradMap['Ymx']},
                                    {value: ele.Ddw, name: tradMap['Ddw']},
                                    {value: ele.Gm, name: tradMap['Gm']},
                                    {value: ele.Jm, name: tradMap['Jm']},
                                    {value: ele.Jd, name: tradMap['Jd']},
                                    {value: ele.Qt, name: tradMap['Qt']},
                                    {value: ele.Bbw, name: tradMap['Bbw']},
                                    {value: ele.Sk, name: tradMap['Sk']}
                                ]
                            }
                        }
                )
            });
            dom.clear();
            dom.setOption({
                        baseOption: {
                            timeline: {
                                axisType: 'category',
                                autoPlay: true,
                                playInterval: 2000,
                                data: date
                            },
                            tooltip: {
                                trigger: 'item',
                                formatter: "{a} <br/>{b}: {c} ({d}%)"
                            },
                            legend: {
                                orient: 'vertical',
                                x: 'left',
                                data: [
                                    '苏宁易购',
                                    '淘宝网',
                                    '天猫商城',
                                    '唯品会',
                                    '亚马逊(中国)',
                                    '当当网',
                                    '国美在线',
                                    '京东商城',
                                    '聚美优品',
                                    '其他',
                                    '贝贝网',
                                    '寺库网'
                                ]
                            },
                            series: [
                                {
                                    type: 'pie',
                                    radius: ['30%', '50%'],
                                    avoidLabelOverlap: false,
                                    data: seriesMap[0].data
                                }
                            ]
                        },
                        options: seriesMap
                    }
            )
        }
    }()
</script>
</body>
</html>
