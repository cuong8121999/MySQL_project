-- RFM_SEGMENT CUSTOMER
WITH cte AS (
	SELECT id
		, recency
        , frequency
        , total_spending
	FROM marketing_campaign
)

, rfm_percent_rank AS (
	SELECT *
		, PERCENT_RANK() OVER (ORDER BY frequency) frequency_percent_rank
		, PERCENT_RANK() OVER (ORDER BY total_spending) total_spending_percent_rank
	FROM cte
) 

, rfm_rank AS (
	SELECT *
		, CASE WHEN recency BETWEEN 0 AND 24 THEN 4
			WHEN recency BETWEEN 25 AND 49 THEN 3
			WHEN recency BETWEEN 50 AND 74 THEN 2
			WHEN recency BETWEEN 75 AND 99 THEN 1
			ELSE 0
			END recency_rank
		, CASE WHEN frequency_percent_rank BETWEEN 0.8 AND 1 THEN 4
			WHEN frequency_percent_rank BETWEEN 0.6 AND 0.79 THEN 3
			WHEN frequency_percent_rank BETWEEN 0.40 AND 0.69 THEN 2
			WHEN frequency_percent_rank BETWEEN 0 AND 39 THEN 1
			ELSE 0
			END frequency_rank
		, CASE WHEN total_spending_percent_rank BETWEEN 0.8 AND 1 THEN 4
			WHEN total_spending_percent_rank BETWEEN 0.6 AND 0.79 THEN 3
			WHEN total_spending_percent_rank BETWEEN 0.40 AND 0.69 THEN 2
			WHEN total_spending_percent_rank BETWEEN 0 AND 39 THEN 1
			ELSE 0
			END total_spending_rank
	FROM rfm_percent_rank
)

, rfm_rank_concat AS (
	SELECT *
		, CONCAT(recency_rank, frequency_rank, total_spending_rank) rfm_rank_concat
	FROM rfm_rank
)

SELECT *
	, CASE WHEN rfm_rank_concat IN ('444', '434', '443', '433') THEN 'VIP'
		WHEN rfm_rank_concat IN ('424', '414') THEN 'VIP, Bulk buying'
        WHEN rfm_rank_concat IN ('442', '422', '441') THEN 'Normal'
        WHEN rfm_rank_concat IN ('411', '311') THEN 'Fleeting'
        WHEN rfm_rank_concat IN ('344', '343', '334', '333') THEN 'VIP, Dropped ready'
        WHEN rfm_rank_concat IN ('324', '314') THEN 'VIP, Bulk buying, Dropped ready'
        WHEN rfm_rank_concat IN ('342', '322', '341') THEN 'Normal'
        WHEN rfm_rank_concat IN ('244', '243', '234', '233') THEN 'VIP, Dropped'
        WHEN rfm_rank_concat IN ('224', '214') THEN 'VIP, Bulk buying, Dropped'
        WHEN rfm_rank_concat IN ('242', '222', '241') THEN 'Normal, Dropped'
        WHEN rfm_rank_concat IN ('211', '111') THEN 'Fleeting, Disappear'
        WHEN rfm_rank_concat IN ('144', '143', '134', '133') THEN 'VIP, Disappear'
        WHEN rfm_rank_concat IN ('224', '214') THEN 'VIP, Bulk buying, Disappear'
        WHEN rfm_rank_concat IN ('242', '222', '241') THEN 'Normal, Disappear'
        ELSE 'Unknown'
        END customer_segment
FROM rfm_rank_concat;