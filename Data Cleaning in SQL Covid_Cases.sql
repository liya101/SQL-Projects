
--Here Covid Cases in 2020 is explored in SQL using CTE, TEMP TABLES, JOIN


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

--Looking at Total Population Vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project 1]..CovidDeaths dea
Join [Portfolio Project 1]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--CTE


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [Portfolio Project 1]..CovidDeaths dea
Join [Portfolio Project 1]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project 1]..CovidDeaths dea
Join [Portfolio Project 1]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Creating view to Store data for visualisations

CREATE VIEW PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From [Portfolio Project 1]..CovidDeaths dea
Join [Portfolio Project 1]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

SELECT *
FROM PercentPopulationVaccinated






