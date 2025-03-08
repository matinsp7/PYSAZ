package api

import (
	"net/http"
	middleware "PROJDB/backend/midelware"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/ulule/limiter/v3"
	"github.com/ulule/limiter/v3/drivers/store/memory"
	"time"

	"PROJDB/backend/sql"
	"PROJDB/backend/data"
)

type Server struct{
	Router *gin.Engine
	AddresListen string
}

func NewServer() *Server {
	router := gin.Default()
	//router.LoadHTMLGlob("./frontend/signup/signup.html")

	return &Server{router, "0.0.0.0:8020"}
}

func (s *Server) StartServer() error {

	config := cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
    }

	s.Router.Use(cors.New(config))
	ApplyMiddleware(s)


	ClientApi(s)
	CompatibilityFinder(s)

	s.Router.POST("/signup", signup)

	s.Router.Static("/homepageAsset", "./frontend/homepage/homepageAsset")
	s.Router.GET("/", func(c *gin.Context) {
		s.Router.LoadHTMLGlob("./frontend/homepage/index.html")
        c.HTML(http.StatusOK, "index.html",gin.H{
            "title": "signup Page",
        })
    })


	s.Router.Static("/staticc", "./frontend/signup/staticc")
	s.Router.GET("/signup", func(c *gin.Context) {
		s.Router.LoadHTMLGlob("./frontend/signup/signup.html")
        c.HTML(http.StatusOK, "signup.html",gin.H{
            "title": "signup Page",
        })
    })

	s.Router.Static("/staticcc", "./frontend/login/staticcc")
	s.Router.GET("/login", func(ctx *gin.Context) {
		s.Router.LoadHTMLGlob("./frontend/login/login.html")
		ctx.HTML(http.StatusOK, "login.html", gin.H{"title":"login page"})
	})


	s.Router.Static("/staticccc", "./frontend/clientpage/staticccc")
	s.Router.GET("/client", func(ctx *gin.Context) {
		s.Router.LoadHTMLGlob("./frontend/clientpage/client.html")
		ctx.HTML(http.StatusOK, "client.html", gin.H{"title": "client page"})
	})


	s.Router.Static("/exploreAsset", "./frontend/explore/exploreAsset")
	s.Router.GET("/explore", func(ctx *gin.Context) {
		s.Router.LoadHTMLGlob("./frontend/explore/explore.html")
		ctx.HTML(http.StatusOK, "explore.html", gin.H{"title": "explore page"})
	})

	s.Router.GET("/products", func(c *gin.Context) {
		var prods []data.Product = sql.GetProduct()
		c.JSON(http.StatusOK, prods)
	})

	s.Router.Static("/compatibility", "./frontend/compatible/compatibility")
	s.Router.GET("/compatibility", func(ctx *gin.Context) {
		s.Router.LoadHTMLGlob("./frontend/compatible/compatible.html")
		ctx.HTML(http.StatusOK, "compatible.html", gin.H{"title": "compatibility"})
	})
	

	err := s.Router.Run(s.AddresListen)
	return err
}

func ClientApi(r *Server){

	Group := r.Router.Group("/user")
	Group.Use(middleware.AuthoMiddelWare())
	
	Group.POST("/login", login)
	Group.GET("/getAddress",  getAddress)
	Group.GET("/getDisCodes", getDisCodes)
	Group.GET("/getShoppingCart", getShoppingCart)
	Group.POST("/getBaskets", getUserBasketShop)
	Group.POST("/addAddress", saveAddress)
	Group.GET("/monthlyBounes", monthlyBonus)
}

func CompatibilityFinder(r *Server){
	Group := r.Router.Group("/compatiblityFinder", middleware.IsVip())
	Group.POST("/compatiblity", compatiblity)
}

func ApplyMiddleware(r *Server){
	
	rate := limiter.Rate{
		Period: 1 * time.Second,
		Limit: 20,
	}
	
	store := memory.NewStore()
	mylimiter := limiter.New(store, rate)

	r.Router.Use(middleware.LimitMiddleware(mylimiter))
}