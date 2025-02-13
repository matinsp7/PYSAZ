USE PYSAZ;

CREATE EVENT IF NOT EXISTS CheckExpirationVip
ON SCHEDULE EVERY 1 DAY
DO
DELETE FROM VIP_CLIENTS
WHERE Subcription_expiration_time <= NOW();

CREATE EVENT IF NOT EXISTS check3DaysForSubmmitingLockedShoppingCart
ON SCHEDULE EVERY 1 DAY
DO

     CREATE VIEW distinct_carts AS
     SELECT Product_ID, SUM(Quantity) Quantity
     FROM  (SELECT DISTINCT LSC.ID, LSC.Cart_number, LSC.Number, PRODUCT.ID Product_ID, ADDED_TO.Quantity
     FROM PRODUCT JOIN ADDED_TO ON ADDED_TO.Product_ID = PRODUCT.ID
     JOIN LOCKED_SHOPPING_CART LSC ON ADDED_TO.ID = LSC.ID and ADDED_TO.Cart_number = LSC.Cart_number
          and LSC.Number = ADDED_TO.Locked_number 
     JOIN SHOPPING_CART SH ON LSC.ID = SH.ID and LSC.Cart_number = SH.Number 
     LEFT JOIN ISSUED_FOR ISF ON LSC.ID = ISF.ID and LSC.Cart_number = ISF.Cart_number 
          and LSC.Number = ISF.Locked_number
     LEFT JOIN TRANSACTION T ON ISF.Tracking_code = T.Tracking_code
     WHERE SH.Status != 'active' and (ISF.ID IS NULL or T.Status != TRUE) )
     AS distinct_carts GROUP BY Product_ID

     UPDATE PRODUCT JOIN distinct_carts ON ID = Product_ID
     SET Stock_count = Stock_count + Quantity;

     DROP VIEW distinct_carts

-- CREATE EVENT IF NOT EXISTS everyMonthBacking15PercentOfShoppingToVipClientsWallet
-- ON SCHEDULE EVERY 1 MONTH
-- DO
--      CREATE VIEW vipClients AS 
--      SELECT ID, Cart_number, Locked_number ,SUM(Quantity * Cart_price) Total_cart_price FROM ADDED_TO NATURAL JOIN VIP_CLIENTS
--      GROUP BY ID;

--      UPDATE CLIENT NATURAL JOIN vipClients NATURAL JOIN ISSUED_FOR JOIN TRANSACTION T
--      ON T.Tracking_code = ISSUED_FOR.Tracking_code
--      SET Wallet_balance = Wallet_balance + (0.15 * Total_cart_price)
--      WHERE T.Status = TRUE;

--      DROP VIEW vipClients;
