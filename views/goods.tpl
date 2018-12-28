{{template "header"}}
<title>商品分类分析-首页</title>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
{{template "navbar" .}}
{{template "slider" .}}
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <form class="layui-form search-padding" action="">
            <div class="layui-form-item">
                <label class="layui-form-label">商品类型</label>
                <div class="layui-input-inline">
                    <select id="firstChose" lay-filter="chose1">
                    </select>
                </div>
                <label class="layui-form-label">子类型</label>
                <div class="layui-input-inline">
                    <select id="nextChose">
                    </select>
                </div>
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
                    <span class="layui-btn submit-goods" type="button">立即提交</span>
                </div>
            </div>
        </form>
        <div class="table-content">
            <table class="layui-hide" id="test"></table>
        </div>
        <div class="chartMap clearfix">
            <div id="bar-chart1">

            </div>
            <div id="bar-chart2">

            </div>
        </div>
    </div>
{{template "footer"}}
</div>
<script>
    //JavaScript代码区域
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

        // 下拉联动效果
        function formReset() {
            layui.use(['form'], function () {
                var form = layui.form;
                form.render();
                form.on("select(chose1)", function (data) {
                    nextChose(choseResult, data.value, 0)
                })
            })
        }

        // 首次加载下拉内容---数据缓存
        $.ajax({
            type: "get",
            url: "/goods/getChose",
            data: "",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                dataReset(result.Data)
            },
            error: function (err) {
                console.log(err)
            }
        });
        var firstChose = [];
        var choseResult;

        // 数据处理 --- 下拉1 内容获取整理
        function dataReset(result) {
            choseResult = result;
            result.forEach(function (data, index) {
                firstChose.push(data.TopName)
            });
            firstChose = _.uniq(firstChose);
            // 将元素添加到页面
            var firstList = '';
            firstChose.forEach(function (data) {
                firstList += `<option value="` + data + `">` + data + `</option>`
            });
            $("#firstChose").html(firstList);
            formReset();
            nextChose(result, firstChose[0], 1);
        }

        // 下拉2 联动
        function nextChose(all, firstChose, init) {
            var nextChose = [];
            all.forEach(function (data) {
                if (data.TopName === firstChose) {
                    nextChose.push(data.TwoName)
                }
            });
            var nextChoseMap = '';
            nextChose.forEach(function (data) {
                nextChoseMap += `<option value="` + data + `">` + data + `</option>`
            });
            $('#nextChose').html(nextChoseMap);
            formReset();
            // 页面数据初始化加载
            if (init === 1) {
                $('.submit-goods').click()
            }
        }

        // 获取筛选内容
        $('.submit-goods').click(function () {
            var chose1 = $('#firstChose').val();
            var chose2 = $('#nextChose').val();
            var timeStart = $('#timeStart').val();
            var timeEnd = $('#timeEnd').val();
            GetDataall(chose1, chose2, timeStart, timeEnd);
            chartReset(chose1, chose2, timeStart, timeEnd);
        });

        // 表格数据加载
        function GetDataall(chose1, chose2, timeStart, timeEnd) {
            layui.use('table', function () {
                var table = layui.table;

                table.render({
                    elem: '#test'
                    , url: "/goods/getOption"
                    , where: {
                        chose1: chose1,
                        chose2: chose2,
                        timeStart: timeStart + " 00:00:00",
                        timeEnd: timeEnd + " 00:00:00"
                    },
                    toolbar: true,
                    parseData: function (res) {
                        return {
                            "code": res.Code,
                            "msg": res.Msg,
                            "count": res.Count,
                            "data": res.Data
                        };
                    }
                    , cols: [[
                        {field: 'zizeng', title: '序号', type: 'numbers'}
                        , {field: 'Month', title: '时间'}
                        , {field: 'TopName', title: '一级分类'}
                        , {field: 'TwoName', title: '二级分类'}
                        , {field: 'OrAuc', title: '当期绝对量（元）', sort: true}
                        , {field: 'OrAucZb', title: '当期同比增长', sort: true}
                        , {field: 'OrAcc', title: '累计绝对量（元）', sort: true}
                        , {field: 'OrAccZb', title: '累计同比增长', sort: true}
                    ]],
                    page: true,
                    limit: 6
                });
            });
        }

        // charts图开发
        function chartReset(chose1, chose2, timeStart, timeEnd) {
            $.ajax({
                type: "get",
                url: "/goods/GetCharts",
                data: {
                    chose1: chose1,
                    chose2: chose2,
                    timeStart: timeStart + " 00:00:00",
                    timeEnd: timeEnd + " 00:00:00"
                },
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    barChart(result.Data)
                },
                error: function (err) {
                    console.log(err)
                }
            });
        }

        // echarts图表展示
        function barChart(result) {
            var date = [], bar = [], line = [], bar2 = [], line2 = [];

            var mapChart = echarts.init(document.getElementById('bar-chart1'));
            var mapChart2 = echarts.init(document.getElementById('bar-chart2'));
            // 按照时间对数据进行排序
            if (result === null) {
                mapChart.clear();
                mapChart.setOption({});
                mapChart2.clear();
                mapChart2.setOption({});
            } else {
                var list = _.sortBy(result, function (arr) {
                    return arr.Month
                });
                list.forEach(function (data, index) {
                    date.push(data.Month.split("T")[0]);
                    line.push(data.OrAccZb * 100);
                    bar.push((data.OrAcc / 100000000).toFixed(2));
                    line2.push(data.OrAucZb * 100);
                    bar2.push((data.OrAuc / 100000000).toFixed(2));
                });
                barOption(mapChart, date, line, bar, $('#nextChose').val() + "网络零售额当期走势图");
                barOption(mapChart2, date, line2, bar2, $('#nextChose').val() + "网络零售额累计走势图");
            }

        }

        // echartsoption通用
        function barOption(echartsDom, date, bar, line, title) {
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
            )
        }
    }()
</script>
</body>
</html>
