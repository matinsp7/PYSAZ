package data

import ()

type Client struct {
	FirstName     string `json:"FirstName"`
	LastName      string `json:"LastName"`
	ID            int    `json:"ID"`
	PhoneNumber   string `json:"PhoneNumber"`
	WalletBalance int    `json:"WalletBalance"`
	RefferalCode  string `json:"RefferalCode"`
	TimeStamp     string `json:"TimeStamp"`
}

type Compatible struct{

	Brand string	`json:"brand"`	
	Model string	`json:"model"`
	Src string		`json:"src,omitempty"`
	Dest string		`json:"dest,omitempty"`
}


