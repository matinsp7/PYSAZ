package api

import (
	"net/http"
	middleware "PROJDB/backend/midelware"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/ulule/limiter/v3"
	"github.com/ulule/limiter/v3/drivers/store/memory"
	"time"
)

type Server struct{
	Router *gin.Engine
	AddresListen string
}

func NewServer() *Server {
	router := gin.Default()
	//router.LoadHTMLGlob("./frontend/signup/signup.html")

	return &Server{router, "0.0.0.0:8010"}
}

func (s *Server) StartServer() error {

	config := cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		//AllowMethods:     []string{"*"},
		//AllowHeaders:     []string{"*"},
		//ExposeHeaders:    []string{"Content-Length"}, // Optional: Expose specific headers
    	//MaxAge:           12 * time.Hour,            // Optional: Cache preflight requests for 12 hours
    	//AllowCredentials: true,
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
	

	err := s.Router.Run(s.AddresListen)
	return err
}

func ClientApi(r *Server){

	Group := r.Router.Group("/user")
	Group.Use(middleware.AuthoMiddelWare())
	
	Group.POST("/login", login)
	Group.GET("/getAddress",  getAddress)
	Group.POST("/getBaskets", getUserBasketShop)
}

func CompatibilityFinder(r *Server){
	Group := r.Router.Group("/compatiblityFinder")
	Group.POST("/ramMotherBoard", findCompatibiltyRamMotherBoard)
	Group.POST("/GpuPower", findCompatibiltyGpuPower)
	Group.POST("/SSDMotherBoard", findCompatibiltySSDMotherBoard)
	Group.POST("/GpuMotehrBoard", findCompatibiltyGpuMotherboard)
	Group.POST("/CoolerCPU", findCompatibiltyCoolerCPU)
	// Group.POST("/CPUMotherBoard", findCompatibiltyCPUMotherBoard)
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