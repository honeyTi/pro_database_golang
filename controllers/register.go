package controllers

import "github.com/astaxie/beego"

type RegisterController struct {
	beego.Controller
}

func (this *RegisterController) Get() {
	this.TplName = "register.tpl"
}