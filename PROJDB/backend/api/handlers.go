package api

import (
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
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return 
	}

	c.JSON(http.StatusOK, user)
}