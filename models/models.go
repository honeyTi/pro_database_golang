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

// 商品分类总体数据库字段表
type GoodsType struct {
	Id      int64
	Month   time.Time `orm:"type(date)"`
	TopName string
	TwoName string
	OrAuc   float64
	OrAucZb float64
	OrAcc   float64
	OrAccZb float64
}
// 商品分类清单列表
type GoodsList struct {
	Id int64
	TopName string
	TwoName string
}

func InitDB() {
	orm.RegisterModelWithPrefix("db_",
		new(UserInfo),
		new(GoodsType),
		new(GoodsList),
	)
}
