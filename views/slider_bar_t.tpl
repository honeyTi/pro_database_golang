{{define "slider"}}
<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
        <ul class="layui-nav layui-nav-tree" lay-filter="test">
            <li class="layui-nav-item"><a href="">指标体系</a></li>
            <li class="layui-nav-item">
                <a class="" href="javascript:;">决策中心</a>
                <dl class="layui-nav-child">
                    <dd><a href="javascript:;">功能一</a></dd>
                    <dd><a href="javascript:;">功能二</a></dd>
                    <dd><a href="javascript:;">功能三</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item">
                <a href="javascript:;">监测中心</a>
                <dl class="layui-nav-child">
                    <dd><a href="javascript:;">数据报表</a></dd>
                    <dd><a href="javascript:;">重要商品</a></dd>
                    <dd><a href="">重点企业</a></dd>
                    <dd><a href="">跨境电商</a></dd>
                    <dd><a href="">数据查询</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item"><a href="">平台共享</a></li>
        </ul>
    </div>
</div>
{{end}}