package api

import (
	authorized "PROJDB/backend/jwt"
	"PROJDB/backend/sql"
	"io"
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

func getAddress(c *gin.Context){

	ID, _ := c.Get("ID")

	addres, err := sql.GetAddressOfUser(ID)

	if  err != nil && err.Error() != "you have not registered any address!"{

		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, addres)
}

