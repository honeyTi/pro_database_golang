package routers

import (
	"database_web_pro/controllers"
	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/login", &controllers.LoginController{})
	beego.Router("/", &controllers.IndexController{})
	beego.Router("/index", &controllers.IndexController{})
	beego.Router("/index/getTotal", &controllers.IndexController{}, "get:GetTotalMap")
	beego.Router("/index/GetCharts", &controllers.IndexController{}, "get:GetCharts")
	beego.Router("/register", &controllers.RegisterController{})
	beego.Router("/goods", &controllers.GoodsController{})
	beego.Router("/goods/getOption", &controllers.GoodsController{}, "get:GetOption")
	beego.Router("/goods/getChose", &controllers.GoodsController{}, "get:GetAllChose")
	beego.Router("/goods/GetCharts", &controllers.GoodsController{}, "get:GetCharts")
	beego.Router("/area", &controllers.AreaController{})
	beego.Router("/area/getCityList",&controllers.AreaController{},"get:GetCityList") // 获取城市三级表
	beego.Router("/area/getTableMap",&controllers.AreaController{}, "get:GetTableMap") // 获取查询内容
	beego.Router("/area/getMapData", &controllers.AreaController{}, "get:GetMapData") // 获取地图数据，柱图数据
	beego.Router("/trading", &controllers.TradingController{})
	beego.Router("/trading/trad", &controllers.TradingController{}, "get:GetTrading")
	beego.Router("/trading/tradDetail", &controllers.TradingController{},"get:GetTradDetail")
	beego.Router("/trading/GetTradMap", &controllers.TradingController{}, "get:GetTradMap")
	beego.Router("/trading/GetTradZb", &controllers.TradingController{}, "get:GetTradZb")
	beego.Router("/transaction", &controllers.TransactionController{})
	beego.Router("/transaction/getTrad", &controllers.TransactionController{}, "get:GetTradType")
	beego.Router("/transaction/getTradAll", &controllers.TransactionController{}, "get:GetTradTypeAll")
}
