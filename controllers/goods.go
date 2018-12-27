package controllers

import (
	"database_web_pro/models"
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
	goodsTpye, err := models.GetAllContent()
	if err != nil {
		this.Data["json"] = ReJSON{
			Status: "error",
			Code:   0,
			Result: goodsTpye,
		}
	} else {
		this.Data["json"] = ReJSON{
			Status: "success",
			Code:   1,
			Result: goodsTpye,
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
