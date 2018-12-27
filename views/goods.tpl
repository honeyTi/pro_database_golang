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
                        <input type="text" name="timeStart" class="layui-input" readonly id="timeStart" placeholder="yyyy-MM-dd">
                    </div>
                    <span class="fl" style="line-height: 38px;margin-right: 10px"> -  </span>
                    <div class="layui-input-inline">
                        <input type="text" name="timeEnd" class="layui-input" readonly id="timeEnd" placeholder="yyyy-MM-dd">
                    </div>
                </div>
                <div class="layui-inline">
                    <span class="layui-btn submit-goods" type="button">立即提交</span>
                </div>
            </div>
        </form>
        <div class="table-content">

        </div>
    </div>
{{template "footer"}}
</div>
<script>
    //JavaScript代码区域
    +function () {
        function loadLayui (){
            layui.use(['form', 'laydate'], function () {
                var form = layui.form;
                var laydate = layui.laydate;
                form.render();
                laydate.render({
                    elem: '#timeStart',
                    format: 'yyyy-MM-dd',
                    value: ''
                });
                laydate.render({
                    elem: '#timeEnd',
                    format: 'yyyy-MM-dd'
                });
            });
        }
        loadLayui();
        function formReset() {
            layui.use(['form'], function () {
                var form = layui.form;
                form.render();
                form.on("select(chose1)", function (data) {
                    nextChose(choseResult, data.value)
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
            success: function (data) {
                dataReset(data.Result)
            },
            error: function (err){
                console.log(err)
            }
        });
        var firstChose = [];
        var choseResult;
        // 数据处理
        function dataReset(result) {
            choseResult = result;
            result.forEach(function (data, index) {
                firstChose.push(data.TopName)
            });
            firstChose = _.uniq(firstChose);
            // 将元素添加到页面
            var firstList = '';
            firstChose.forEach(function (data) {
                firstList += `<option value="`+data+`">`+data+`</option>`
            });
            $("#firstChose").html(firstList);
            formReset();
            nextChose(result, firstChose[0]);
        }
        // 下拉2 联动
        function nextChose(all, firstChose) {
            var nextChose = [];
            all.forEach(function (data) {
                if (data.TopName === firstChose) {
                    nextChose.push(data.TwoName)
                }
            });
            var nextChoseMap = '';
            nextChose.forEach(function (data) {
                nextChoseMap += `<option value="`+data+`">`+data+`</option>`
            });
            $('#nextChose').html(nextChoseMap);
            formReset()
        }
        $('.submit-goods').click(function () {
            var chose1 = $('#firstChose').val();
            var chose2 = $('#nextChose').val();
            var timeStart = $('#timeStart').val();
            var timeEnd = $('#timeEnd').val();
            GetDataall(chose1, chose2, timeStart, timeEnd);
        });

        function GetDataall(chose1, chose2, timeStart, timeEnd) {
            $.ajax({
                type: "get",
                url: "/goods/getOption",
                data: {
                    chose1: chose1,
                    chose2: chose2,
                    timeStart: timeStart + " 00:00:00",
                    timeEnd:timeEnd + " 00:00:00"
                },
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    console.log(data)
                },
                error: function (err){
                    console.log(err)
                }
            });
        }
    }()
</script>
</body>
</html>
