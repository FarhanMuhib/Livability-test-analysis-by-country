CREATE DATABASE IF NOT EXISTS country_status;
USE country_status;

SELECT * FROM country_status.countries_complete;

DROP TABLE countries_complete;
insert into country_status.countries_complete 
(country_id, country_name, population,	population_density_per_square_km,	urbanization_Rate,	air_quality_index,	water_quality_index,	internet_users,	healthcare_quality_index,	life_expectancy,	literacy_rate,	unemployment_rate,	gdp_per_capita,	religious_diversity_index,	political_rights_rating,	civil_liberties_rating)
values
(41,'Ivory Coast',32711547,100.92,53.6,60,83,12800000,31.2,61.94,89.9,2.29,2390.75,1.4,1,1);

SELECT * FROM country_status.countries_complete
order by country_id asc;
drop table normalization_params;

SELECT 
    country_name,

    -- Final weighted livability score rounded to 2 decimals
    ROUND(
        
        -- Economic Prosperity (20%: GDP 12%, Unemployment 8%)
        (
            (gdp_per_capita / (SELECT MAX(gdp_per_capita) FROM countries_complete)) * 100 * 0.12 +
            (1 - unemployment_rate / (SELECT MAX(unemployment_rate) FROM countries_complete)) * 100 * 0.08
        ) +

        -- Quality of Life (20%: Life Expectancy 12%, Healthcare Quality 8%)
        (
            (life_expectancy / (SELECT MAX(life_expectancy) FROM countries_complete)) * 100 * 0.12 +
            (healthcare_quality_index / (SELECT MAX(healthcare_quality_index) FROM countries_complete)) * 100 * 0.08
        ) +

        -- Infrastructure (15%: Internet Users 10%, Urbanization Rate 5%)
        (
            LEAST(100, (internet_users / population) * 100 * 1.25) * 0.10 +
            (urbanization_Rate / (SELECT MAX(urbanization_Rate) FROM countries_complete)) * 100 * 0.05
        ) +

        -- Environment & Safety (15%: Water Quality 7.5%, Air Quality 7.05%)
        (
            (water_quality_index / (SELECT MAX(water_quality_index) FROM countries_complete)) * 100 * 0.075 +
            (1 - air_quality_index / (SELECT MAX(air_quality_index) FROM countries_complete)) * 100 * 0.0705
        ) +

        -- Social Development (20%: Literacy 10%, Religious Diversity 8%, Population Density 2%)
        (
            (literacy_rate / (SELECT MAX(literacy_rate) FROM countries_complete)) * 100 * 0.10 +
            (religious_diversity_index / (SELECT MAX(religious_diversity_index) FROM countries_complete)) * 100 * 0.08 +
            CASE
                WHEN population_density_per_square_km BETWEEN 50 AND 300 THEN 100 * 0.02
                WHEN population_density_per_square_km < 50 THEN (population_density_per_square_km / 50) * 100 * 0.02
                ELSE GREATEST(25, 100 - ((population_density_per_square_km - 300) / 500) * 75) * 0.02
            END
        ) +

        -- Governance & Freedom (10%: Political Rights 5%, Civil Liberties 5%) (lower rating is better)
        (
            (1 - political_rights_rating / (SELECT MAX(political_rights_rating) FROM countries_complete)) * 100 * 0.05 +
            (1 - civil_liberties_rating / (SELECT MAX(civil_liberties_rating) FROM countries_complete)) * 100 * 0.05
        )

    , 2) AS livability_score

FROM countries_complete

ORDER BY livability_score DESC 
LIMIT 100;


CREATE OR REPLACE VIEW country_status.country_sector_scores AS
WITH max_values AS (
    SELECT
        MAX(gdp_per_capita) AS max_gdp,
        MAX(unemployment_rate) AS max_unemp,
        MAX(life_expectancy) AS max_life,
        MAX(healthcare_quality_index) AS max_health,
        MAX(urbanization_rate) AS max_urban,
        MAX(water_quality_index) AS max_water,
        MAX(air_quality_index) AS max_air,
        MAX(literacy_rate) AS max_lit,
        MAX(religious_diversity_index) AS max_relig,
        MAX(political_rights_rating) AS max_rights,
        MAX(civil_liberties_rating) AS max_lib
    FROM country_status.countries_complete
)
SELECT 
    c.country_name,
    ROUND((
        (c.gdp_per_capita / m.max_gdp) * 100 * 0.6 +
        (1 - c.unemployment_rate / m.max_unemp) * 100 * 0.4
    ), 2) AS economic_score,
    ROUND((
        (c.life_expectancy / m.max_life) * 100 * 0.6 +
        (c.healthcare_quality_index / m.max_health) * 100 * 0.4
    ), 2) AS quality_of_life_score,
    ROUND((
        LEAST(100, (c.internet_users / NULLIF(c.population, 0)) * 100 * 1.25) * 0.67 +
        (c.urbanization_rate / m.max_urban) * 100 * 0.33
    ), 2) AS infrastructure_score,
    ROUND((
        (c.water_quality_index / m.max_water) * 100 * 0.515 +
        (1 - c.air_quality_index / m.max_air) * 100 * 0.485
    ), 2) AS environment_safety_score,
    ROUND((
        (c.literacy_rate / m.max_lit) * 100 * 0.5 +
        (c.religious_diversity_index / m.max_relig) * 100 * 0.4 +
        CASE
            WHEN c.population_density_per_square_km BETWEEN 50 AND 300 THEN 100 * 0.1
            WHEN c.population_density_per_square_km < 50 THEN (c.population_density_per_square_km / 50) * 100 * 0.1
            ELSE GREATEST(25, 100 - ((c.population_density_per_square_km - 300) / 500) * 75) * 0.1
        END
    ), 2) AS social_development_score,
    ROUND((
        (1 - c.political_rights_rating / m.max_rights) * 100 * 0.5 +
        (1 - c.civil_liberties_rating / m.max_lib) * 100 * 0.5
    ), 2) AS governance_freedom_score
FROM country_status.countries_complete c
CROSS JOIN max_values m;


SELECT country_name, economic_score
FROM country_status.country_sector_scores
ORDER BY economic_score DESC
LIMIT 10;

SELECT country_name, quality_of_life_score
FROM country_status.country_sector_scores
ORDER BY quality_of_life_score DESC
LIMIT 10;

SELECT country_name, infrastructure_score
FROM country_status.country_sector_scores
ORDER BY infrastructure_score DESC
LIMIT 10;

SELECT country_name, environment_safety_score
FROM country_status.country_sector_scores
ORDER BY environment_safety_score DESC
LIMIT 10;

SELECT country_name, social_development_score
FROM country_status.country_sector_scores
ORDER BY social_development_score DESC
LIMIT 10;

SELECT country_name, governance_freedom_score
FROM country_status.country_sector_scores
ORDER BY governance_freedom_score DESC
LIMIT 10;



