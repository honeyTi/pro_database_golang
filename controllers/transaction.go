package controllers

import (
	"github.com/astaxie/beego"
	"strconv"
)

type TransactionController struct {
	beego.Controller
}

func (this *TransactionController) Get() {
	if CheckAccount(this.Ctx) {
		this.Data["UserName"] = this.Ctx.GetCookie("uname")
	} else {
		this.Redirect("/login", 302)
	}
	this.Data["IsJy"] = true
	this.TplName = "transaction.tpl"
}

func (this *TransactionController) GetTradType() {
	types := this.GetString("types")
	trad := this.GetString("trad")
	timeStart := this.GetString("timeStart")
	timeEnd := this.GetString("timeEnd")
	page, _ := strconv.Atoi(this.GetString("page"))
	limit, _ := strconv.Atoi(this.GetString("limit"))
}