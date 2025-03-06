package api

import (
	"PROJDB/backend/data"
	"PROJDB/backend/jwt"
	"PROJDB/backend/sql"
	"fmt"
	"log"
	"net/http"
	"strings"
	"github.com/gin-gonic/gin"
	mapset "github.com/deckarep/golang-set/v2"	
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
		log.Print(err.Error())
		c.JSON(http.StatusUnauthorized, gin.H{"message": err.Error()})
		return
	}

	claims := authorized.CreateJwtClaims(user.ID)
	tokenstring, err := authorized.CreateToken(claims)

	if err != nil{
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	VIP, err := sql.IsVIP(user.ID)

	if err != nil {
		log.Print(err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": tokenstring, "user": user, "isVIP": VIP})
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


func compatiblity(c *gin.Context){

	var income map[int]data.Product

	err := c.ShouldBindBodyWithJSON(&income)

	if err != nil{
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return 
	}

	var functionMap = map[string]data.HandlerFunc{
		"FindCompatibleWithMotherBoard": sql.FindCompatibleWithMotherBoard,
		"FindCompatibleWithSSD": sql.FindCompatibleWithSSD, 
		"FindCompatibleWithRAM": sql.FindCompatibleWithRAM,
		"FindCompatibleWithGPU": sql.FindCompatibleWithGPU,
		"FindCompatibleWithPower": sql.FindCompatibleWithPower,
		"FindCompatibleWithCooler": sql.FindCompatibleWithCooler,
	}

	var result = make(map[string][]data.Compatible, 0)

	for _, product := range income{
		
		functionName := fmt.Sprintf("FindCompatibleWith%s", product.Category)

		if fn, exists := functionMap[functionName]; exists {
		
			res, err := fn(product)
	
			if err != nil{
				log.Print(err)
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return 
			}

			result[product.Category] = res
			
		} else {
				fmt.Println("Function not found")
		}
	} 
			
		common := getCommon(result)
	
	c.JSON(http.StatusOK, common)
}

//check if len == 1

func getCommon(common map[string][]data.Compatible)map[string]mapset.Set[data.Compatible]{

	intersect := mapset.NewSet[data.Compatible]()
	newCommon := make(map[string]mapset.Set[data.Compatible])
	mustDeleteExcept := make(map[string]mapset.Set[data.Compatible])

	firstproduct := ""

	if len(common) > 1{

		for key, list := range common{

			firstproduct = key

			for _, data := range list{

				intersect.Add(data)
			}

			break
		}

		for key, list := range common{

			if key == firstproduct{continue}

			for _, data := range list{

				if has := intersect.Contains(data); has{

					if mustDeleteExcept[data.Category] == nil{
						
						mustDeleteExcept[data.Category] = mapset.NewSet(data)
					
					} else{
						
						mustDeleteExcept[data.Category].Add(data)
					}

				} else{intersect.Add(data)}

			}
		} 

		for _, list := range common{

			for _, data := range list{

				if shouldRemoveExcept, has := mustDeleteExcept[data.Category]; has{
					
					if isIn := shouldRemoveExcept.Contains(data); isIn{

						if newCommon[data.Category] == nil{

							newCommon[data.Category] = mapset.NewSet(data)
						
						} else {newCommon[data.Category].Add(data)}
					} 
				
				} else {

					if newCommon[data.Category] == nil{

						newCommon[data.Category] = mapset.NewSet(data)
						
					} else {newCommon[data.Category].Add(data)}
				}
			}
		}

		return newCommon
	}
	
	return nil
}