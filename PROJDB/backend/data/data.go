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


