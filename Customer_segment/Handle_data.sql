-- HANDLING AND CLEANING DATA

SET SQL_SAFE_UPDATES = 0;
-- Change type for education column
UPDATE marketing_campaign
SET education = 'Undergraduation'
WHERE education IN ('2n Cycle', 'Basic');

-- Change type for marital_status column
UPDATE marketing_campaign
SET marital_status = 'Single'
WHERE marital_status IN ('Divorced', 'Widow', 'YOLO', 'Alone', 'Absurd');

UPDATE marketing_campaign
SET marital_status = 'In couple'
WHERE marital_status IN ('Together', 'Married');

-- Add total_children column
ALTER TABLE marketing_campaign
ADD COLUMN total_kid INT AFTER teenhome;

UPDATE marketing_campaign m 
SET total_kid = m.kidhome + m.teenhome;

-- Drop unnecessary columns
ALTER TABLE marketing_campaign
DROP COLUMN z_costcontact
, DROP COLUMN z_revenue
, DROP COLUMN complain
, DROP COLUMN numwebvisitsmonth;

-- Add total_spending column
ALTER TABLE marketing_campaign
ADD COLUMN total_spending INT;

UPDATE marketing_campaign
SET total_spending = mntwines + mntfruits + mntmeatproducts + mntfishproducts + mntsweetproducts + mntgoldprods;

-- Add frequency column
ALTER TABLE marketing_campaign
ADD COLUMN frequency INT;

UPDATE marketing_campaign
SET frequency = numwebpurchases + numcatalogpurchases + numstorepurchases; 

-- Add total_purchases column
ALTER TABLE marketing_campaign
ADD COLUMN total_purchases INT;

UPDATE marketing_campaign
SET total_purchases = numwebpurchases + numcatalogpurchases + numstorepurchases;




