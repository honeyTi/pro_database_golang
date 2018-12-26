package controllers

import (
	"database_web_pro/models"
	"github.com/astaxie/beego"
)

type GoodsController struct {
	beego.Controller
}

func (this *GoodsController) Get() {
	if CheckAccount(this.Ctx) {
		this.Data["UserName"] = this.Ctx.GetCookie("uname")
	} else {
		this.Redirect("/login", 302)
	}
	this.Data["IsSp"] = true
	this.TplName = "goods.tpl"
}

func (this *GoodsController) GetOption() {
	goodsTpye, err := models.GetAllContent()
	if err != nil {
		this.Data["json"] = `{"status": "err"}`
	} else {
		this.Data["json"] = goodsTpye
	}
	this.ServeJSON()
}
