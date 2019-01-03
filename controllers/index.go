package controllers

import (
	"database_web_pro/models"
	"fmt"
	"github.com/astaxie/beego"
	"strconv"
)

type IndexController struct {
	beego.Controller
}

type TotalData struct {
	Msg   string
	Code  int
	Count int
	Data  []*models.DataCollect
}

func (c *IndexController) Get() {
	if CheckAccount(c.Ctx) {
		c.Data["UserName"] = c.Ctx.GetCookie("uname")
	} else {
		c.Redirect("/login", 302)
	}
	c.Data["IsSummarize"] = true
	c.TplName = "index.tpl"
}

func (this *IndexController) GetTotalMap() {
	types := this.GetString("types")
	timeStart := this.GetString("timeStart")
	timeEnd := this.GetString("timeEnd")
	dataTotal, err := models.GetTotalData(types, timeStart, timeEnd)
	page, _ := strconv.Atoi(this.GetString("page"))
	limit, _ := strconv.Atoi(this.GetString("limit"))
	pageEnd := page * limit
	if pageEnd > len(dataTotal) {
		pageEnd = len(dataTotal)
	}
	fmt.Println(timeEnd, timeStart, types)
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

func (this *IndexController) GetCharts() {
	types := this.GetString("types")
	timeStart := this.GetString("timeStart")
	timeEnd := this.GetString("timeEnd")
	dataTotal, err := models.GetTotalData(types, timeStart, timeEnd)
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
