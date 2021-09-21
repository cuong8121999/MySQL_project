-- EXPLORATORY DATA

-- Analyzing income and total spend for each type of user
SELECT education
	, marital_status
    , ROUND(AVG(income),2) avg_income
    , ROUND(AVG(total_spending),2) avg_total_spending
    , ROUND(AVG(mntwines),2) avg_mntwines
    , ROUND(AVG(mntfruits),2) avg_mntfruits
    , ROUND(AVG(mntmeatproducts),2) avg_mntmeat
    , ROUND(AVG(mntfishproducts),2) avg_mntfish
    , ROUND(AVG(mntsweetproducts),2) avg_mntsweet
    , ROUND(AVG(mntgoldprods),2) avg_mntgold
FROM marketing_campaign
GROUP BY education
	, marital_status
ORDER BY 3 DESC;

-- Trending to buy items on different places
WITH trend AS (
	SELECT id
		, education
        , marital_status
		, ROUND(numdealspurchases / total_purchases * 100, 2) deals_per_total
		, ROUND(numwebpurchases / total_purchases * 100, 2) web_per_total
		, ROUND(numcatalogpurchases / total_purchases * 100, 2) catalog_per_total
		, ROUND(numstorepurchases / total_purchases * 100, 2) store_per_total
	FROM marketing_campaign
)

SELECT education
	, marital_status
    , CONCAT(ROUND(AVG(deals_per_total),2), '%') percent_deals_per_total
    , CONCAT(ROUND(AVG(web_per_total),2), '%') percent_web_per_total
    , CONCAT(ROUND(AVG(catalog_per_total),2), '%') percent_catalog_per_total
    , CONCAT(ROUND(AVG(store_per_total),2), '%') percent_store_per_total
FROM trend
GROUP BY education
	, marital_status;

-- Calculating the effective of marketing_campaign per customer type
WITH cal_cmp AS (
	SELECT education
		, marital_status
		, SUM(total_spending) total_spending
		, CONCAT(ROUND(SUM(acceptedcmp1) / COUNT(DISTINCT(id)) * 100,2), '%') percent_customer_accepted_first_campaign
		, CONCAT(ROUND(SUM(acceptedcmp2) / COUNT(DISTINCT(id)) * 100,2), '%') percent_customer_accepted_second_campaign
		, CONCAT(ROUND(SUM(acceptedcmp3) / COUNT(DISTINCT(id)) * 100,2), '%') percent_customer_accepted_third_campaign
		, CONCAT(ROUND(SUM(acceptedcmp4) / COUNT(DISTINCT(id)) * 100,2), '%') percent_customer_accepted_fourth_campaign
		, CONCAT(ROUND(SUM(acceptedcmp5) / COUNT(DISTINCT(id)) * 100,2), '%') percent_customer_accepted_fifth_campaign
		, CONCAT(ROUND(SUM(response) / COUNT(DISTINCT(id)) * 100,2), '%') percent_customer_accepted_sixth_campaign
	FROM marketing_campaign
	GROUP BY education
		, marital_status
)

, total_cal_cmp AS (
	SELECT *
		, CONCAT(ROUND(percent_customer_accepted_first_campaign
		+ percent_customer_accepted_second_campaign
		+ percent_customer_accepted_third_campaign
		+ percent_customer_accepted_fourth_campaign
		+ percent_customer_accepted_fifth_campaign
		+ percent_customer_accepted_sixth_campaign, 2), '%') total_percent_customer_accepted_campaign
	FROM cal_cmp
)

SELECT *
	, DENSE_RANK () OVER (ORDER BY total_percent_customer_accepted_campaign DESC) rank_customer_cmp
FROM total_cal_cmp;





    

