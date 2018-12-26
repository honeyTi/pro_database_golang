package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

//用户信息表
type UserInfo struct {
	Id       int64
	UserName string
	Pwd      string
	Created  time.Time
}

// 商品分类分析页面
type GoodsType struct {
	Id      int64
	Month   string
	TopName string
	TwoName string
	OrAuc   float64
	OrAucZb float64
	OrAcc   float64
	OrAccZb float64
}

func InitDB() {
	orm.RegisterModelWithPrefix("db_",
		new(UserInfo),
		new(GoodsType),
	)
}
