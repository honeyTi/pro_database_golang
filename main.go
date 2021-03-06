package main

import (
	"database_web_pro/models"
	_ "database_web_pro/routers"
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/plugins/cors"
	_ "github.com/go-sql-driver/mysql"
)

func init() {
	models.InitDB()

	orm.RegisterDriver("mysql", orm.DRMySQL)

	database_url := beego.AppConfig.String("databaseUser") + ":" + beego.AppConfig.String("databasePass") +
		"@tcp(" + beego.AppConfig.String("databaseUrls") + ":" + beego.AppConfig.String("databasePort") +
		")/" + beego.AppConfig.String("databaseDB") + "?charset=utf8&loc=Local"

	fmt.Println(database_url)

	orm.RegisterDataBase("default", beego.AppConfig.String("databaseType"), database_url, 50)
}

func main() {
	// orm操作数据库开启调试----后期可注释掉此条代码
	// orm.Debug = true
	// 自动建表---如果表存在就跳过
	orm.RunSyncdb("default", false, true)
	beego.BConfig.WebConfig.Session.SessionOn = true
	beego.InsertFilter("*", beego.BeforeRouter, cors.Allow(&cors.Options{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"PUT", "PATCH", "POST", "GET"},
		AllowHeaders:     []string{"Origin"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,}))
	beego.Run()
}
