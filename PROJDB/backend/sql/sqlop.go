package sql

import (
	"PROJDB/backend/data"
	"database/sql"
	"encoding/json"
	"errors"
	"log"
	"os"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB


func init(){

	fileName := "/home/arya/Desktop/paysaz/PROJDB/backend/sql/dns.json"
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
	db = NewDb(dsn)

	err = db.Ping()
	if err != nil {
		log.Fatalf("Error connecting to database: %v", err)
	}

}


func GetUserFromSql(PhoneNumber string) (*data.Client,error) {


	row := db.QueryRow("SELECT * FROM CLIENT WHERE Phone_number = ?", PhoneNumber)

	var user data.Client

	err := row.Scan(&user.FirstName, &user.LastName, &user.ID, &user.PhoneNumber, &user.WalletBalance,
			 	    &user.RefferalCode, &user.TimeStamp)
	
	if err != nil{

		if err == sql.ErrNoRows{

			return nil, errors.New("phonenumber is inccorect!")
		
		} else {return nil, err} 
	} 

	return &user, nil
}


// ==============================                 WARNING                ===========================================
//------------------------------- be careful beacuse if a user have'not adrress it's not error!!--------------------

func GetAddressOfUser(id any) (map[int]string, error){

	row, err := db.Query("SELECT * FROM ADDRESS WHERE ID = ?", id)

	if err != nil{

		if err == sql.ErrNoRows{

			return nil, errors.New("you have not registered any address!")
		
		} else {return nil, err} 
	} 

	var addres = make(map[int]string)
	var counter int = 1

	for row.Next(){
		var id int
		var province, remiander string

		row.Scan(&id, &province, &remiander)
		addres[counter] = province + "," + remiander
		counter++
	}

	return addres, nil
}