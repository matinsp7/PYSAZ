package api

import (
	"PROJDB/backend/data"
	"PROJDB/backend/jwt"
	"PROJDB/backend/sql"
	"log"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func signup (c *gin.Context){
	var client data.Client
	if err := c.ShouldBindBodyWithJSON(&client); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

	client.RefferalCode = string(client.PhoneNumber[2:]) + string(client.FirstName[0]) + string(client.LastName[0])
	client.WalletBalance = 0
	
	err := sql.InsertNewUser(&client)
	if err != nil {
        if strings.Contains(err.Error(), "Duplicate") {
            c.JSON(http.StatusConflict, gin.H{"error": "Phone number already exists."})
            return
        }
		log.Print(err.Error())
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user."})

        //c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user."})
        return
    }

	c.JSON(http.StatusOK, "")
}

func login (c *gin.Context){

	var client data.Client

	err := c.ShouldBindBodyWithJSON(&client)
	
	if err != nil{
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	user, err := sql.GetUserFromSql(client.PhoneNumber, client.Password)


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

func findCompatibiltyGpuMotherboard(c *gin.Context){
	
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

func findCompatibiltyCoolerCPU(c *gin.Context){

	var income data.Compatible
	
	err := c.ShouldBindBodyWithJSON(&income)

	if err != nil{
		log.Print(err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	
	data, err := sql.CampatibleCoolerWithCPU(income.Src, income.Model, income.Brand, income.Dest)

	if err != nil{
		log.Print(err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return 
	}

	c.JSON(http.StatusOK, data)
}


// func findCompatibiltyCPUMotherBoard(c *gin.Context){

// 	var income data.Compatible
	
// 	err := c.ShouldBindBodyWithJSON(&income)

// 	if err != nil{
// 		log.Print(err.Error())
// 		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
// 		return
// 	}
	
// 	data, err := sql.CampatibleCPUWithMotherBoard(income.Src, income.Model, income.Brand, income.Dest)

// 	if err != nil{
// 		log.Print(err.Error())
// 		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
// 		return 
// 	}

// 	c.JSON(http.StatusOK, data)
// }
