# Café Sales Project

### Dataset Source: https://www.kaggle.com/datasets/ahmedmohamed2003/cafe-sales-dirty-data-for-cleaning-training

## Overview
A café has requested our services in order to improve the operations and financials of their business. A dataset consisting of 10,000 rows of café sales was provided to us; however, there are many NULL values and standardization issues within this dataset. After cleaning the data, we must help stakeholders understand important metrics within this café as shown in the dashboard in PowerBI. The objective of this project is to extract insights such as sales performance, customer behavior, and operational efficiency from the dataset to suggest improvements under the economy of this café to improve the business owners' KPI goal of $7,000 to $8,500 in profit monthly to meet the overall KPI goal of $100,000 annually.

### Steps followed 

- Step 1: Opened source .csv file and standardize columns header by trimming
- Step 2: Created database schema on MySQL and imported .csv data and created table
- Step 3: Created duplicate table with source dataset to clean and standardize data
- Step 4: Cleaned dataset (steps shown in SQL script under "MySQL Café Sales Cleaning")
- Step 5: Explored and analyzed clean dataset to extract actionable insights to be shown on dashboard (steps shown in SQL script under "MySQL Café Sales Data Exploratory Analysis)
- Step 6: Exported final cleaned dataset into .csv file and imported it into PowerBI
- Step 7: Changed column names from "TotalSpent" and "Location" to "Revenue" and "OrderType" to help increase readability for users
- Step 8: Utilized lists to categorize items in either "Beverages" or "Food" and created a new column 
- Step 9: Created separate data table from min date (January 1st, 2023) to max date (December 31st, 2023) referenced from our original dataset to create desired date hierarchies in drilldowns
- Step 10: Implemented slicers for all categorical fields such as Payment Method, Category, Order Type, and Month.
- Step 11: Added three cards to highlight the number of transactions, total revenue, and average revenue per transaction
- Step 12: Added line chart of total revenue by a hierarchy of quarter, month, and weekday to showcase revenue trends
- Step 13: Added stacked bar and column chart of Total Revenue by Category and Item and Total Quantity Sold by Category and Item respectively to analyze the relationship between both variables
- Step 14: Added donut chart and pie chart of Payment Method and Order Type respectively to understand the distribution of each category
- Step 15: Added monthly revenue KPI with a goal of $7,000 in revenue each month indicating if any given month was successful in meeting said goal.
- Step 16: Added table consisting of Item, Price Per Unit, and Avg Price Per Unit to show fixed pricing model.
 
 # Dashboard Snapshot (Power BI Desktop)
![Image](https://github.com/user-attachments/assets/8520c98c-aa95-4ac8-bf56-9dccfb903389)

# Insights 
### [1] Relationship Between Total Revenue and Total Quantity Sold
![Image](https://github.com/user-attachments/assets/6453a728-cd4f-4004-812f-43df0d728440)

There is positive correlation between total revenue and total quantity sold, meaning when one variable moves in a positive/negative direction, the other variable will follow. For example, on a month-to-month basis from January to February, when total revenue decreased, total quantity decreased as well. Essentially, this means when we sell more units, our total revenue increases. The opposite holds true as well; when we sell less units, our total revenue decreases. To further analyze these two variables’ relationship, we can look at our pricing strategy by comparing our listed price per unit and our average price per unit.

### [2] Price Per Unit vs. Average Price Per Unit
![Image](https://github.com/user-attachments/assets/5d96fed2-68f3-494b-b62d-8a28ab22b877)

Price per unit is the price at which each individual unit is sold whereas average price per unit is the total revenue divided by the total quantity sold which accounts for variations in pricing such as discounts, promotions, or variable pricing. In this cafe’s business model, price per unit is the same as average price per unit, meaning that we sell all units at a static price and that there are no changes in pricing over time. This would explain the positive correlation between total revenue and total quantity sold. This fixed pricing structure is great for operational simplicity and removes decision fatigue; however, it heavily limits flexibility to increase average price per unit and thereby limits flexibility to increase revenue. Adjusting the business model to introduce premium options for certain items, price bundling, and a loyalty program could corroborate the increase in average price while assimilating to customers wants and needs. To understand how to optimize our business model, we can look at the following metrics and strategies:

### [3] Total Revenue Contribution
The total revenue contribution for each item from greatest to least is as follows:

![Image](https://github.com/user-attachments/assets/9a30193b-e3f1-4066-9f22-753a7e325010)

    Salad (21.49%)
	Sandwich (17.66%)
    Smoothie (15.90%)
    Juice (13.49%)
    Cake (12.47%)
    Coffee (8.88%)
    Tea (6.07%)
    Cookie (4.04%)

### [4] Total Quantity Sold Contribution 
The total quantity sold contribution for each item from greatest to least is as follows:

![Image](https://github.com/user-attachments/assets/93d6af44-b7b4-490e-b86e-8337d1ec1259)

    Juice (13.28%)
    Coffee (13.11%)
    Sandwich (13.04%)
    Salad (12.69%)
    Cake (12.28%)
    Tea (11.95%)
    Cookie (11.92%)
    Smoothie (11.74%)

## Optimizing Pricing Model
### Capitalizing On Best-Selling Items 
The best-selling items in terms of total revenue are salads, sandwiches, and smoothies. These items are perceived to be of the highest value by our customers, meaning that our customers are willing to pay more. To capitalize on these top performing items, we should focus marketing efforts on these items by emphasizing the health benefits to maximize profitability while introducing premium versions of these items with easy add-ons for a better-quality experience for our consumers. Some ideas for these premium variations of these items could potentially include “Super Salads” with protein added, “Healthwiches” with veggie options, or “Pumped Smoothies” with larger portions and organic fruit. By focusing on these best-selling items, we are ensuring that all efforts related to closing each individual sale are optimized efficiently.



### Improving Lower-Margin Items
On the other hand, cookie, tea, and coffee are higher-volume items that generate less revenue due to their lower price points. To encourage continued purchase of these items while increasing average transaction revenue, we will introduce strategic price adjustments items as well as bundling, carefully managing price elasticity and remaining competitive with the local market. Essentially, we should consider competitors’ prices, remain competitive with said prices, and understand COGS with respect to each item. 

### Price Modification
Regarding modifying price, I believe we should increase our prices for coffee, tea, and juice by 50% ($2 to $3, $1.50 to $2.25, and $3 to $4.50 respectively) and smoothies by 37% ($4 to $5.50) supported by the higher room of margin-of-error hypothesized by domain knowledge upon market rate COGS. These changes will allow the café to keep adapting to the constant change in the market by reinvesting and using higher quality ingredients in their recipes, this providing new values to customers. Additionally, these changes will be implemented gradually on an incremental scale to ensure a smooth transition for both customers and the business themselves. 

### Bundling Items
Regarding bundling items, I believe we should bundle coffees or teas with cookies as a morning bundle at 10% (bundle price of $2.75 or $3.60) from 6:00 AM to 11:00 AM and bundle juices with salads or sandwiches as a lunch bundle at 20% (bundle price of $7.60 or $6.80) from 11:00 AM to 2:00 PM. Both these bundles will serve as an incentive for customers to come during the peaks of breakfast and the decline of lunch, all while increasing average revenue per transaction.

### Loyalty Rewards and Discounts
![Image](https://github.com/user-attachments/assets/c638763d-c27c-4df1-8926-5a93f8858881)

To mitigate our price increases, keep our price elasticity stable, and reduce pushback from potential negative customer reactions, we can introduce a rewards system to increase customer loyalty, drive sales, and record demographic data from customers to then analyze for consumers behaviors. Given that each payment method of cash, credit card, and digital wallet are very evenly distributed at 33% each and the order type of in-store and takeaway are very evenly distributed at 50% each, we can be flexible. However, I believe this café should opt to do a digital points-based system where the customer logs every transaction with their phone number to accumulate points for every dollar spent. Points can then be redeemed for free items and discounts at the customers discretion with their specified payment method of choice. 

# Conclusion
This analysis of Café Sales 2023 extracted many actionable insights to further optimize pricing, enhance customer loyalty, and drive sustainable profit growth. By increasing the price per unit for coffee, juice, and smoothies, the café can drastically improve profit margins while staying competitive with the local market. Bundling items such as coffees or teas with cookies for the morning rush and juices with salads or sandwiches for the lunch cooldown immediately provides value for the customers as they will act as a catalyst in sales for lower-performing items such as cookies and tea. Both strategies align with our short-term goals of increasing average transaction value and increasing our monthly KPI goal from $7,000 to $10,000. Additionally, the introduction of a digital points-based system counters any potential negative reactions to the price increases by encouraging and rewarding loyal customers with free/discounted items. On the other hand, the program also addresses long term goals by providing stakeholders with valuable customer data such as name and phone number, allowing the analysis of customer behavior to extract actionable insights to then create personalized marketing efforts, optimized current menu offerings, adding to product line, and overall customer satisfaction. In summary, these recommendations foster an efficient yet effective way to optimize business operations. With these solutions, we project in the year 2024 that total revenue will increase about 30% in both total transactions and total revenue from 9,485 to 12,000 transactions and from $84,643 to $100,000. The café can balance immediate financial gains and long-term sustainable growth, proving to be a formidable competitor in the local market with quality food, beverages, and customer service. 
