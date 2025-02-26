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


