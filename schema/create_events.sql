USE PYSAZ;

CREATE EVENT IF NOT EXISTS CheckExpirationVip
ON SCHEDULE EVERY 1 DAY
DO
DELETE FROM VIP_CLIENTS
WHERE Subcription_expiration_time <= NOW();


DELIMITER //
CREATE EVENT IF NOT EXISTS check3DaysForSubmmitingLockedShoppingCart
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- Create a temporary table to store the aggregated data
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_distinct_carts (
        Product_ID INT,
        Quantity INT
    );

    -- Populate the temporary table with the aggregated quantities
    INSERT INTO temp_distinct_carts (Product_ID, Quantity)
    SELECT Product_ID, SUM(Quantity) AS Quantity
    FROM (
        SELECT DISTINCT LSC.ID, LSC.Cart_number, LSC.Number, PRODUCT.ID AS Product_ID, ADDED_TO.Quantity
        FROM PRODUCT
        JOIN ADDED_TO ON ADDED_TO.Product_ID = PRODUCT.ID
        JOIN LOCKED_SHOPPING_CART LSC ON ADDED_TO.ID = LSC.ID AND ADDED_TO.Cart_number = LSC.Cart_number
             AND LSC.Number = ADDED_TO.Locked_number
        JOIN SHOPPING_CART SH ON LSC.ID = SH.ID AND LSC.Cart_number = SH.Number
        WHERE SH.Status != 'active' AND LSC.Timestamp > NOW() - INTERVAL 4 DAY  AND LSC.Timestamp < NOW() - INTERVAL 3 DAY
    ) AS distinct_carts
    GROUP BY Product_ID;

    -- Update the PRODUCT table using the temporary table
    UPDATE PRODUCT
    JOIN temp_distinct_carts ON PRODUCT.ID = temp_distinct_carts.Product_ID
    SET PRODUCT.Stock_count = PRODUCT.Stock_count + temp_distinct_carts.Quantity;

    UPDATE SHOPPING_CART SH JOIN LOCKED_SHOPPING_CART LSC ON SH.ID = LSC.ID and SH.Number = LSC.Cart_number
    SET Status = 'blocked'
    WHERE SH.Status != 'active' AND LSC.Timestamp < NOW() - INTERVAL 3 DAY;

    -- Drop the temporary table to clean up
    DROP TEMPORARY TABLE IF EXISTS temp_distinct_carts;
END //
DELIMITER ;


CREATE EVENT IF NOT EXISTS everyMonthBacking15PercentOfShoppingToVipClientsWallet
ON SCHEDULE EVERY 1 MONTH
DO
CALL everyMonthBacking15PercentOfShoppingToVipClientsWallet();


-- after 7 days of blocking carts will active them
CREATE EVENT IF NOT EXISTS doActiveAfter7DaysBlock
ON SCHEDULE EVERY 1 DAY
DO
    UPDATE SHOPPING_CART SH
    JOIN (
        SELECT ID, Cart_number, MAX(Timestamp) AS LatestTimestamp
        FROM LOCKED_SHOPPING_CART LSC
        GROUP BY ID, Cart_number 
    ) AS LatestLockedCart
    ON SH.ID = LatestLockedCart.ID AND SH.Number = LatestLockedCart.Cart_number
    SET SH.Status = 'active'
    WHERE SH.Status = 'blocked' AND LatestTimestamp < NOW() - INTERVAL 10 DAY;