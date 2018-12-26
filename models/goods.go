package models

import "github.com/astaxie/beego/orm"

func GetAllContent() ([]*GoodsType, error) {
	o := orm.NewOrm()
	qs:= o.QueryTable("db_goods_type").Limit(-1)
	goodsAll := make([]*GoodsType, 0)
	_, err := qs.All(&goodsAll)
	if err != nil {
		return nil, err
	} else {
		return goodsAll, nil
	}
}