package sql

import (
	"database/sql"
	"log"
)

func NewDb(dns string) (*sql.DB) {

	db, err := sql.Open("mysql", dns)

	if err != nil{
		log.Fatal(err.Error())
		return nil
	}

	return db
}
