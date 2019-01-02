package controllers

import (
	"database_web_pro/models"
	"github.com/astaxie/beego"
)

type AreaController struct {
	beego.Controller
}

// 返回city列表结构体
type CityList struct {
	Msg   string
	Code  int64
	Count int
	Data  []*models.CityList
}

func (this *AreaController) Get() {
	if CheckAccount(this.Ctx) {
		this.Data["UserName"] = this.Ctx.GetCookie("uname")
	} else {
		this.Redirect("/login", 302)
	}
	this.Data["IsDy"] = true
	this.TplName = "area.tpl"
}

func (this *AreaController) GetCityList() {
	cityAll, err := models.GetAllAreas()
	if err != nil {
		this.Data["json"] = CityList{
			Msg:   "暂无请求到数据",
			Code:  1,
			Count: 0,
			Data:  cityAll,
		}
	} else {
		this.Data["json"] = CityList{
			Msg:   "成功",
			Code:  0,
			Count: len(cityAll),
			Data:  cityAll,
		}
	}
	this.ServeJSON()
}
