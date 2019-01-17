{{template "components/header_t.tpl"}}
    <title>系统-登录</title>
</head>
<body>

<div class="login">
    <div id="snow"></div>
    <form action="/login" method="post" class="login-map layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label"><span class="icon icon-mima"></span></label>
            <div class="layui-input-block">
                <input type="text" name="uname" id="uname" autocomplete="off" lay-verify="required|uname" placeholder="请输入账号" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><span class="icon icon-xiaoren"></span></label>
            <div class="layui-input-block">
                <input type="password" id="pwd" name="pwd" autocomplete="off" lay-verify="required|pass" placeholder="请输入密码"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item login-btn-map">
            <div class="layui-input-block" style="text-align: right">
                <a href="/register" class="layui-btn">注册</a>
                <button type="submit" class="layui-btn" id="submitBtn" lay-submit="" lay-filter="demo1">登录</button>
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
    layui.use(['form'], function () {
        var form = layui.form;
        form.verify({
            uname: function(value, item){ //value：表单的值、item：表单的DOM对象
                if(!new RegExp("^[a-zA-Z0-9_\u4e00-\u9fa5\\s·]+$").test(value)){
                    return '用户名不能有特殊字符';
                }
                if(/(^\_)|(\__)|(\_+$)/.test(value)){
                    return '用户名首尾不能出现下划线\'_\'';
                }
                if(/^\d+\d+\d$/.test(value)){
                    return '用户名不能全为数字';
                }
            }

            //我们既支持上述函数式的方式，也支持下述数组的形式
            //数组的两个值分别代表：[正则匹配、匹配不符时的提示文字]
            ,pass: [
                /^[\S]{6,12}$/
                ,'密码必须6到12位，且不能出现空格'
            ]
        });
        form.on('submit(demo1)', function (data) {
            return true;
        });
    })
</script>
</body>
</html>