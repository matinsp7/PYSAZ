package api

import (
	"PROJDB/backend/data"
	"PROJDB/backend/jwt"
	"PROJDB/backend/sql"
	"io"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func login (c *gin.Context){

	body := c.Request.Body

	
	value, err := io.ReadAll(body)
	
	if err != nil{
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	user, err := sql.GetUserFromSql(string(value))

	if err != nil{
		c.JSON(http.StatusUnauthorized, gin.H{"message": err.Error()})
		return 
	}

	claims := authorized.CreateJwtClaims(user.ID)
	tokenstring, err := authorized.CreateToken(claims)

	if err != nil{
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": tokenstring, "user": user})
}


// there are problem about empty address

func getAddress(c *gin.Context){

	ID, _ := c.Get("ID")

	addres, err := sql.GetAddressOfUser(ID)

	if  err != nil && err.Error() != "you have not registered any address!"{

		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, addres)
}


func getUserBasketShop(c *gin.Context){

	ID, _ := c.Get("ID")

	basket, err := sql.GetUserBasketShop(ID)

	if err != nil{
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return 
	}

	c.JSON(http.StatusOK, basket)
}

func getInfoBasket(c *gin.Context){

	ID, _ := c.Get("ID")

	basket, err := sql.GetBasketInfo(ID, 1, 1)

	if err != nil{
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return 
	}

	c.JSON(http.StatusOK, basket)
}

func findCompatibiltyRamMotherBoard(c *gin.Context){
	
	var income data.Compatible

	err := c.ShouldBindBodyWithJSON(&income)

	if err != nil{
		log.Print(err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	
	data, err := sql.CompatibleRamWithMotherBoard(income.Src, income.Model, income.Brand, income.Dest)

	if err != nil{
		// log.Print(err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, data)
}


func findCompatibiltyGpuPower(c *gin.Context){

	var income data.Compatible

	err := c.ShouldBindBodyWithJSON(&income)

	if err != nil{
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return 
	}

	data, err := sql.CampatibleGpuWithPower(income.Src, income.Model, income.Brand, income.Dest)

	if err !=  nil{
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, data)
}

func findCompatibiltySSDMotherBoard(c *gin.Context){
	
	var income data.Compatible
	
	err := c.ShouldBindBodyWithJSON(&income)

	if err != nil{
		log.Print(err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	
	data, err := sql.CampatibleSSDWithMotherBoard(income.Src, income.Model, income.Brand, income.Dest)

	if err != nil{
		log.Print(err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return 
	}

	c.JSON(http.StatusOK, data)
}

