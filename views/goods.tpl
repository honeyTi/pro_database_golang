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
                    <select name="parentChose">
                        <option value="浙江" selected="">浙江省</option>
                        <option value="你的工号">江西省</option>
                        <option value="你最喜欢的老师">福建省</option>
                    </select>
                </div>
                <label class="layui-form-label">子类型</label>
                <div class="layui-input-inline">
                    <select name="childChose">
                        <option value="浙江" selected="">浙江省</option>
                        <option value="你的工号">江西省</option>
                        <option value="你最喜欢的老师">福建省</option>
                    </select>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">起止时间</label>
                    <div class="layui-input-inline">
                        <input type="text" name="timeStart" class="layui-input" id="timeStart" placeholder="yyyy/MM">
                    </div>
                    <span class="fl" style="line-height: 38px;margin-right: 10px"> -  </span>
                    <div class="layui-input-inline">
                        <input type="text" name="timeEnd" class="layui-input" id="timeEnd" placeholder="yyyy/MM">
                    </div>
                </div>
                <div class="layui-inline">
                    <span class="layui-btn" type="button">立即提交</span>
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
        layui.use(['form', 'laydate'], function () {
            var form = layui.form;
            var laydate = layui.laydate;
            form.render();
            laydate.render({
                elem: '#timeStart',
                type: 'month',
                format: 'yyyy/MM'
            });
            laydate.render({
                elem: '#timeEnd',
                type: 'month',
                format: 'yyyy/MM'
            });
        });
        // 首次加载下拉内容
        $.ajax({
            type: "get",
            url: "/goods/getOption",
            data: "",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                console.log(result)
            },
            error: function ( err){
                console.log(err)
            }
        });
    }()
</script>
</body>
</html>
