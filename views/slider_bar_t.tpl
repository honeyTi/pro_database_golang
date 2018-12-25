{{define "slider"}}
<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
        <ul class="layui-nav layui-nav-tree" lay-filter="test">
            <li class="layui-nav-item"><a href="">总体概览</a></li>
            <li class="layui-nav-item"><a href="">地域分析</a></li>
            <li class="layui-nav-item"><a href="">商品分析</a></li>
            <li class="layui-nav-item"><a href="">交易方式分析</a></li>
            <li class="layui-nav-item"><a href="">交易平台分析</a></li>
            <li class="layui-nav-item"><a href="">多维数据查询</a></li>
        </ul>
    </div>
</div>
{{end}}