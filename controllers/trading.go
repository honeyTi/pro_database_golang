package controllers

import (
	"database_web_pro/models"
	"github.com/astaxie/beego"
	"strconv"
)

type TradingController struct {
	beego.Controller
}

type TradingMap struct {
	Msg   string
	Code  int
	Count int
	Data  []*models.TradingType
}
type ZbTrad struct {
	Msg string
	Code int
	Count int
	Data []*models.TradAnalysis
}

func (this *TradingController) Get() {
	if CheckAccount(this.Ctx) {
		this.Data["UserName"] = this.Ctx.GetCookie("uname")
	} else {
		this.Redirect("/login", 302)
	}
	this.Data["IsPt"] = true
	this.TplName = "trading.tpl"
}

func (this *TradingController) GetTrading()  {
	trads, err := models.AllTrads()
	if err != nil {
		this.Data["json"] = TradingMap{
			Msg:"fail",
			Code:1,
			Count:0,
			Data:trads,
		}
	} else {
		this.Data["json"] = TradingMap{
			Msg:"successful",
			Code:0,
			Count:len(trads),
			Data:trads,
		}
	}
	this.ServeJSON()
}
func (this *TradingController) GetTradDetail() {
	types := this.GetString("types")
	list := this.GetString("list")
	timeStart := this.GetString("timeStart")
	timeEnd := this.GetString("timeEnd")
	page, _ := strconv.Atoi(this.GetString("page"))
	limit, _ := strconv.Atoi(this.GetString("limit"))
	dataTotal, err := models.GetTradData(types, list, timeStart, timeEnd)
	pageEnd := page * limit
	if pageEnd > len(dataTotal) {
		pageEnd = len(dataTotal)
	}
	if err != nil {
		this.Data["json"] = TotalData{
			Msg:   "暂无内容",
			Code:  1,
			Count: 0,
			Data:  dataTotal,
		}
	} else {
		this.Data["json"] = TotalData{
			Msg:   "成功",
			Code:  0,
			Count: len(dataTotal),
			Data:  dataTotal[(page-1)*limit : pageEnd],
		}
	}
	this.ServeJSON()
}
func (this *TradingController) GetTradMap() {
	types := this.GetString("types")
	list := this.GetString("list")
	timeStart := this.GetString("timeStart")
	timeEnd := this.GetString("timeEnd")
	dataTotal, err := models.GetTradData(types, list, timeStart, timeEnd)
	if err != nil {
		this.Data["json"] = TotalData{
			Msg:   "暂无内容",
			Code:  1,
			Count: 0,
			Data:  dataTotal,
		}
	} else {
		this.Data["json"] = TotalData{
			Msg:   "成功",
			Code:  0,
			Count: len(dataTotal),
			Data:  dataTotal,
		}
	}
	this.ServeJSON()
}

func (this *TradingController) GetTradZb() {
	timeStart := this.GetString("timeStart")
	timeEnd := this.GetString("timeEnd")
	types := this.GetString("types")
	tradZb, err := models.GetTradZbMap(types, timeStart, timeEnd)
	if err != nil {
		this.Data["json"] = ZbTrad{
			Msg:   "暂无内容",
			Code:  1,
			Count: 0,
			Data:  tradZb,
		}
	} else {
		this.Data["json"] = ZbTrad{
			Msg:   "成功",
			Code:  0,
			Count: len(tradZb),
			Data:  tradZb,
		}
	}
	this.ServeJSON()
}