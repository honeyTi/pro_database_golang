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
	Month   time.Time
	TopName string
	TwoName string
	OrAuc   float64
	OrAucZb float64
	OrAcc   float64
	OrAccZb float64
}

// 商品分类清单列表
type GoodsList struct {
	Id      int64
	TopName string
	TwoName string
}

// 地域码表
type CityList struct {
	Id           int64
	ProvinceName string
	ProvinceCode string
	CityName     string
	CityCode     string
	CountyName   string
	CountyCode   string
}

// 地域分析统计信息
type CountyAnalysis struct {
	Id            int64
	DateMonth     time.Time
	ProvinceName  string
	ProvinceCode  string
	CityName      string
	CityCode      string
	CountyName    string
	CountyCode    string
	OrCur         float64
	OrCurZb       float64
	OrCurYoy      float64
	OrAcc         float64
	OrAccZb       float64
	OrAccYoy      float64
	ShopNum       int64
	ShopNumZb     float64
	ShopNumYoy    float64
	KindCur       float64
	KindCurYoy    float64
	KindAcc       float64
	KindAccYoy    float64
	NotKindCur    float64
	NotKindCurYoy float64
	NotKindAcc    float64
	NotKindAccYoy float64
	KindCurZb     float64
	KindAccZb     float64
}
// 汇总表
type DataCollect struct {
	Id            int64
	DataMonth     time.Time
	DataType      string
	Name          string
	OrCur         float64
	OrCurZb       float64
	OrCurYoy      float64
	OrAcc         float64
	OrAccZb       float64
	OrAccYoy      float64
	ShopNum       int64
	ShopNumZb     float64
	ShopNumYoy    float64
	KindCur       float64
	KindCurYoy    float64
	KindAcc       float64
	KindAccYoy    float64
	NotKindCur    float64
	NotKindCurYoy float64
	NotKindAcc    float64
	NotKindAccYoy float64
	KindCurZb     float64
	KindAccZb     float64
}
type TradingType struct {
	Id int64
	Types string
	Trads string
}

func InitDB() {
	orm.RegisterModelWithPrefix("db_",
		new(UserInfo),
		new(GoodsType),
		new(GoodsList),
		new(CityList),
		new(CountyAnalysis),
		new(DataCollect),
		new(TradingType),
	)
}
