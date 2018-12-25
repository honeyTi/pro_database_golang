package controllers

import (
	"database_web_pro/models"
	"github.com/astaxie/beego"
)

type RegisterController struct {
	beego.Controller
}

func (this *RegisterController) Get() {
	this.TplName = "register.tpl"
}

func (this *RegisterController) Post() {
	uname := this.Input().Get("uname")
	pwd := this.Input().Get("pwd")
	err := models.UserRegister(uname, pwd)
	if err != nil {
		beego.Error(err)
		this.Redirect("/register",302)
	} else {
		this.Redirect("/login",302)
	}
}