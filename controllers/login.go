package controllers

import (
	"database_web_pro/models"
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context"
)

type LoginController struct {
	beego.Controller
}

func (c *LoginController) Get() {
	isExit := c.Input().Get("exit")
	if isExit == "true" {
		fmt.Println("执行cookie修改")
		c.Ctx.SetCookie("uname", "",-1, "/")
		c.Ctx.SetCookie("pwd", "",-1, "/")
		c.Redirect("/login",302)
	}
	c.TplName = "login.tpl"
}

func (l *LoginController) Post() {
	l.Data["LoginState"] = true
	uname := l.Input().Get("uname")
	pwd := l.Input().Get("pwd")
	userInfo, err := models.UserLogin(uname, pwd)
	if err != nil {
		l.Data["LoginState"] = false
		l.Redirect("/login", 302)
		return
	}

	if userInfo.UserName == uname &&
		userInfo.Pwd == pwd {
		maxAge := 1<<31 - 1
		l.Ctx.SetCookie("uname", uname, maxAge, "/")
		l.Ctx.SetCookie("pwd", pwd, maxAge, "/")
		l.Data["LoginState"] = true
		l.Redirect("/", 302)
		return
	} else {
		l.Data["LoginState"] = false
		l.Redirect("/login", 302)
		return
	}
}
// 判断用户是否登录
func CheckAccount(c *context.Context) bool  {
	ck, err := c.Request.Cookie("uname")
	if err != nil {
		return false
	}
	uname:= ck.Value
	pwd1, err := c.Request.Cookie("pwd")
	if err != nil {
		return false
	}
	pwd := pwd1.Value
	_, err = models.UserLogin(uname, pwd)
	if err == nil {
		return true
	}else {
		return false
	}
}
