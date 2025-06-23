
SELECT 
  Store_ID,
  SUM(Total_Visits) AS Total_Visits,
  SUM(Transactions) AS Total_Transactions,
  ROUND(SUM(Transactions) * 1.0 / NULLIF(SUM(Total_Visits), 0), 4) AS Store_Conversion_Rate
FROM store_sku_ba_dataset
GROUP BY Store_ID;

SELECT 
  SKU_ID,
  SUM(Total_Visits) AS Total_Visits,
  SUM(Transactions) AS Total_Transactions,
  ROUND(SUM(Transactions) * 1.0 / NULLIF(SUM(Total_Visits), 0), 4) AS SKU_Conversion_Rate
FROM store_sku_ba_dataset
GROUP BY SKU_ID;

SELECT TOP 5
		Store_ID, 
       ROUND(SUM(Transactions) * 1.0 / NULLIF(SUM(Total_Visits), 0), 4) AS Store_Conversion_Rate
FROM store_sku_ba_dataset
GROUP BY Store_ID
ORDER BY Store_Conversion_Rate DESC;

SELECT TOP 5
    Store_ID,
    ROUND(SUM(CAST(Transactions AS FLOAT)) / NULLIF(SUM(Total_Visits), 0), 4) AS Store_Conversion_Rate
FROM store_sku_ba_dataset
GROUP BY Store_ID
ORDER BY Store_Conversion_Rate ASC;

SELECT TOP 5
    SKU_ID,
    ROUND(SUM(CAST(Transactions AS FLOAT)) / NULLIF(SUM(Total_Visits), 0), 4) AS SKU_Conversion_Rate
FROM store_sku_ba_dataset
GROUP BY SKU_ID
ORDER BY SKU_Conversion_Rate DESC;

SELECT TOP 5
    SKU_ID,
    ROUND(SUM(CAST(Transactions AS FLOAT)) / NULLIF(SUM(Total_Visits), 0), 4) AS SKU_Conversion_Rate
FROM store_sku_ba_dataset
GROUP BY SKU_ID
ORDER BY SKU_Conversion_Rate ASC;

-- Select Top 5 Stores by Conversion Rate
WITH TopStores AS (
    SELECT TOP 5 
		   Store_ID,
           SUM(Total_Visits) AS Total_Visits,
           SUM(Transactions) AS Total_Transactions,
           ROUND(1.0 * SUM(Transactions) / NULLIF(SUM(Total_Visits), 0), 4) AS Conversion_Rate
    FROM store_sku_ba_dataset
    GROUP BY Store_ID
    ORDER BY Conversion_Rate DESC
)

-- Select Top 5 SKUs by Conversion Rate
, TopSKUs AS (
    SELECT TOP 5
		   SKU_ID,
           SUM(Total_Visits) AS Total_Visits,
           SUM(Transactions) AS Total_Transactions,
           ROUND(1.0 * SUM(Transactions) / NULLIF(SUM(Total_Visits), 0), 4) AS Conversion_Rate
    FROM store_sku_ba_dataset
    GROUP BY SKU_ID
    ORDER BY Conversion_Rate DESC
)

-- Join and create heatmap data
SELECT s.Store_ID, 
       s.SKU_ID, 
       ROUND(1.0 * SUM(s.Transactions) / NULLIF(SUM(s.Total_Visits), 0), 4) AS Store_Sku_Conversion
FROM store_sku_ba_dataset s
JOIN TopStores TS ON s.Store_ID = TS.Store_ID
JOIN TopSKUs SK ON s.SKU_ID = SK.SKU_ID
GROUP BY s.Store_ID, s.SKU_ID
ORDER BY Store_Sku_Conversion DESC;
