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
	Src string		`json:"src,omitempty"`
	Dest string		`json:"dest,omitempty"`
}

type Address struct{

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