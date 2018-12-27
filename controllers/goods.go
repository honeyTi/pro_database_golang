package controllers

import (
	"database_web_pro/models"
	"fmt"
	"github.com/astaxie/beego"
)

type GoodsController struct {
	beego.Controller
}

type ReJSON struct {
	Status string
	Code   int64
	Result []*models.GoodsType
}

type GoodsTypeList struct {
	Status string
	Code   int64
	Result []*models.GoodsList
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
	//fmt.Println(chose2, chose1)
	//timeLayout := "2006-01-02 15:04:05"
	//loc, _ := time.LoadLocation("Local")
	//theTime, _ := time.ParseInLocation(timeLayout, timeStart, loc)
	//fmt.Println(theTime)
	//fmt.Println(timeEnd)
	goodType, err := models.GetAllContent(chose1,chose2,timeStart,timeEnd)
	fmt.Println(goodType)
	if err != nil {
		this.Data["json"] = ReJSON{
			Status: "error",
			Code:   0,
			Result: goodType,
		}
	} else {
		this.Data["json"] = ReJSON{
			Status: "success",
			Code:   1,
			Result: goodType,
		}
	}
	this.ServeJSON()
}

func (this *GoodsController) GetAllChose() {
	goodsList, err := models.GetChose()
	if err != nil {
		this.Data["json"] = GoodsTypeList{
			Status: "error",
			Code:   0,
			Result: goodsList,
		}
	} else {
		this.Data["json"] = GoodsTypeList{
			Status: "success",
			Code:   1,
			Result: goodsList,
		}
	}
	this.ServeJSON()
}
