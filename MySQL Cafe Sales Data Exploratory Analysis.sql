### Data Exploratory Analysis: Cafe Sales 2023 ###

SELECT *
FROM staging;

# 1. Top 5 selling items based on quantity
SELECT Item, SUM(Quantity) AS quantitycount, 
DENSE_RANK() OVER(ORDER BY SUM(Quantity) DESC) AS ranking
FROM staging
GROUP BY Item
ORDER BY quantitycount DESC
LIMIT 5;
-- If stakeholder prioritizes quantity sold for their business, we should push these 5 items

# 2. Top 5 selling items based on revenue
SELECT Item, SUM(TotalSpent) AS TotalRevenue,
DENSE_RANK() OVER(ORDER BY SUM(TotalSpent) DESC) AS ranking
FROM staging
GROUP BY Item
ORDER BY TotalRevenue DESC
LIMIT 5;
-- With static price model, we should push these 5 items. Price per unit = Average Price Per Unit

# 3. What are the top 5 months in terms of revenue?
WITH monthrevenue AS
(
SELECT MONTH(TransactionDate) AS MonthNo, MONTHNAME(TransactionDate) AS MonthName,
SUM(TotalSpent) AS Revenue
FROM staging
GROUP BY MonthNo, MonthName
ORDER BY MonthNo)
SELECT MonthName, Revenue, DENSE_RANK() OVER(ORDER BY Revenue DESC) AS ranking
FROM monthrevenue
LIMIT 5;
-- These top 5 months appear to be our peak business times
-- However, the difference in our revenue month-to-month are marginal
-- This tells me our revenue is very static. Stakeholders will be advised to look at their business model

# 4. What is the total revenue generated over time?
WITH monthlyrevenue AS
(
SELECT MONTH(TransactionDate) AS MonthNo, MONTHNAME(TransactionDate) AS MonthName,
SUM(TotalSpent) AS Revenue
FROM staging
GROUP BY MonthNo, MonthName
ORDER BY MonthNo
)
SELECT MonthName, Revenue, SUM(Revenue) OVER(ORDER BY MonthNo) AS RunningRevenue
FROM monthlyrevenue;
-- This shows us how static our revenue is on a month-by-month basis
-- There seems to be no seasonality or trends in the year 2023
-- Marginal gains/losses per month are a few hundred dollars
-- Although differences are marginal in nature, we should also capitalize on ceiling/floors 
-- Stakeholders definitely need to look at business model as a whole

# 5. Which items contribute most to total revenue?

SELECT SUM(TotalSpent) AS TotalRevenue
FROM staging;

WITH RevenuePercentage AS
(
SELECT Item, PricePerUnit, SUM(Quantity) AS TotalQuantitySold, SUM(TotalSpent) AS Revenue, 
	(SELECT SUM(TotalSpent) FROM staging) AS TotalRevenue
FROM staging
GROUP BY Item, PricePerUnit
)
SELECT *, ROUND((Revenue / TotalRevenue) * 100, 2) AS PercentOfTotal
FROM RevenuePercentage
ORDER BY PercentOfTotal DESC;
-- As price per unit increases, percent of revenue per item towards total revenue increases
-- This shows that the items with the highest price per units give us the most revenue
-- Althrough there is a correlation between percent of revenue per item and price per unit, 
-- Total quantity sold remains static; marginal increases/decreases are only a couple hundreds units
-- Recommend stake holders to analyze their business model

# 6. What is the relationship between Total Revenue and Total Quantity Sold?
WITH groupedsums AS
(
SELECT MONTH(TransactionDate) AS MonthNo, MONTHNAME(TransactionDate) AS MonthName,
SUM(TotalSpent) AS TotalRevenue, SUM(Quantity) AS TotalQuantitySold
FROM staging
GROUP BY MonthNo, MonthName
ORDER BY MonthNo
),
laggedsums AS
(
SELECT *, LAG(TotalRevenue) OVER(ORDER BY MonthNo) AS PreviousRevenue,
LAG(TotalQuantitySold) OVER(ORDER BY MonthNo) AS PreviousQuantitySold
FROM groupedsums
),
trends AS
(
SELECT MonthName, PreviousRevenue, TotalRevenue AS CurrentRevenue, TotalRevenue - PreviousRevenue AS revdifference,
TotalQuantitySold AS CurrentQuantitySold, PreviousQuantitySold, TotalQuantitySold - PreviousQuantitySold AS quantdifference
FROM laggedsums
)
SELECT MonthName, revdifference, quantdifference
FROM trends;
-- Total revenue and total quantity sold have strong correlation; both variables move in the same direction on a month-to-month basis
-- For example, both total revenue and total quantity sold decrease when shifting from January to February
-- Ultimately, this tells us that the price levels in the year 2023 have remained static; no dynamic pricing was implemented in the business model
-- As a result, changes in quantity sold directly leads to proportional changes in total revenue. 
-- We can confirm that there was no variation of dynamic pricing in this business model by comparing average revenue per unit to the price per unit listed

SELECT Item, PricePerUnit, AvgRevPerUnit
FROM
(
	SELECT *, ROUND(TotalRevenue / TotalQuantitySold, 2) AS AvgRevPerUnit
	FROM
	(
		SELECT Item, PricePerUnit, SUM(TotalSpent) AS TotalRevenue, SUM(Quantity) AS TotalQuantitySold
		FROM staging
		GROUP BY Item, PricePerUnit
		ORDER BY PricePerUnit
	) AS totals
) AS PPUCheck
WHERE PricePerUnit = AvgRevPerUnit;
-- As expected, average revenue per unit is the same as the listed price per unit, meaning no evidence of dynamic pricing was found.
-- Suggest dynamic pricing within this business model by introducing promotions, product bundling, and premium versions of certain items.

# 7. What percentage of transactions use cash, credit card, or digital wallets?
WITH MethodPercentage AS
(
SELECT PaymentMethod, COUNT(*) AS MethodCount,
	(SELECT COUNT(*) FROM staging) AS TotalTransactions
FROM staging
GROUP BY PaymentMethod
)
SELECT *, ROUND((MethodCount / TotalTransactions * 100), 2) AS PercentOfTotal
FROM MethodPercentage;
-- Percentages of transactions for each payment method are equally distributed
-- As such, when implementing loyalty program, we can be flexible

# 8. Are certain payment methods more popular for specific items or locations?
WITH ItemMethodPCT AS
(
SELECT Item, PaymentMethod, COUNT(*) AS Count,
	(SELECT COUNT(*) FROM staging) AS TotalTransactions
FROM staging
GROUP BY Item, PaymentMethod
ORDER BY count DESC
)
SELECT *, ROUND((Count / TotalTransactions * 100), 2) AS PercentOfTotal
FROM ItemMethodPCT
ORDER BY Item;
-- Percentages of transactions for each item and payment method are relatively equal in distribution
-- Marginal increases/decreases are only tenths of percents
-- Certain payment methods are not more popular for specific items

WITH LocationMethodPCT AS
(
SELECT Location, PaymentMethod, COUNT(*) AS Count,
	(SELECT COUNT(*) FROM staging) AS TotalTransactions
FROM staging
GROUP BY Location, PaymentMethod
ORDER BY count DESC
)
SELECT *, ROUND((Count / TotalTransactions * 100), 2) AS PercentOfTotal
FROM LocationMethodPCT
ORDER BY Location;
-- Percentages of transactions for each location and payment method are relatively equal in distribution
-- Marginal increases/decreases are only tenths of percents
-- Certain payment methods are not more popular for specific locations

# 9. How do sales differ between Takeaway and In-store Purchases?
SELECT Location, COUNT(*) AS Count
FROM staging
GROUP BY Location;
-- Distribution between takeaway and in-store purchases are equal in distribution
-- Since locations are also equally distributed, our loyalty program may be flexible

# 10. Do certain items sell better in one location type versus the other?

WITH QuantitySold AS
(
SELECT item, location, SUM(Quantity) AS TotalQuantitySold
FROM staging
GROUP BY Item, Location
ORDER BY Location, TotalQuantitySold
)
SELECT t1.item, t1.location, t1.TotalQuantitySold, 
t2.location, t2.TotalQuantitySold, ABS(t1.TotalQuantitySold - t2.TotalQuantitySold) AS Difference
FROM QuantitySold AS t1
JOIN QuantitySold AS t2
	ON t1.item = t2.item
WHERE t1.location = 'In-store'
AND t2.location = 'Takeaway'
ORDER BY difference DESC;
-- Certain items do sell better in one location versus the other marginally
-- However, the difference is not large enough to warrant specific targeting in business model towards item and location
-- We will now implement our findings to PowerBI and create a dashboard!

