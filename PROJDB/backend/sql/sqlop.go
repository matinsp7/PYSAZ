package sql

import (
	"PROJDB/backend/data"
	"database/sql"
	"errors"
	"log"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB

func GetUserFromSql(PhoneNumber string) (*data.Client,error) {


	row := db.QueryRow("SELECT * FROM CLIENT WHERE Phone_number = ?", PhoneNumber)

	var user data.Client

	err := row.Scan(&user.FirstName, &user.LastName, &user.ID, &user.PhoneNumber, &user.WalletBalance,
		&user.RefferalCode, &user.TimeStamp)

	if err != nil {

		if err == sql.ErrNoRows {

			return nil, errors.New("phonenumber is inccorect")

		} else {
			return nil, err
		}
	}

	return &user, nil
}

// ==============================                 WARNING                ===========================================
//------------------------------- be careful beacuse if a user have'not adrress it's not error!!--------------------

func GetAddressOfUser(id any) (map[int]string, error) {

	row, err := db.Query("SELECT * FROM ADDRESS WHERE ID = ?", id)

	if err != nil {

		if errors.Is(err ,sql.ErrNoRows) {

			return nil, errors.New("you have not registered any address!")

		} else {
			return nil, err
		}
	}

	var addres = make(map[int]string)
	var counter int = 1

	for row.Next() {
		var id int
		var province, remiander string

		row.Scan(&id, &province, &remiander)
		addres[counter] = province + "," + remiander
		counter++
	}

	return addres, nil
}

// ------------------------myabe need set a value for emptiness-------------------------

func GetUserBasketShop(id any) (map[int]string, error) {

	query := "SELECT LSC.ID, LSC.Cart_number, LSC.Number FROM LOCKED_SHOPPING_CART LSC JOIN ISSUED_FOR ISF ON LSC.ID = ISF.ID and LSC.Cart_number = ISF.Cart_number and LSC.Number = ISF.Locked_number JOIN TRANSACTION T ON ISF.Tracking_code = T.Tracking_code WHERE LSC.ID = ? and T.Status = True ORDER BY LSC.Timestamp DESC"

	row, err := db.Query(query, id)

	if errors.Is(err, sql.ErrNoRows) {
		return nil, errors.New("tehre is nothing to show!")
	}

	if err != nil {
		log.Print(err)
		return nil, err
	}

	var basket = make(map[int]string)
	var counter int = 1

	for row.Next() {
		var id, cartnumber, lockednumber, price int
		row.Scan(&id, &cartnumber, &lockednumber)

		_, err := db.Exec("CALL calculateCartPrice(?, ?, ?, @fp)", id, cartnumber, lockednumber)

		if err != nil {
			log.Print(err.Error())
			return nil, err
		}

		err = db.QueryRow("SELECT @fp").Scan(&price)

		if err != nil {
			log.Print("**********************",err.Error())
			return nil, err
		}

		basket[counter] = fmt.Sprintf("%d %d %d %d", id, cartnumber, lockednumber, price)
		counter++
	}

	return basket, err
}

func GetBasketInfo(id any, cart_number any, locked_number any) (map[int]string, error) {

	query := "SELECT Brand, Model, Quantity, Cart_price FROM ADDED_TO A JOIN PRODUCT P ON P.ID = A.Product_ID WHERE A.ID = ? and A.Cart_number = ? and A.Locked_number = ?"

	row, err := db.Query(query, id, cart_number, locked_number)

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	var info = make(map[int]string)
	counter := 1

	for row.Next() {

		var brand, model, quantity, price string

		row.Scan(&brand, &model, &quantity, &price)

		info[counter] = brand + ", " + model + ", " + quantity + ", " + price
	}

	return info, nil
}

func CompatibleRamWithMotherBoard(srcTypeID string, model string, brand string, destTypeID string) (map[int]data.Compatible, error) {

	var productID int

	err := db.QueryRow("SELECT ID FROM PRODUCT WHERE Brand = ? and Model = ?", brand, model).Scan(&productID)

	if errors.Is(err, sql.ErrNoRows) {
		return nil, errors.New("tehre is nothing to show!")
	}

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	query := fmt.Sprintf("SELECT %s FROM RM_SLOT_COMPATIBLE_WITH WHERE %s = ?", destTypeID, srcTypeID)
	row, err := db.Query(query, productID)

	if errors.Is(err, sql.ErrNoRows) {
		return nil, errors.New("tehre is nothing to show!")
	}

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	counter := 1
	var compatible = make(map[int]data.Compatible)

	for row.Next() {

		var brand, model string
		var ID string

		row.Scan(&ID)

		_ = db.QueryRow("SELECT Brand, Model FROM PRODUCT WHERE ID = ?", ID).Scan(&brand, &model)

		compatible[counter] = data.Compatible{
			Brand: brand,
			Model: model,
		}
		counter++
	}

	return compatible, nil
}

func CampatibleGpuWithPower(srcTypeID string, model string, brand string, destTypeID string) (map[int]data.Compatible, error){

	var productID int

	err := db.QueryRow("SELECT ID FROM PRODUCT WHERE Brand = ? and Model = ?", brand, model).Scan(&productID)

	if errors.Is(err, sql.ErrNoRows){
		return nil, errors.New("there is nothing to show")
	}

	if err != nil{
		log.Print(err.Error())
		return nil, err
	}

	query := fmt.Sprintf("SELECT %s FROM CONNECTOR_COMPATIBLE_WITH WHERE %s = ?", destTypeID, srcTypeID)
	row, err := db.Query(query, productID)

	if errors.Is(err, sql.ErrNoRows){
		return nil, errors.New("there is nothing to show")
	}

	if err != nil{
		return nil, err
	}

	counter := 1
	var compatible = make(map[int]data.Compatible)

	for row.Next(){

		var ID int
		var brand, model string

		row.Scan(&ID)

		_ = db.QueryRow("SELECT Brand, Model FROM PRODUCT WHERE ID = ?", ID).Scan(&brand, &model)

		compatible[counter] = data.Compatible{
			Brand: brand,
			Model: model,
		}

		counter++
	}

	return compatible, nil
}

func CampatibleSSDWithMotherBoard(srcTypeID string, model string, brand string, destTypeID string) (map[int]data.Compatible, error){

	var productID int

	err := db.QueryRow("SELECT ID FROM PRODUCT WHERE Brand = ? and Model = ?", brand, model).Scan(&productID)

	if errors.Is(err, sql.ErrNoRows){
		return nil, errors.New("there is nothing to show")
	}

	if err != nil{
		log.Print(err.Error())
		return nil, err
	}

	query := fmt.Sprintf("SELECT %s FROM SM_SLOT_COMPATIBLE_WITH WHERE %s = ?", destTypeID, srcTypeID)
	row, err := db.Query(query, productID)

	if errors.Is(err, sql.ErrNoRows){
		return nil, errors.New("there is nothing to show")
	}

	if err != nil{
		return nil, err
	}

	counter := 1
	var compatible = make(map[int]data.Compatible)

	for row.Next(){

		var ID int
		var brand, model string

		row.Scan(&ID)

		_ = db.QueryRow("SELECT Brand, Model FROM PRODUCT WHERE ID = ?", ID).Scan(&brand, &model)

		compatible[counter] = data.Compatible{
			Brand: brand,
			Model: model,
		}

		counter++
	}

	return compatible, nil
}