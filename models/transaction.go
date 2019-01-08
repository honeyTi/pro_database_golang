package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

func GetTradList(types, trad, timeStart, timeEnd string) ([] *DataCollect, error) {
	timeLayout := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	ts, _ := time.ParseInLocation(timeLayout, timeStart, loc)
	te, _ := time.ParseInLocation(timeLayout, timeEnd, loc)
	o := orm.NewOrm()
	qs := o.QueryTable("db_data_collect").Filter("data_type", types).Filter("name", trad).Filter("data_month__gt", ts).Filter("data_month__lt", te).Limit(-1).OrderBy("data_month")
	dataCollect := make([] *DataCollect, 0)
	_, err := qs.All(&dataCollect)
	if err != nil {
		return nil, err
	} else {
		return dataCollect, nil
	}
}
