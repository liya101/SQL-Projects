SELECT *
FROM [Portfolio Project 1]..CovidDeaths
WHERE continent IS NOT  NULL
ORDER BY 3,4

--SELECT *
--FROM [Portfolio Project 1]..CovidVaccinations
--ORDER BY 3,4

--SELECT Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project 1]..CovidDeaths
WHERE continent IS NOT  NULL
ORDER BY 1,2

-- Looking at Total Cases Vs Total Deaths
-- Shows likelihood of dying if you contract covid in India
SELECT Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portfolio Project 1]..CovidDeaths
WHERE location like '%india%'AND  continent IS NOT  NULL 
ORDER BY 1,2


--Looking at Total Cases Vs Population
-- Shows what percentage of people got affected by Covid
SELECT Location, date, Population, total_cases,(Total_cases/Population)*100 AS PercentPopulationInfected
FROM [Portfolio Project 1]..CovidDeaths
WHERE location like '%India%' AND  continent IS  NOT NULL
ORDER BY 1,2


--Looking at Countries with Highest Infection Rate 

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((Total_cases/Population))*100 AS PercentPopulationInfected
FROM [Portfolio Project 1]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Population, Location
ORDER BY PercentPopulationInfected DESC


--Looking at Countries with Highest Death Count per Population

SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portfolio Project 1]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC


--Showing continents with Highest Death Count
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portfolio Project 1]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


--Global Numbers

SELECT SUM(new_cases)AS Total_cases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths,SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM [Portfolio Project 1]..CovidDeaths
WHERE continent IS NOT  NULL 
--GROUP BY date
ORDER BY 1,2


--Joining two tables

SELECT *
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccinations vac
ON  dea.location = vac.location AND 
    dea.date = vac.date

--Looking at Total Populatiob Vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition BY dea.Location ORDER BY dea.location, dea.date) AS CumulativeCountofVaccinated,
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccinations vac
ON  dea.location = vac.location AND 
    dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3















