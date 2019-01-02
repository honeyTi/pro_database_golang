package models

import "github.com/astaxie/beego/orm"
// 获取地域码表api
func GetAllAreas() ([] *CityList, error) {
	o := orm.NewOrm()
	qs := o.QueryTable("db_city_list").Limit(-1)
	cityList := make([]*CityList, 0)
	_, err := qs.All(&cityList)
	if err != nil {
		return nil, err
	} else {
		return cityList, nil
	}
}
