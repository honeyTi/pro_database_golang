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
}
