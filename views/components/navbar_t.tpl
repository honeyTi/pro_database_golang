<div class="layui-header">
    <div class="layui-logo" style="text-align: left;padding-left: 10px;font-size: 18px">
        <a href="/index" style="color: #009688;">
            <img src="/static/img/logo.png" alt="logo" height="50%" >
            &nbsp;电商大数据
        </a>
    </div>
    <ul class="layui-nav layui-layout-right">
        <li class="layui-nav-item layui-nav-item-1">
            <a href="">
                <img src="http://t.cn/RCzsdCq" class="layui-nav-img">
                {{.UserName}}
            </a>
            <dl class="layui-nav-child">
                <dd><a href="/userInfo">基本资料</a></dd>
                <dd><a href="">安全设置</a></dd>
            </dl>
        </li>
        <li class="layui-nav-item"><a href="/login?exit=true">退出登录</a></li>
    </ul>
</div>