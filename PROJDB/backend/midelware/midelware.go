package middleware

import (
	authorized "PROJDB/backend/jwt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
)

func AuthoMiddelWare() gin.HandlerFunc{
	return func(c *gin.Context) {

		tokeString := c.GetHeader("Authorization")

		if tokeString == ""{
			
			c.JSON(http.StatusBadRequest, gin.H{"error": "Authorization header required"})
			c.Abort()
			return 
		}

		claims := &authorized.Claims{}
		token, err := jwt.ParseWithClaims(tokeString, claims, func(t *jwt.Token) (interface{}, error) {
			return authorized.JwtKey, nil
		})

		if err != nil || !token.Valid{
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token isn't correct"})
			c.Abort()
			return 
		}

		c.Set("ID", claims.ID)
		c.Next()
	}
}