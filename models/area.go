package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

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

// 地域删选内容
func GetTableMap(prov, city, county, timeStart, timeEnd string) ([] *CountyAnalysis, error) {
	timeLayout := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	ts, _ := time.ParseInLocation(timeLayout, timeStart, loc)
	te, _ := time.ParseInLocation(timeLayout, timeEnd, loc)
	o := orm.NewOrm()
	qs := o.QueryTable("db_county_analysis").Filter("province_name", prov).Filter("city_name", city).Filter("county_name", county).Filter("date_month__gt", ts).Filter("date_month__lt", te).OrderBy("-date_month")
	countyAnalysis := make([] *CountyAnalysis, 0)
	_, err := qs.All(&countyAnalysis)
	if err != nil {
		return nil, err
	} else {
		return countyAnalysis, nil
	}
}

func GetMapData(prov, timeEnd string) ([] *DataCollect, error) {
	timeLayout := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	te, _ := time.ParseInLocation(timeLayout, timeEnd, loc)
	o := orm.NewOrm()
	qs := o.QueryTable("db_data_collect").Filter("data_type", prov).Filter("data_month__lt", te).Limit(-1).OrderBy("data_month")
	countyAnalysis := make([] *DataCollect, 0)
	_, err := qs.All(&countyAnalysis)
	if err != nil {
		return nil, err
	} else {
		return countyAnalysis, nil
	}
}
