package controllers

import (
	"database_web_pro/models"
	"github.com/astaxie/beego"
)

type RegisterController struct {
	beego.Controller
}

type RegisterCode struct {
	Msg  string
	Code int
}

func (this *RegisterController) Get() {
	this.TplName = "register.tpl"
}

func (this *RegisterController) Post() {
	uname := this.Input().Get("uname")
	pwd := this.Input().Get("pwd")
	err := models.UserRegister(uname, pwd)
	if err != nil {
		this.Data["json"] = RegisterCode{
			Msg: "注册成功",
			Code: 0,
		}
	} else {
		this.Data["json"] = RegisterCode{
			Msg: "注册失败",
			Code: 1,
		}
	}
	this.ServeJSON()
}
