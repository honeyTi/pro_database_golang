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
                    <span class="layui-btn submit-goods" type="button">查询</span>
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
            var province = [],content = "";
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
            var city = [],content = '';
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
                countyChose(data, $('#city-chose').val())
            }
        }
        function countyChose(data, chose) {
            var county = [],content = '';
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
    }()
</script>
</body>
</html>
