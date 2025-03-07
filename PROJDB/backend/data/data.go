package data

import ()

type Client struct {
	FirstName     string `json:"FirstName,omitempty"`
	LastName      string `json:"LastName,omitempty"`
	ID            int    `json:"ID,omitempty"`
	PhoneNumber   string `json:"PhoneNumber"`
	WalletBalance int    `json:"WalletBalance,omitempty"`
	RefferalCode  string `json:"RefferalCode,omitempty"`
	TimeStamp     string `json:"TimeStamp,omitempty"`
	Password	  string `json:"Password,omitempty"`
}

type Compatible struct{

	Brand string	`json:"brand"`	
	Model string	`json:"model"`
	Category string `json:"category"`
}

type DisCode struct {
	Code int				`json:"Code"`
	Amount int				`json:"Amount"`
	Code_limit any			`json:"Code_limit"`
	Usage_count int			`json:"Usage_count"`
	Expiration_date string	`json:"Expiration_date"`
}

type ShoppingCart struct {
	ID int			`json:"id"`
    Number int		`json:"number"`
    Status string	`json:"status"`
}

type Address struct {

	Province string		`json:"province"`
	Remainder string	`json:"remainder"`

}

type Basket struct{

	Number int					`json:"number"`
	TotalPrice int				`json:"price"`
	Time string					`json:"time"`
	Products []BasketInfo	`json:"products"`
}

type BasketInfo struct{

	Brand string		`json:"brand"`
	Model string		`json:"model"`
	Quantity int 	`json:"number"`
	Price int 		`json:"price"`
}



type Product struct {
	ID           int     `json:"id"`
    Category     string  `json:"category"`
    Image        []byte  `json:"image"`
    CurrentPrice int     `json:"current_price"`
    StockCount   int     `json:"stock_count"`
    Brand        string  `json:"brand"`
    Model        string  `json:"model"`
	Image_address string `json:"Image_address"`
}

type HandlerFunc func(product Compatible)([]Compatible, error)