package controllers

import "github.com/astaxie/beego"

type GoodsController struct {
	beego.Controller
}

func (this *GoodsController) Get() {
	this.Data["IsSp"] = true
	this.TplName = "goods.tpl"
}
