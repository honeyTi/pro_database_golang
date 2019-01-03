{{template "header"}}
<title>大数据-首页</title>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
{{template "navbar" .}}
{{template "slider" .}}
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <form class="layui-form search-padding" action="">
            <div class="layui-form-item">
                <div class="layui-inline">
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
        <!-- charts图2 -->
        <div class="chartMap chartMap-1 clearfix" style="border-top: 1px solid #E6E6E6">
            <div class="map-detail-2">

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
        $('.submit-map').click(function () {
            $.ajax({
                type: "get",
                url: "/index/GetCharts",
                data: {
                    types: '总体',
                    timeStart: $('#timeStart').val() + " 00:00:00",
                    timeEnd: $('#timeEnd').val() + " 00:00:00"
                },
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    if (result.Code === 0) {
                        dataReset(result.Data);
                    } else {
                        console.log('暂无数据')
                    }
                },
                error: function (err) {
                    console.log(err)
                }
            });
            layui.use('table', function () {
                var table = layui.table;
                table.render({
                    elem: '#test',
                    url: "/index/getTotal",
                    where: {
                        types: '总体',
                        timeStart: $('#timeStart').val() + " 00:00:00",
                        timeEnd: $('#timeEnd').val() + " 00:00:00"
                    },
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
                            {align: 'center', title: '网络零售额', colspan: 4},
                            {align: 'center', title: '实用商品网络销售额', colspan: 4}
                        ],
                        [
                            {align: 'center', title: '当期', colspan: 2},
                            {align: 'center', title: '累计', colspan: 2},
                            {align: 'center', title: '当期', colspan: 2},
                            {align: 'center', title: '累计', colspan: 2}
                        ],
                        [
                            {field: 'OrCur', title: '绝对量', sort: true},
                            {field: 'OrCurYoy', title: '同比', sort: true},
                            {field: 'OrAcc', title: '绝对量', sort: true},
                            {field: 'OrAccYoy', title: '同比', sort: true},
                            {field: 'KindCur', title: '绝对量', sort: true},
                            {field: 'KindCurYoy', title: '同比', sort: true},
                            {field: 'KindAcc', title: '绝对量', sort: true},
                            {field: 'KindAccYoy', title: '同比', sort: true},
                        ]
                    ],
                    page: true,
                    limit: 6
                });
            });
        });
        $('.submit-map').click();

        function dataReset(data) {
            var barDom1 = echarts.init(document.getElementById('bar-chart1'));
            var barDom2 = echarts.init(document.getElementById('bar-chart2'));
            var map1 = {
                date: [],
                bar: [],
                line: [],
            };
            var map2 = {
                date: [],
                bar: [],
                line: []
            };
            data.forEach(function (ele) {
                map1.bar.push(ele.OrCur / 100000000);
                map1.line.push(ele.OrCurYoy);
                map1.date.push(ele.DataMonth.split('T')[0]);
                map2.date.push(ele.DataMonth.split('T')[0]);
                map2.bar.push(ele.KindCur / 100000000);
                map2.line.push(ele.KindCurYoy);
            });
            barOption(barDom1, map1.date, map1.bar, map1.line, "网络零售当期走势图", data);
            barOption(barDom2, map2.date, map2.bar, map2.line, "实用商品网络零售额当期走势图", data);
        }

        // 折线图
        function barOption(echartsDom, date, bar, line, title, data) {
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
                            data: date
                        },
                        yAxis: [
                            {
                                type: 'value',
                                name: "绝对量（亿元）"
                            },
                            {
                                type: 'value',
                                name: "占比（%）"
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
                                data: bar
                            },
                            {
                                name: '占比',
                                yAxisIndex: 1,
                                type: 'line',
                                data: line
                            }
                        ]
                    }
            );
            data.forEach(function (ele) {
                if (ele.DataMonth === data[data.length-1].DataMonth) {
                    if (title === '网络零售当期走势图') {
                        $('.map-detail-1').html(
                                '<p><span class="icon icon-dangqi"></span>当期网络销售额: <span class="red">' + ele.OrCur/100000000 + '</span> 亿元</p>' +
                                '<p><span class="icon icon-dangqiline"></span>当期网络销售额同比: <span class="red">' + ele.OrCurYoy + '</span> %</p>' +
                                '<p><span class="icon icon-leiji"></span>累计网络销售额: <span class="red">' + ele.OrAcc/100000000 + '</span> 亿元</p>' +
                                '<p><span class="icon icon-leijiline"></span>累计网络销售额同比: <span class="red">' + ele.OrAccYoy + '</span> %</p>'
                        )
                    } else if (title === '实用商品网络零售额当期走势图') {
                        $('.map-detail-2').html(
                                '<p><span class="icon icon-dangqi"></span>当期实用商品网络零售额: <span class="red">' + ele.KindCur/100000000 + '</span> 亿元</p>' +
                                '<p><span class="icon icon-dangqiline"></span>当期实用商品网络零售额同比: <span class="red">' + ele.KindCurYoy + '</span> %</p>' +
                                '<p><span class="icon icon-leiji"></span>累计实用商品网络销售额: <span class="red">' + ele.KindAcc/100000000 + '</span> 亿元</p>' +
                                '<p><span class="icon icon-leijiline"></span>累计实用商品网络销售额同比: <span class="red">' + ele.KindAccYoy + '</span> %</p>'
                        )
                    }
                }
            })
            echartsDom.on('click', function (params) {
                console.log(params)
                data.forEach(function (ele) {
                    if (ele.DataMonth.split('T')[0] === params.name) {
                        params.color.colorStops = [
                            {offset: 0, color: "#7bc1f9"},
                            {offset: 1, color: "#2F9cf3"}
                        ];
                        if (params.componentSubType === "bar" && title === '网络零售当期走势图') {
                            $('.map-detail-1').html(
                                    '<p><span class="icon icon-dangqi"></span>当期网络销售额: <span class="red">' + ele.OrCur/100000000 + '</span> 亿元</p>' +
                                    '<p><span class="icon icon-dangqiline"></span>当期网络销售额同比: <span class="red">' + ele.OrCurYoy + '</span> %</p>' +
                                    '<p><span class="icon icon-leiji"></span>累计网络销售额: <span class="red">' + ele.OrAcc/100000000 + '</span> 亿元</p>' +
                                    '<p><span class="icon icon-leijiline"></span>累计网络销售额同比: <span class="red">' + ele.OrAccYoy + '</span> %</p>'
                            )
                        } else if (params.componentSubType === "bar" && title === '实用商品网络零售额当期走势图') {
                            $('.map-detail-2').html(
                                    '<p><span class="icon icon-dangqi"></span>当期实用商品网络零售额: <span class="red">' + ele.KindCur/100000000 + '</span> 亿元</p>' +
                                    '<p><span class="icon icon-dangqiline"></span>当期实用商品网络零售额同比: <span class="red">' + ele.KindCurYoy + '</span> %</p>' +
                                    '<p><span class="icon icon-leiji"></span>累计实用商品网络销售额: <span class="red">' + ele.KindAcc/100000000 + '</span> 亿元</p>' +
                                    '<p><span class="icon icon-leijiline"></span>累计实用商品网络销售额同比: <span class="red">' + ele.KindAccYoy + '</span> %</p>'
                            )
                        }
                    }
                })
            });
        }
    }()
</script>
</body>
</html>
