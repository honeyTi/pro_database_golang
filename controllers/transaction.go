package controllers

import (
	"database_web_pro/models"
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
	tradTypeMap, err := models.GetTradList(types, trad, timeStart, timeEnd)
	pageEnd := page * limit
	if pageEnd > len(tradTypeMap) {
		pageEnd = len(tradTypeMap)
	}
	if err != nil {
		this.Data["json"] = TotalData{
			Msg:   "暂无内容",
			Code:  1,
			Count: 0,
			Data:  tradTypeMap,
		}
	} else {
		this.Data["json"] = TotalData{
			Msg:   "successful",
			Code:  0,
			Count: len(tradTypeMap),
			Data:  tradTypeMap[(page-1)*limit : pageEnd],
		}
	}
	this.ServeJSON()
}

func (this *TransactionController) GetTradTypeAll() {
	types := this.GetString("types")
	trad := this.GetString("trad")
	timeStart := this.GetString("timeStart")
	timeEnd := this.GetString("timeEnd")
	tradTypeMap, err := models.GetTradList(types, trad, timeStart, timeEnd)
	if err != nil {
		this.Data["json"] = TotalData{
			Msg:   "暂无内容",
			Code:  1,
			Count: 0,
			Data:  tradTypeMap,
		}
	} else {
		this.Data["json"] = TotalData{
			Msg:   "successful",
			Code:  0,
			Count: len(tradTypeMap),
			Data:  tradTypeMap,
		}
	}
	this.ServeJSON()
}