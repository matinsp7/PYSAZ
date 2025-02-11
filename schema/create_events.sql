USE PYSAZ;

CREATE EVENT IF NOT EXISTS CheckExpirationVip
ON SCHEDULE EVERY 1 DAY
DO
DELETE FROM VIP_CLIENTS
WHERE Subcription_expiration_time < NOW() - INTERVAL 1 MONTH;

CREATE EVENT IF NOT EXISTS check3DaysForSubmmitingLockedShoppingCart
ON SCHEDULE EVERY 1 DAY
DO
UPDATE PRODUCT
JOIN ADDED_TO ON ADDED_TO.Product_ID = PRODUCT.ID
JOIN LOCKED_SHOPPING_CART LSC ON ADDED_TO.ID = LSC.ID and ADDED_TO.Cart_number = LSC.Cart_number
     and LSC.Number = ADDED_TO.Locked_number
LEFT JOIN ISSUED_FOR ISF ON LSC.ID = ISF.ID and LSC.Cart_number = ISF.Cart_number and LSC.Number = ISF.Locked_number
LEFT JOIN TRANSACTION T ON ISF.Tracking_code = T.Tracking_code  
SET Stock_count = Stock_count + ADDED_TO.Quantity
WHERE (ISF.ID IS NULL or T.Status != TRUE) and LSC.Timestamp < NOW() - INTERVAL 3 DAY;

