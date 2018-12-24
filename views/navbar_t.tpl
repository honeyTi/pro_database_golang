{{define "navbar"}}
<div class="layui-header">
    <div class="layui-logo" style="text-align: left;padding-left: 10px;font-size: 18px"><img src="/static/img/logo.png" alt="logo" height="50%" >&nbsp;电商大数据</div>
    <ul class="layui-nav layui-layout-right">
        <li class="layui-nav-item">
            <a href="">
                <img src="http://t.cn/RCzsdCq" class="layui-nav-img">
                {{.UserName}}
            </a>
            <dl class="layui-nav-child">
                <dd><a href="">基本资料</a></dd>
                <dd><a href="">安全设置</a></dd>
            </dl>
        </li>
        <li class="layui-nav-item"><a href="/login?exit=true">退出登录</a></li>
    </ul>
</div>
{{end}}