package models

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

func UserLogin(uname, pwd string) (*UserInfo, error) {
	o := orm.NewOrm()
	userInfo := new(UserInfo)
	qs := o.QueryTable("db_user_info")
	err := qs.Filter("user_name",uname).One(userInfo)
	if err != nil {
		beego.Error(err)
		return nil, err
	}
	return userInfo, err
}