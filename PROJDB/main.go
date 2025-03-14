package main

import (
	"PROJDB/backend/api"
	"log"
)

func main(){
	router := api.NewServer()
	log.Fatal(router.StartServer())
}