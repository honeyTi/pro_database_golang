package controllers

import (
	"database_web_pro/models"
	"github.com/astaxie/beego"
)

type TradingController struct {
	beego.Controller
}

type TradingMap struct {
	Msg   string
	Code  int
	Count int
	Data  []*models.DataCollect
}

func (this *TradingController) Get() {
	if CheckAccount(this.Ctx) {
		this.Data["UserName"] = this.Ctx.GetCookie("uname")
	} else {
		this.Redirect("/login", 302)
	}
	this.Data["IsPt"] = true
	this.TplName = "trading.tpl"
}

func (this *TradingController) GetTrading()  {

}