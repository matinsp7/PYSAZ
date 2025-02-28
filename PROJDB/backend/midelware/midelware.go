package middleware

import (
	authorized "PROJDB/backend/jwt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/ulule/limiter/v3"
)

func AuthoMiddelWare() gin.HandlerFunc{
	return func(c *gin.Context) {

		if c.Request.URL.Path == "/user/login"{
			c.Next()
			return
		}

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


func LimitMiddleware(limit *limiter.Limiter) gin.HandlerFunc{

	return func(ctx *gin.Context) {

		clinetIP := ctx.ClientIP()

		context, err := limit.Get(ctx, clinetIP)

		if err != nil{
			ctx.AbortWithStatusJSON(500, gin.H{"error": "server error"})
		}

		if context.Reached{
			ctx.AbortWithStatusJSON(429, gin.H{
				"error": "too many request. please try again later",
				"remaining": context.Remaining,
			})
		}

		ctx.Next()
	}

}

