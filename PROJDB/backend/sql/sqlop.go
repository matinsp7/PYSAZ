package sql

import (
	"PROJDB/backend/data"
	"database/sql"
	"errors"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
	"golang.org/x/crypto/bcrypt"
	// mapset "github.com/deckarep/golang-set/v2"

)

var db *sql.DB

func hashPassword(password string) string {
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		log.Fatalf("Failed to hash password: %v", err)
	}
	return string(hash)
}

func InsertNewUser(newUser *data.Client) error {
	hashedPassword := hashPassword(newUser.Password)
	query := `
	INSERT INTO CLIENT (First_name, Last_name, Phone_number, Wallet_balance, Refferal_code, PasswordHash, Timestamp)
	VALUES (?, ?, ?, ?, ?, ?, ?)
	`
	_, err := db.Exec(query, newUser.FirstName, newUser.LastName, newUser.PhoneNumber,
		newUser.WalletBalance, newUser.RefferalCode, hashedPassword, "2025-01-10")
	return err
}

func GetUserFromSql(phoneNumber string, passwrod string) (*data.Client, error) {

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

	if err != nil {
		return nil, errors.New("phone number or password is incorrect")
	}

	return &user, nil
}

func IsVIP(id any) (string, error) {

    query := `SELECT Subcription_expiration_time FROM VIP_CLIENTS WHERE ID = ?`

	var date string
    err := db.QueryRow(query, id).Scan(&date)
    if err != nil {
        if err == sql.ErrNoRows {
            return "", nil
        }
        return "", err
    }

    return date, nil
}

// ==============================                 WARNING                ===========================================
//------------------------------- be careful beacuse if a user have'not adrress it's not error!!--------------------

func GetAddressOfUser (id any) (map[int]data.Address, error) {

	row, err := db.Query("SELECT * FROM ADDRESS WHERE ID = ?", id)

	if err != nil {

		if errors.Is(err, sql.ErrNoRows) {

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

func GetDisCodes (id any) ([]data.DisCode, error) {

	query := `
		select DISCOUNT_CODE.Code, Amount, Code_limit, Usage_count, Expiration_date 
		from  DISCOUNT_CODE JOIN PRIVATE_CODE ON DISCOUNT_CODE.Code = PRIVATE_CODE.Code
		WHERE ID = ? and Expiration_date < NOW() + INTERVAL 7 DAY AND Expiration_date >= NOW()
	`

	row, err := db.Query(query, id)
	if err != nil {

		if errors.Is(err, sql.ErrNoRows) {

			return nil, nil

		} else {
			return nil, err
		}
	}
	var codes []data.DisCode
	for row.Next() {
		var tmp data.DisCode
		err := row.Scan(&tmp.Code, &tmp.Amount, &tmp.Code_limit, &tmp.Usage_count, &tmp.Expiration_date)
		if err != nil {log.Print(err)}
		codes = append(codes, tmp)
	}
	return codes, nil
}

func GetShoppingCart (id any) ([]data.ShoppingCart, error) {
	// log.Print("hiiiiio")
	isVIP, err := IsVIP(id)
	if err != nil {
		log.Print(err.Error())
		return nil, err
	}
	var query string
	if isVIP == "" {
		query = `
			select * 
			from SHOPPING_CART
			WHERE ID = ? AND Number = 1
		`
	} else {
		query = `
			select * 
			from SHOPPING_CART
			WHERE ID = ?
		`
	}

	row, err := db.Query(query, id)
	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	// log.Print("hiiiiio2")

	var carts []data.ShoppingCart
	for row.Next() {
		// log.Print("hiiiiio3")
		var cart data.ShoppingCart 
		row.Scan(&cart.ID, &cart.Number, &cart.Status)
		// log.Print(cart)
		carts = append(carts, cart)
	}

	// log.Print("hiiiiio4")
	return carts, nil
}

// ------------------------myabe need set a value for emptiness-------------------------

func GetUserBasketShop(id any) (map[int]data.Basket, error) {

	query := "SELECT LSC.ID, LSC.Cart_number, LSC.Number, LSC.Timestamp FROM LOCKED_SHOPPING_CART LSC JOIN ISSUED_FOR ISF ON LSC.ID = ISF.ID and LSC.Cart_number = ISF.Cart_number and LSC.Number = ISF.Locked_number JOIN TRANSACTION T ON ISF.Tracking_code = T.Tracking_code WHERE LSC.ID = ? and T.Status = True ORDER BY LSC.Timestamp DESC"

	row, err := db.Query(query, id)

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

		counter2 := 1
		basketinfo := []data.BasketInfo{}

		for row2.Next() {

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

	if len(basket) == 0{
		err = errors.New("You haven't any Order")
	}

	return basket, err
}


func FindCompatibleWithMotherBoard(product data.Compatible) ([]data.Compatible, error) {

	products := make([]data.Compatible, 0)

	Ram, err := CompatibleRamWithMotherBoard("Ram_ID", product.Model, product.Brand, "Motherboard_ID")


	if err != nil {
		return nil, err
	}

	SSD, err := CompatibleSSDWithMotherBoard("SSD_ID", product.Model, product.Brand, "Motherboard_ID")


	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	GPU, err := CompatibleGPUWithMotherboard("GPU_ID", product.Model, product.Brand, "Motherboard_ID")

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	CPU, err := CompatibleCPUWithMotehrBoard("CPU_ID", product.Model, product.Brand, "Motherboard_ID")

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	products = append(products, CPU...)
	products = append(products, GPU...)
	products = append(products, Ram...)
	products = append(products, SSD...)


	return products, nil
}

func FindCompatibleWithSSD(product data.Compatible) ([]data.Compatible, error) {

	products := make([]data.Compatible, 0)

	Motherboard, err := CompatibleSSDWithMotherBoard("Motherboard_ID", product.Model, product.Brand, "SSD_ID")


	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	products = append(products, Motherboard...)

	return products, nil
}

func FindCompatibleWithCPU(product data.Compatible) ([]data.Compatible, error) {

	products := make([]data.Compatible, 0)

	Cooler, err := CompatibleCoolerWithCPU("Cooler_ID", product.Model, product.Brand, "CPU_ID")


	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	Motherboard, err := CompatibleCPUWithMotehrBoard("Motherboard_ID", product.Model, product.Brand, "CPU_ID")

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}


	products = append(products, Motherboard...)
	products = append(products, Cooler...)

	return products, nil
}

func FindCompatibleWithRAM(product data.Compatible) ([]data.Compatible, error) {

	products := make([]data.Compatible, 0)

	Motherboard, err := CompatibleRamWithMotherBoard("Motherboard_ID", product.Model, product.Brand, "Ram_ID")


	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	products = append(products, Motherboard...)

	return products, nil
}

func FindCompatibleWithGPU(product data.Compatible) ([]data.Compatible, error) {

	products := make([]data.Compatible, 0)

	Motherboard, err := CompatibleGPUWithMotherboard("Motherboard_ID", product.Model, product.Brand, "GPU_ID")


	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	Power, err := CompatibleGPUWithPower("Power_ID", product.Model, product.Brand, "GPU_ID")

	products = append(products, Motherboard...)
	products = append(products, Power...)

	return products, nil
}


func FindCompatibleWithPower(product data.Compatible) ([]data.Compatible, error) {

	products := make([]data.Compatible, 0)

	GPU, err := CompatibleGPUWithPower("GPU_ID", product.Model, product.Brand, "Power_ID")


	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	products = append(products, GPU...)

	return products, nil
}


func FindCompatibleWithCooler(product data.Compatible) ([]data.Compatible, error) {

	products := make([]data.Compatible, 0)

	CPU, err := CompatibleCoolerWithCPU("CPU_ID", product.Model, product.Brand, "Cooler_ID")


	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	products = append(products, CPU...)

	return products, nil
}

func CompatibleRamWithMotherBoard(destTypeID string, model string, brand string, srcTypeID string) ([]data.Compatible, error) {

	productID, err := FindProductID(brand, model)

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	Products, err := GetCompatiblesProducts(destTypeID, srcTypeID, productID, "RM_SLOT_COMPATIBLE_WITH")

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	return Products, nil
}

func CompatibleGPUWithPower(destTypeID string, model string, brand string, srcTypeID string) ([]data.Compatible, error) {

	productID, err := FindProductID(brand, model)

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	Products, err := GetCompatiblesProducts(destTypeID, srcTypeID, productID, "CONNECTOR_COMPATIBLE_WITH")

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	return Products, nil
}

func CompatibleSSDWithMotherBoard(destTypeID string, model string, brand string, srcTypeID string) ([]data.Compatible, error) {

	productID, err := FindProductID(brand, model)

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	Products, err := GetCompatiblesProducts(destTypeID, srcTypeID, productID, "SM_SLOT_COMPATIBLE_WITH")

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	return Products, nil
}

func CompatibleGPUWithMotherboard(destTypeID string, model string, brand string, srcTypeID string) ([]data.Compatible, error) {

	productID, err := FindProductID(brand, model)

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	Products, err := GetCompatiblesProducts(destTypeID, srcTypeID, productID, "GM_SLOT_COMPATIBLE_WITH")


	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	return Products, nil
}

func CompatibleCoolerWithCPU(destTypeID string, model string, brand string, srcTypeID string) ([]data.Compatible, error) {

	productID, err := FindProductID(brand, model)

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	Products, err := GetCompatiblesProducts(destTypeID, srcTypeID, productID, "CC_SOCKET_COMPATIBLE_WITH")

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	return Products, nil
}

func CompatibleCPUWithMotehrBoard(destTypeID string, model string, brand string, srcTypeID string) ([]data.Compatible, error) {

	productID, err := FindProductID(brand, model)

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	Products, err := GetCompatiblesProducts(destTypeID, srcTypeID, productID, "MC_SOCKET_COMPATIBLE_WITH")

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	return Products, nil
}

func FindProductID(brand string, model string) (int, error) {

	var productID int

	err := db.QueryRow("SELECT ID FROM PRODUCT WHERE Brand = ? and Model = ?", brand, model).Scan(&productID)

	if errors.Is(err, sql.ErrNoRows) {
		return 0, errors.New("this product not exist")
	}

	if err != nil {
		log.Print(err.Error())
		return 0, err
	}

	return productID, nil
}

func GetCompatiblesProducts(destTypeID string, srcTypeID string, productID int, table string) ([]data.Compatible, error) {

	query := fmt.Sprintf("SELECT %s FROM %s WHERE %s = ?", destTypeID, table, srcTypeID)
	row, err := db.Query(query, productID)

	if errors.Is(err, sql.ErrNoRows) {
		return nil, errors.New("tehre is nothing to show!")
	}

	if err != nil {
		log.Print(err.Error())
		return nil, err
	}

	var compatible = []data.Compatible{}

	for row.Next() {

		var ID int
		var brand, model, category string

		row.Scan(&ID)

		_ = db.QueryRow("SELECT Brand, Model, Category FROM PRODUCT WHERE ID = ?", ID).Scan(&brand, &model, &category)


		compatible = append(compatible, data.Compatible{
			Brand: brand,
			Model: model,
			Category: category,
		})
	}

	return compatible, nil
}

func GetProduct() ([]data.Product) {
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

func NumberOfIntroduction(id int) int {
	query := `
			SELECT COUNT(*)
			FROM REFERS 
			WHERE Referrer = ?
	`
	var num int
	err := db.QueryRow(query, id).Scan(&num)
    if err != nil {
        log.Print(err.Error())
		return -5
    }
	return num
} 

func InsertAdress(id any, address data.Address) error{
	query := `
		INSERT INTO ADDRESS VALUES(?,?,?)
	` 
	_,err := db.Exec(query,  id, address.Province, address.Remainder)
	if err != nil{
		return err
	}
	return nil
}

func NumberOfReferralCodes () {

}

func MonthlyBonus (id any) (float32, error){
	query := `
		SELECT LOCKED_SHOPPING_CART.ID, LOCKED_SHOPPING_CART.Cart_number, LOCKED_SHOPPING_CART.Number
        FROM LOCKED_SHOPPING_CART
		JOIN ISSUED_FOR ON  LOCKED_SHOPPING_CART.ID = ISSUED_FOR.ID
		AND LOCKED_SHOPPING_CART.Cart_number = ISSUED_FOR.Cart_number
		AND LOCKED_SHOPPING_CART.Number = ISSUED_FOR.Locked_number
		JOIN TRANSACTION ON ISSUED_FOR.Tracking_code = TRANSACTION.Tracking_code
        WHERE LOCKED_SHOPPING_CART.ID = ? AND LOCKED_SHOPPING_CART.TIMESTAMP > NOW() - INTERVAL 30 DAY
		AND TRANSACTION.Status = true;
	`
	log.Print("idddd: ", id)
	row, err := db.Query(query, id)
	log.Print(row.Columns())
	if err != nil {
		log.Print(err)
		return 0, err
	}

	query = `
		call calculateCartPrice (?, ?, ?, @fp)
	`
	var res float32 = 0
	for row.Next() {
		log.Print("Poooo", res)
		var (
			id int
			cartNumber int
			number int
			tmp float32
		)
		row.Scan(&id, &cartNumber, &number)
		log.Print(&number)
		db.Exec(query, id, cartNumber, number)
		err:= db.QueryRow("select @fp").Scan(&tmp)
		log.Print("tmmmmmp: ", tmp)
		if err != nil {
			log.Print(err)
			return 0, err
		}
		res = res + 0.15 * tmp
	}
	log.Print("reeeeees: ", res)
	return res, nil
}