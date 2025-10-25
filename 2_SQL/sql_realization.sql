/* Тема 2. Базові функції SQL

1. Напиши SQL-запит, що вибере з таблиці  facebook_ads_basic_daily наступні дані:

ad_date — дата показу реклами;
campaign_id — унікальний ідентифікатор кампанії;
агреговані за датою та id кампанії значення для наступних показників:
загальна сума витрат
кількість показів
кількість кліків
загальний Value конверсій
2. Використовуючи агреговані показники витрат та конверсій, розрахуй для кожної дати та id кампанії такі метрики:

CPC, CPM, CTR, ROMI

Для виконання цього завдання згрупуй таблицю за полями ad_date та campaign_id.
*/

SELECT
		ad_date,
		campaign_id,
		SUM(spend) total_spend,
		SUM(clicks) total_clicks,
		SUM(value) total_value,
		ROUND((SUM(spend) ::numeric / NULLIF(SUM(impressions),0) * 1000), 2) CPM,
		ROUND(SUM(spend) / NULLIF(SUM(clicks), 0), 2) CPC,
		CONCAT(ROUND(SUM(clicks) ::numeric / NULLIF(SUM(impressions), 0) * 100, 2), '%') CTR,
		CONCAT(ROUND((SUM(value) ::numeric - SUM(spend)::numeric) / NULLIF(SUM(spend), 0) * 100, 2), '%')  ROMI
FROM facebook_ads_basic_daily
GROUP BY ad_date, campaign_id
ORDER BY ad_date;


/* Додаткове завдання до Теми 2:

Серед кампаній з загальною сумою витрат більше 500 000 в таблиці facebook_ads_basic_daily 
знайди кампанію з найвищим ROMI.
*/


SELECT
		campaign_id,
		concat(round((sum(value)::numeric - sum(spend)::numeric) / nullif(sum(spend), 0) * 100, 2), '%') ROMI
FROM facebook_ads_basic_daily
GROUP BY campaign_id
HAVING sum(spend) > 500000
ORDER BY ROMI DESC
LIMIT 1