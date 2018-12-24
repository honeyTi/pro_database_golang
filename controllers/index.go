package controllers

import (
	"github.com/astaxie/beego"
)

type IndexController struct {
	beego.Controller
}

func (c *IndexController) Get() {
	if CheckAccount(c.Ctx){
		c.Data["UserName"] = c.Ctx.GetCookie("uname")
	} else {
		c.Redirect("/login",302)
	}
	c.TplName = "index.tpl"
}
