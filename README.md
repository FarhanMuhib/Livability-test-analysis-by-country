# Livability-test-analysis-by-country

Country Livability Analysis Project
This project provides a comprehensive analysis of worldwide country data focusing on various metrics that contribute to a country's livability. The goal is to create a quantified livability score and sector scores using multiple socioeconomic and environmental indicators.

Project Overview
The analysis combines data on population, economic indicators, infrastructure, environmental quality, social development, health, and governance to assess and rank countries based on livability metrics. The project uses SQL for data processing and normalization and includes a detailed scoring methodology.

Data Description
countries_complete.csv: Contains raw country-level data including demographic, economic, environmental, health, literacy, unemployment, political, and social metrics.

country_status.csv: Processed scores for each country categorized into economics, quality of life, infrastructure, environment safety, social development, and governance freedom.

livability-score.csv: Final livability scores assigned to countries, ranking them on a livability scale.

country-analysis.sql: SQL script that creates the necessary database, imports data, normalizes values, calculates sector scores based on weighted metrics, and generates a final livability score and rankings.

Methodology
Economic Prosperity is assessed via GDP per capita and unemployment rate.

Quality of Life considers life expectancy and healthcare quality.

Infrastructure uses internet users and urbanization rate data.

Environmental Safety measures air quality and water quality.

Social Development accounts for literacy, religious diversity, and population density.

Governance Freedom scores political rights and civil liberties.

Each sector score is calculated by normalizing raw values against maximum observed values and applying specific weights. The final livability score is a weighted sum of these sector scores.

Visual Analysis
Power BI was used to create interactive and insightful visualizations of the data and livability scores. These visualizations help to explore trends, compare countries across different dimensions, and communicate findings effectively. The Power BI reports include dashboards for overall livability, sector-specific scores, and detailed country profiles.

Usage
Set up a SQL database and run the included country-analysis.sql script to create tables and views.

Import the CSV data files into the database.

Execute the SQL queries to compute sector and final livability scores.

Use Power BI to import the processed data for advanced visual exploration and reporting.

Use the resulting scores for visualization, reporting, or further analysis of country livability.

Project Insights
Country rankings provide a multi-dimensional view of livability and highlight strengths and weaknesses in governance, economy, environment, and social sectors.

Can serve as a basis for policy analysis, academic research, and comparative studies among countries.

Tools
SQL for database management and data analysis

CSV for data storage and sharing

Power BI for interactive visualizations and dashboards
