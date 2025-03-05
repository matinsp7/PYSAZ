package sql

import (
	"PROJDB/backend/data"
	"database/sql"
	"errors"
	"log"
	"fmt"
	
	"golang.org/x/crypto/bcrypt"
	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB

func hashPassword(password string) string {
    hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
    if err != nil {
        log.Fatalf("Failed to hash password: %v", err)
    }
    return string(hash)
}

func InsertNewUser (newUser *data.Client) error {
	hashedPassword := hashPassword(newUser.Password)
	query := `
	INSERT INTO CLIENT (First_name, Last_name, Phone_number, Wallet_balance, Refferal_code, PasswordHash, Timestamp)
	VALUES (?, ?, ?, ?, ?, ?, ?)
	`
	_, err := db.Exec(query, newUser.FirstName, newUser.LastName, newUser.PhoneNumber, 
					newUser.WalletBalance, newUser.RefferalCode ,hashedPassword, "2025-01-10")
	return err;
}

func GetUserFromSql(phoneNumber string, passwrod string) (*data.Client,error) {


	row := db.QueryRow("SELECT * FROM CLIENT WHERE Phone_number = ?", phoneNumber)

	var user data.Client

	err := row.Scan(&user.FirstName, &user.LastName, &user.ID, &user.PhoneNumber, &user.WalletBalance,
		&user.RefferalCode, &user.Password, &user.TimeStamp)

	if err != nil {
		if errors.Is(err,sql.ErrNoRows) {
			return nil, errors.New("this phone number has not yet been registered")
		} else {
			return nil, err
		}
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(passwrod))
	
	if err != nil{
		return nil, errors.New("phone number or password is incorrect")
	}

	return &user, nil
}

func IsVIP(id any) (bool, error) {

    query := `
        SELECT EXISTS (
            SELECT 1 FROM VIP_CLIENTS WHERE ID = ?
        )
    `

    var exists bool
    err := db.QueryRow(query, id).Scan(&exists)
    
    if err != nil {
        // Handle both errors and sql.ErrNoRows
        if err == sql.ErrNoRows {
            return false, nil
        }
        return false, err
    }

    return exists, nil
}

// ==============================                 WARNING                ===========================================
//------------------------------- be careful beacuse if a user have'not adrress it's not error!!--------------------

func GetAddressOfUser (id any) (map[int]data.Address, error) {

	row, err := db.Query("SELECT * FROM ADDRESS WHERE ID = ?", id)

	if err != nil {

		if errors.Is(err ,sql.ErrNoRows) {

			return nil, errors.New("you have not registered any address")

		} else {
			return nil, err
		}
	}

	var addres = make(map[int]data.Address)
	var counter int = 1

	for row.Next() {
		var id int
		var province, remiander string

		row.Scan(&id, &province, &remiander)
		addres[counter] = data.Address{Province: province, Remainder: remiander}
		counter++
	}

	return addres, nil
}

// ------------------------myabe need set a value for emptiness-------------------------

func GetUserBasketShop(id any) (map[int]data.Basket, error) {

	query := "SELECT LSC.ID, LSC.Cart_number, LSC.Number, LSC.Timestamp FROM LOCKED_SHOPPING_CART LSC JOIN ISSUED_FOR ISF ON LSC.ID = ISF.ID and LSC.Cart_number = ISF.Cart_number and LSC.Number = ISF.Locked_number JOIN TRANSACTION T ON ISF.Tracking_code = T.Tracking_code WHERE LSC.ID = ? and T.Status = True ORDER BY LSC.Timestamp DESC"

	row, err := db.Query(query, id)

	if errors.Is(err, sql.ErrNoRows) {
		return nil, errors.New("tehre is nothing to show!")
	}

	if err != nil {
		log.Print(err)
		return nil, err
	}

	var basket = make(map[int]data.Basket)
	var counter int = 1

	for row.Next() {
		var id, cartnumber, lockednumber, totalPrice int
		var time string
		row.Scan(&id, &cartnumber, &lockednumber, &time)

		_, err := db.Exec("CALL calculateCartPrice(?, ?, ?, @fp)", id, cartnumber, lockednumber)

		if err != nil {
			log.Print(err.Error())
			return nil, err
		}

		err = db.QueryRow("SELECT @fp").Scan(&totalPrice)

		if err != nil {
			log.Print(err.Error())
			return nil, err
		}

		query := "SELECT Brand, Model, Quantity, Cart_price FROM ADDED_TO A JOIN PRODUCT P ON P.ID = A.Product_ID WHERE A.ID = ? and A.Cart_number = ? and A.Locked_number = ?"

		row2, err := db.Query(query, id, cartnumber, lockednumber)

		if err != nil {
			log.Print(err.Error())
			return nil, err
		}

		counter2 := 1;
		basketinfo := []data.BasketInfo{}

		for row2.Next(){

			var model, brand string
			var quantity, cartPrice int

			err = row2.Scan(&brand, &model, &quantity, &cartPrice)

			if err != nil {
				log.Print(err.Error())
			}

			basketinfo = append(basketinfo, data.BasketInfo{Model: model, Brand: brand, Price: cartPrice, Quantity: quantity})
			counter2++
		}

		basket[counter] = data.Basket{Number: lockednumber, TotalPrice: totalPrice, Time: time, Products: basketinfo}

		counter++
	}

	return basket, err
}

// func GetBasketInfo(id any, cart_number any, locked_number any) (map[int]string, error) {

// 	query := "SELECT Brand, Model, Quantity, Cart_price FROM ADDED_TO A JOIN PRODUCT P ON P.ID = A.Product_ID WHERE A.ID = ? and A.Cart_number = ? and A.Locked_number = ?"

// 	row, err := db.Query(query, id, cart_number, locked_number)

// 	if err != nil {
// 		log.Print(err.Error())
// 		return nil, err
// 	}

// 	var info = make(map[int]string)
// 	counter := 1

// 	for row.Next() {

// 		var brand, model, quantity, price string

// 		row.Scan(&brand, &model, &quantity, &price)

// 		info[counter] = brand + ", " + model + ", " + quantity + ", " + price
// 	}

// 	return info, nil
// }

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

func CompatibiltyGpuMotherboard(srcTypeID string, model string, brand string, destTypeID string) (map[int]data.Compatible, error){

	var productID int

	err := db.QueryRow("SELECT ID FROM PRODUCT WHERE Brand = ? and Model = ?", brand, model).Scan(&productID)

	if errors.Is(err, sql.ErrNoRows){
		return nil, errors.New("there is nothing to show")
	}

	if err != nil{
		log.Print(err.Error())
		return nil, err
	}

	query := fmt.Sprintf("SELECT %s FROM GM_SLOT_COMPATIBLE_WITH WHERE %s = ?", destTypeID, srcTypeID)
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

func CampatibleCoolerWithCPU(srcTypeID string, model string, brand string, destTypeID string) (map[int]data.Compatible, error){

	var productID int

	err := db.QueryRow("SELECT ID FROM PRODUCT WHERE Brand = ? and Model = ?", brand, model).Scan(&productID)

	if errors.Is(err, sql.ErrNoRows){
		return nil, errors.New("there is nothing to show")
	}

	if err != nil{
		log.Print(err.Error())
		return nil, err
	}

	query := fmt.Sprintf("SELECT %s FROM CC_SOCKET_COMPATIBLE_WITH WHERE %s = ?", destTypeID, srcTypeID)
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

func CampatibleCoolerWithMotehrBoard(srcTypeID string, model string, brand string, destTypeID string) (map[int]data.Compatible, error){

	var productID int

	err := db.QueryRow("SELECT ID FROM PRODUCT WHERE Brand = ? and Model = ?", brand, model).Scan(&productID)

	if errors.Is(err, sql.ErrNoRows){
		return nil, errors.New("there is nothing to show")
	}

	if err != nil{
		log.Print(err.Error())
		return nil, err
	}

	query := fmt.Sprintf("SELECT %s FROM CC_SOCKET_COMPATIBLE_WITH WHERE %s = ?", destTypeID, srcTypeID)
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



func GetProduct () ([]data.Product) {
	rows, _ := db.Query("SELECT ID, Category, Image, Current_price, Stock_count, Brand, Model, Image_address FROM PRODUCT")
	defer rows.Close()
	
	var products []data.Product
	for rows.Next() {
		var p data.Product
		rows.Scan(&p.ID, &p.Category, &p.Image, &p.CurrentPrice, &p.StockCount, &p.Brand, &p.Model, &p.Image_address)
		products = append(products, p)
	}
	return products;
}