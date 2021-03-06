{{template "components/header_t.tpl"}}
<title>商品分类分析-首页</title>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
{{template "components/navbar_t.tpl" .}}
{{template "components/slider_bar_t.tpl" .}}
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <form class="layui-form search-padding" action="">
            <div class="layui-form-item">
                <label class="layui-form-label">地域选择</label>
                <div class="layui-input-inline">
                    <select id="prov-chose" lay-filter="prov">
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select id="city-chose" lay-filter="city">
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select id="county-chose" lay-filter="county">
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
                    <span class="layui-btn submit-map" type="button">查询</span>
                </div>
            </div>
        </form>
        <div class="table-content">
            <table class="layui-hide" id="test"></table>
        </div>
        <div class="chartMap chartMap-2 clearfix">
            <div id="bar-chart1">

            </div>
            <div id="bar-chart2">

            </div>
        </div>
    </div>
{{template "components/footer_t.tpl"}}
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

        // layui form元素初始化
        function formReset() {
            layui.use(['form'], function () {
                var form = layui.form;
                form.render();
            })
        }

        var cityList;
        // 获取三级联动表数据
        $.ajax({
            type: "get",
            url: "/area/getCityList",
            data: "",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                if (result.Code === 0) {
                    choseMap(result.Data);
                    cityList = result.Data;
                }
            },
            error: function (err) {
                console.log(err)
            }
        });

        // 三级联动效果
        function choseMap(data) {
            var province = [], content = "";
            data.forEach(function (ele, index) {
                province.push(ele.ProvinceName)
            });
            _.uniq(province).forEach(function (ele, index) {
                content += `<option value="` + ele + `">` + ele + `</option>`
            });
            $('#prov-chose').html(content);
            proChoseReset();
            cityChose(data, $('#prov-chose').val(), 1)
        }

        function cityChose(data, chose, init) {
            var city = [], content = '';
            data.forEach(function (ele) {
                if (ele.ProvinceName === chose) {
                    city.push(ele.CityName)
                }
            });
            _.uniq(city).forEach(function (ele) {
                content += `<option value="` + ele + `">` + ele + `</option>`
            });
            $('#city-chose').html(content);
            cityChoseReset();
            if (init === 1) {
                countyChose(data, $('#city-chose').val(), 1)
            }
        }

        function countyChose(data, chose, init) {
            var county = [], content = '';
            data.forEach(function (ele) {
                if (ele.CityName === chose) {
                    county.push(ele.CountyName)
                }
            });
            county.forEach(function (ele) {
                content += `<option value="` + ele + `">` + ele + `</option>`
            });
            $('#county-chose').html(content);
            formReset();
            if (init === 1) {
                $('.submit-map').click();
            }
        }

        function proChoseReset() {
            layui.use(['form'], function () {
                var form = layui.form;
                form.render();
                form.on("select(prov)", function (data) {
                    cityChose(cityList, data.value, 1)
                })
            });
        }

        function cityChoseReset() {
            layui.use(['form'], function () {
                var form = layui.form;
                form.render();
                form.on("select(city)", function (data) {
                    countyChose(cityList, data.value)
                })
            });
        }

        // 查询数据
        $(".submit-map").click(function () {
            var map = {
                prov: $('#prov-chose').val(),
                city: $('#city-chose').val(),
                county: $('#county-chose').val(),
                timeStart: $('#timeStart').val() + " 00:00:00",
                timeEnd: $('#timeEnd').val() + " 00:00:00"
            };
            layui.use('table', function () {
                var table = layui.table;
                table.render({
                    elem: '#test'
                    , url: "/area/getTableMap"
                    , where: map,
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
                            {field: 'DateMonth', title: '时间', rowspan: 3},
                            {field: 'ProvinceName', title: '省份', rowspan: 3},
                            {field: 'CityName', title: '市', rowspan: 3},
                            {field: 'CountyName', title: '区/县', rowspan: 3},
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
            // 获取地图数据
            $.ajax({
                type: "get",
                url: "/area/getMapData",
                data: {
                    prov: '省市',
                    timeEnd: $('#timeEnd').val() + " 00:00:00"
                },
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    mapDataReset(result.Data)
                },
                error: function (err) {
                    console.log(err)
                }
            });
        });

        // 地图数据
        function mapDataReset(data) {
            var date = [], dataResetMap = [];
            data.forEach(function (ele) {
                date.push(ele.DataMonth.split("T")[0])
            });
            date = _.uniq(date);
            date.forEach(function (ele) {
                dataResetMap.push(
                        {
                            date: ele,
                            map: []
                        }
                );
            })
            dataResetMap.forEach(function (list) {
                data.forEach(function (ele) {
                    if (ele.DataMonth.split("T")[0] === list.date) {
                        list.map.push(
                                {
                                    name: ele.Name.indexOf("省") !== -1 ? ele.Name.split('省')[0] : ele.Name.indexOf("内蒙古") !== -1? "内蒙古" : ele.Name.substring(0, 2),
                                    value: (ele.OrCur / 100000000).toFixed(2)
                                }
                        )
                    }
                })
            });
            var dom = echarts.init(document.getElementById('bar-chart1'));
            mapCharts(dom, date, dataResetMap, "各省份当期网络零售额绝对量")
        }

        function mapCharts(dom, date, dataMap, title) {
            var seriseMap = [];
            dataMap.forEach(function (ele) {
                seriseMap.push({
                    series: {
                        name: ele.date,
                        type: 'map',
                        mapType: 'china',
                        label: {
                            normal: {
                                show: false
                            },
                            emphasis: {
                                show: true
                            }
                        },
                        data: ele.map
                    },
                })
            });
            dom.clear();
            dom.setOption({
                baseOption: {
                    timeline: {
                        // y: 0,
                        axisType: 'category',
                        autoPlay: true,
                        playInterval: 2000,
                        data: date
                    },
                    tooltip: {},
                    title: {
                        text: title,
                        left: 'center'
                    },
                    visualMap: {
                        min: 0,
                        max: 1500,
                        left: 'left',
                        top: 'bottom',
                        text: ['高', '低'],
                        inRange: {
                            color: ['#e0ffff', '#006edd']
                        }
                    },
                    geo: {
                        map: 'china',
                        roam: true,
                        label: {
                            normal: {
                                show: true,
                                textStyle: {
                                    color: 'rgba(0,0,0,0.4)'
                                }
                            }
                        },
                        itemStyle: {
                            normal: {
                                borderColor: 'rgba(0, 0, 0, 0.2)'
                            },
                            emphasis: {
                                areaColor: null,
                                shadowOffsetX: 0,
                                shadowOffsetY: 0,
                                shadowBlur: 20,
                                borderWidth: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        }
                    },
                    series: [
                        {
                            name: '',
                            type: 'map',
                            geoIndex: 0,
                            data: []
                        }
                    ]
                },
                options: seriseMap
            });
            var dom1 = echarts.init(document.getElementById('bar-chart2'));
            dom.on("timelinechanged", function (params) {
                barOption(dom1, dataMap[params.currentIndex])
            })
            barOption(dom1, dataMap[0])
        }
        function barOption(echartsDom, data) {
            var bar=[],xAisData=[];
            var list = _.sortBy(data.map, function (arr) {
                return -arr.value;
            });
            list.slice(0, 10).forEach(function (ele) {
                bar.push(ele.value);
                xAisData.push(ele.name);
            });
            echartsDom.setOption(
                    {
                        color: ['#008000'],
                        title: {
                            text: data.date + "网络零售额当期前十省份排名",
                            left: "center"
                        },
                        tooltip: {
                            trigger: 'axis'
                        },
                        grid: {
                            top: "10%",
                            right: "8%",
                            left: "8%",
                            bottom: "5%"
                        },
                        yAxis: {
                            type: 'category',
                            data: xAisData.reverse()
                        },
                        xAxis: [
                            {
                                position: 'top',
                                type: 'value',
                                name: "绝对量（亿元）"
                            }
                        ],
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
                                data: bar.reverse()
                            }
                        ]
                    }
            )
        }
    }()
</script>
</body>
</html>
