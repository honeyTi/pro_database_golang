package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

//用户信息表
type UserInfo struct {
	Id int64
	UserName string
	Pwd string
	Created time.Time
}

func InitDB() {
	orm.RegisterModelWithPrefix("db_",new(UserInfo))
}