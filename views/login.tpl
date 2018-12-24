{{template "header"}}
    <title>系统-登录</title>
</head>
<body>

<div class="login">
    <div id="snow"></div>
    <form action="/login" method="post" class="login-map layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label"><span class="icon icon-mima"></span></label>
            <div class="layui-input-block">
                <input type="text" name="uname" id="uname" lay-verify="title" placeholder="请输入账号" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><span class="icon icon-xiaoren"></span></label>
            <div class="layui-input-block">
                <input type="password" id="pwd" name="pwd" lay-verify="required" placeholder="请输入密码"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item login-btn-map">
            <div class="layui-input-block" style="text-align: right">
                <a href="/register" class="layui-btn">注册</a>
                <button type="submit" class="layui-btn" id="submitBtn" onclick="loginMap()">登录</button>
            </div>
        </div>
    {{if .LoginState}}
    {{else}}
        <script>

        </script>
    {{end}}
    </form>
</div>
<script type="text/javascript">
    $("#snow").fallingSnow();
    function loginMap() {
        var uname = $("#uname").val()
        var upwd = $("#pwd").val()
        if (uname.length === 0 || uname === undefined) {
            modelOpen("提示", "账号不能为空")
            return false
        }
        if (upwd.length === 0 || upwd === undefined) {
            modelOpen("提示", "密码不能为空")
            return false
        }
        return true
    }
    function modelOpen(title, content) {
        layer.open({
            title: title
            , content: content
        });
    }
</script>
</body>
</html>