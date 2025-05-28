WITH first_query AS (
	SELECT
		i.industry
		,count(*) AS count_of_companies
	FROM industries AS i
	JOIN dates AS d
	USING(company_id)
	WHERE EXTRACT(year FROM d.date_joined) IN (2019, 2020, 2021)
	GROUP BY industry
	ORDER BY count_of_companies DESC
	LIMIT 3
),

second_query AS (
	SELECT
		COUNT(*) AS num_unicorns
		,i.industry AS industry
		,EXTRACT(year FROM d.date_joined) AS year
		,AVG(f.valuation) AS valuation
	FROM industries AS i
	JOIN dates AS d
	USING(company_id)
	JOIN funding AS f
	USING(company_id)
	WHERE EXTRACT(year FROM d.date_joined) IN (2019, 2020, 2021)
	GROUP BY industry, year
)

SELECT
	industry
	,year
	,num_unicorns
	,round(AVG(valuation) / 1000000000, 2) AS average_valuation_billions
FROM first_query
JOIN second_query
USING(industry)
GROUP BY industry, year, num_unicorns
ORDER BY year DESC, num_unicorns DESC;