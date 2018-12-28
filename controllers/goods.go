package controllers

import (
	"database_web_pro/models"
	"github.com/astaxie/beego"
	"strconv"
)

type GoodsController struct {
	beego.Controller
}

type ReJSON struct {
	Msg   string
	Code  int64
	Count int
	Data  []*models.GoodsType
}

type GoodsTypeList struct {
	Msg   string
	Code  int64
	Count int
	Data  []*models.GoodsList
}

func (this *GoodsController) Get() {
	if CheckAccount(this.Ctx) {
		this.Data["UserName"] = this.Ctx.GetCookie("uname")
	} else {
		this.Redirect("/login", 302)
	}
	this.Data["IsSp"] = true
	this.TplName = "goods.tpl"
}

func (this *GoodsController) GetOption() {
	chose1 := this.GetString("chose1")
	chose2 := this.GetString("chose2")
	timeStart := this.GetString("timeStart")
	timeEnd := this.GetString("timeEnd")
	page,_ := strconv.Atoi(this.GetString("page"))
	limit,_ := strconv.Atoi(this.GetString("limit"))
	goodType, err := models.GetAllContent(chose1, chose2, timeStart, timeEnd)
	pageEnd := page*limit
	if pageEnd > len(goodType) {
		pageEnd = len(goodType)
	}
	if err != nil {
		this.Data["json"] = ReJSON{
			Msg:   "暂无内容",
			Code:  1,
			Count: 0,
			Data:  goodType,
		}
	} else {
		this.Data["json"] = ReJSON{
			Msg:   "success",
			Code:  0,
			Count: len(goodType),
			Data:  goodType[(page-1)*limit :  pageEnd],
		}
	}
	this.ServeJSON()
}

func (this *GoodsController) GetCharts() {
	chose1 := this.GetString("chose1")
	chose2 := this.GetString("chose2")
	timeStart := this.GetString("timeStart")
	timeEnd := this.GetString("timeEnd")
	goodType, err := models.GetAllContent(chose1, chose2, timeStart, timeEnd)
	if err != nil {
		this.Data["json"] = ReJSON{
			Msg:   "暂无内容",
			Code:  1,
			Count: 0,
			Data:  goodType,
		}
	} else {
		this.Data["json"] = ReJSON{
			Msg:   "success",
			Code:  0,
			Count: len(goodType),
			Data:  goodType,
		}
	}
	this.ServeJSON()
}

func (this *GoodsController) GetAllChose() {
	goodsList, err := models.GetChose()
	if err != nil {
		this.Data["json"] = GoodsTypeList{
			Msg:   "没有查询到数据",
			Code:  1,
			Count: 0,
			Data:  goodsList,
		}
	} else {
		this.Data["json"] = GoodsTypeList{
			Msg:   "success",
			Code:  0,
			Count: len(goodsList),
			Data:  goodsList,
		}
	}
	this.ServeJSON()
}
