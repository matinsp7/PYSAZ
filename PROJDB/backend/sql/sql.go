package sql

import (
	"database/sql"
	"log"
	"os"
	"fmt"
	"encoding/json"
)


func init(){

	fileName := "/home/matin/Desktop/paysaz/PROJDB/backend/sql/dns.json"
	dns, err := os.ReadFile(fileName)

	if err != nil{
		log.Fatal(err.Error())
	}

	var data map[string]interface{}
	err = json.Unmarshal(dns, &data)
	 
	if err != nil{
		log.Fatal(err.Error())
	}

	dsn := fmt.Sprintf("%s:%s@tcp(localhost:3306)/%s", data["username"], data["password"], data["database"])
	db = NewDb("mariadb", dsn)

	err = db.Ping()
	if err != nil {
		log.Fatalf("Error connecting to database: %v", err)
	}

}


func NewDb(driverName string, dns string) (*sql.DB) {

	db, err := sql.Open(driverName, dns)

	if err != nil{
		log.Fatal(err.Error())
		return nil
	}

	return db
}
