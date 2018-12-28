package routers

import (
	"database_web_pro/controllers"
	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/login", &controllers.LoginController{})
	beego.Router("/", &controllers.IndexController{})
	beego.Router("/register", &controllers.RegisterController{})
	beego.Router("/goods", &controllers.GoodsController{})
	beego.Router("/goods/getOption", &controllers.GoodsController{}, "get:GetOption")
	beego.Router("/goods/getChose", &controllers.GoodsController{}, "get:GetAllChose")
	beego.Router("/goods/GetCharts", &controllers.GoodsController{}, "get:GetCharts")
	beego.Router("/area", &controllers.AreaController{})
}
