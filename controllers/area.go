package controllers

import "github.com/astaxie/beego"

type AreaController struct {
	beego.Controller
}

func (this *AreaController) Get() {
	if CheckAccount(this.Ctx) {
		this.Data["UserName"] = this.Ctx.GetCookie("uname")
	} else {
		this.Redirect("/login", 302)
	}
	this.Data["IsDy"] = true
	this.TplName = "area.tpl"
}