{{template "components/header_t.tpl"}}
<title>电商分析平台-注册</title>
</head>
<body>
<div class="login register-map-1">
    <div class="register-map">
        <form class="layui-form register-form">
            <div class="layui-form-item">
                <label class="layui-form-label">用户名：</label>
                <div class="layui-input-block">
                    <input type="text" name="uname" id="uname" lay-verify="required|uname" placeholder="请输入用户名"
                           class="layui-input">
                    <p>（注意用户名不能包含特殊字符、以及全是数字）</p>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">密码：</label>
                <div class="layui-input-block">
                    <input type="password" id="pwd" name="pwd" lay-verify="required|pass" placeholder="请输入密码" autocomplete="off"
                           class="layui-input">
                    <p>（密码为6~12非空字符组合）</p>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">密码确认：</label>
                <div class="layui-input-block">
                    <input id="rpwd" type="password" lay-verify="required|repass" placeholder="请再次确认密码" autocomplete="off"
                           class="layui-input">
                </div>
            </div>
            <div class="layui-form-item" style="margin-top: 30px;text-align: center">
                    <button class="layui-btn" id="submit_register" type="button" lay-submit="" lay-filter="demo1">立即提交</button>
            </div>
        </form>
    </div>
    <script>
        +function() {
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
                    },

                    //我们既支持上述函数式的方式，也支持下述数组的形式
                    //数组的两个值分别代表：[正则匹配、匹配不符时的提示文字]
                    pass: [
                        /^[\S]{6,12}$/
                        ,'密码必须6到12位，且不能出现空格'
                    ],
                    repass: function (value, item) {
                        if (value !== $('#pwd').val()) {
                            return '两次密码输入不同，请重新输入'
                        }
                    }
                });
                form.on('submit(demo1)', function (data) {
                    $.ajax({
                        type: "get",
                        url: "/register/reUser",
                        data: {
                            pwd: $('#pwd').val(),
                            uname: $('#uname').val()
                        },
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        success: function (result) {
                            console.log(result)
                            if (result.Code === 0) {
                                layer.msg('账号注册成功，2秒后跳转登录页面', {
                                    offset: 't',
                                    icon: 2,
                                    skin: 'layer-ext-moon'
                                });
                                setTimeout(function () {
                                    window.location.href = window.location.href.split('/register')[0] + '/login'
                                }, 2000)
                            } else {
                                layer.msg('账号已被注册,请重新注册', {
                                    offset: 't',
                                    icon: 2,
                                    skin: 'layer-ext-moon'
                                });
                            }
                        },
                        error: function (err) {
                            console.log(err)
                        }
                    });
                });
            })
        }()
    </script>
</div>
</body>
</html>