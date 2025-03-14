package authorized

import (
	"log"
	"time"

	"github.com/golang-jwt/jwt"
)

var JwtKey = []byte("secret_key")

type Claims struct{
	ID int
	jwt.StandardClaims
}

func CreateJwtClaims(id int) *Claims{

	expirationDate := time.Now().Add(24 * time.Hour)

	return &Claims{
		ID: id,
		StandardClaims: jwt.StandardClaims{ExpiresAt: expirationDate.Unix()},
	}
}

func CreateToken(claims *Claims) (string, error){

	token := jwt.NewWithClaims(jwt.SigningMethodHS512, claims)
	tokenstring, err :=	token.SignedString(JwtKey)
	
	if err != nil{
		log.Print(err.Error())
		return "", err
	}

	return tokenstring, nil
}