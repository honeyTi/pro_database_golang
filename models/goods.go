package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

func GetAllContent(chose1, chose2, timeStart, timeEnd string) ([]*GoodsType, error) {
	timeLayout := "2006-01-02 15:04:05"
	loc, _ := time.LoadLocation("Local")
	ts, _ := time.ParseInLocation(timeLayout, timeStart, loc)
	te, _ := time.ParseInLocation(timeLayout, timeEnd, loc)
	o := orm.NewOrm()
	qs:= o.QueryTable("db_goods_type").Filter("top_name", chose1).Filter("two_name", chose2).Filter("month__gt",ts).Filter("month__lt",te)
	goodsAll := make([]*GoodsType, 0)
	_, err := qs.All(&goodsAll)
	if err != nil {
		return nil, err
	} else {
		return goodsAll, nil
	}
}
func GetChose() ([]*GoodsList, error) {
	o := orm.NewOrm()
	qs := o.QueryTable("db_goods_list")
	goodsList := make([] *GoodsList, 0)
	_, err := qs.All(&goodsList)
	if err != nil {
		return nil, err
	} else {
		return goodsList, nil
	}
}