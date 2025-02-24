package api

import (
	middleware "PROJDB/backend/midelware"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

type Server struct{
	Router *gin.Engine
	AddresListen string
}

func NewServer() *Server {

	return &Server{gin.Default(), ":8080"}
}

func (s *Server) StartServer() error {

	config := cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
    }

	s.Router.Use(cors.New(config))
	ClientApi(s)
	CompatibilityFinder(s)

	

	err := s.Router.Run(s.AddresListen)
	return err
}

func ClientApi(r *Server){
	Group := r.Router.Group("/user")
	Group.Use(middleware.AuthoMiddelWare())
	
	Group.POST("/login", login)
	Group.GET("/getAddress",  getAddress)
	Group.POST("/basketShop", getUserBasketShop)
	Group.POST("/getBasketInfo", getInfoBasket)
}

func CompatibilityFinder(r *Server){
	Group := r.Router.Group("/compatiblityFinder")
	Group.POST("/ramMotherBoard", findCompatibiltyRamMotherBoard)
}