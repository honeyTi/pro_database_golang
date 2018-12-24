{{template "header"}}
<title>大数据-首页</title>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    {{template "navbar" .}}
    {{template "slider" .}}
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;">内容主体区域</div>
    </div>
    {{template "footer"}}
</div>
<script>
    //JavaScript代码区域
    layui.use('element', function () {
        var element = layui.element;

    });
</script>
</body>
</html>
