package models

import (
	"errors"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"time"
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
// 用户注册
func UserRegister(uname, pwd string) error {
	o := orm.NewOrm()
	userInfo := &UserInfo{
		UserName:uname,
		Pwd:pwd,
		Created:time.Now(),
	}
	qs := o.QueryTable("db_user_info")
	userMap := new(UserInfo)
	err := qs.Filter("user_name",uname).One(userMap)
	if err != nil {
		_, _ = o.Insert(userInfo)
		return errors.New("注册成功")
	} else {
		return nil
	}
}