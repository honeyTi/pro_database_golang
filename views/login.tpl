<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="/static/assets/layui/css/layui.css">
    <link rel="stylesheet" href="/static/css/main.css">
    <link rel="stylesheet" href="/static/font/iconfont.css">
    <link rel="stylesheet" href="/static/css/jquery.fallingsnow.css">
    <title>系统-登录</title>
</head>
<body>

    <div class="login">
        <div id="snow"></div>
        <form action="/login" method="get" class="login-map layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label"><span class="icon icon-mima"></span></label>
                <div class="layui-input-block">
                    <input type="text" name="userName" lay-verify="title" placeholder="请输入账号" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label"><span class="icon icon-xiaoren"></span></label>
                <div class="layui-input-block">
                    <input type="text" name="pwd" lay-verify="required" placeholder="请输入密码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item login-btn-map">
                <div class="layui-input-block" style="text-align: right">
                    <button type="reset" class="layui-btn">注册</button>
                    <button type="submit" class="layui-btn">登录</button>
                </div>
            </div>
        </form>
    </div>
    <script type="text/javascript" src="/static/js/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="/static/assets/layui/layui.js"></script>
    <script type="text/javascript" src="/static/js/jquery.fallingsnow.min.js"></script>
    <script type="text/javascript">
        +function () {
            $("#snow").fallingSnow();
        }()
    </script>
</body>
</html>