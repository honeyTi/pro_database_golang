<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
        <ul class="layui-nav layui-nav-tree" lay-filter="test">
            <li {{if .IsSummarize}}class="layui-nav-item layui-nav-item-active" {{else}}class="layui-nav-item"{{end}}>
                <a href="/index"><span class="icon icon-gaishu"></span>总体概览</a>
            </li>
            <li {{if .IsDy}}class="layui-nav-item layui-nav-item-active" {{else}}class="layui-nav-item"{{end}}>
                <a href="/area"><span class="icon icon-diyufenbu"></span>地域分析</a>
            </li>
            <li {{if .IsSp}}class="layui-nav-item layui-nav-item-active" {{else}}class="layui-nav-item"{{end}}>
                <a href="/goods"><span class="icon icon-shangpin"></span>商品分析</a>
            </li>
            <li {{if .IsJy}}class="layui-nav-item layui-nav-item-active" {{else}}class="layui-nav-item"{{end}}>
                <a href="/transaction"><span class="icon icon-jiaoyi"></span>交易方式分析</a>
            </li>
            <li {{if .IsPt}}class="layui-nav-item layui-nav-item-active" {{else}}class="layui-nav-item"{{end}}>
                <a href="/trading"><span class="icon icon-pingtai"></span>交易平台分析</a>
            </li>
            {{/*<li {{if .IsDw}}class="layui-nav-item layui-nav-item-active" {{else}}class="layui-nav-item"{{end}}>*/}}
                {{/*<a href=""><span class="icon icon-duowei"></span>多维数据查询</a>*/}}
            {{/*</li>*/}}
        </ul>
    </div>
</div>