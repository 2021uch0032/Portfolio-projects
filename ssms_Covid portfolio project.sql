SELECT *
FROM [Portfolio Project]..CovidDeaths
ORDER BY 3,4

SELECT Location, Date, Total_cases, New_cases,Total_deaths,Population
FROM [Portfolio Project]..CovidDeaths
ORDER BY 1,2

--Total Cases vs total deaths--
--likelihood to die in india--
SELECT Location, Date, Total_cases,Total_deaths,(total_deaths/Total_cases)*100 as Death_percent
FROM [Portfolio Project]..CovidDeaths
where location like '%India%'
ORDER BY 1,2

--Looking at total cases vs population--
SELECT Location, Date, Total_cases,population,(Total_cases/population)*100 as Affected_percentage
FROM [Portfolio Project]..CovidDeaths
where location like '%India%'
ORDER BY 1,2

--Looking at countries with highest infection rate with population--
 
 select location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as Percent_of_population_infected 
 From [Portfolio Project]..CovidDeaths
 Group by Location,population
 ORDER BY Percent_of_population_infected desc 

 -- No. of people actually died--

 select location,MAX(cast(total_deaths as int)) as total_death_Count
 From [Portfolio Project]..CovidDeaths
 where continent is not null
 Group by Location
 ORDER BY total_death_Count desc 

 --In terms of continent--
 
 select location,MAX(cast(total_deaths as int)) as total_death_Count
 From [Portfolio Project]..CovidDeaths
 where continent is null
 Group by Location
 ORDER BY total_death_Count desc 

 --Global Nos.--
 select date,sum(new_cases) as Total_cases,sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as percent_of_deaths  
 From [Portfolio Project]..CovidDeaths
 where continent is not null
 Group by date
 ORDER BY 1,2
---------------------------------------
 select sum(new_cases) as Total_cases,sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as percent_of_deaths  
 From [Portfolio Project]..CovidDeaths
 where continent is not null
 ORDER BY 1,2

 SELECT *
FROM [Portfolio Project]..CovidVaccinations
ORDER BY 3,4


--combining both tables and finding insights--
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as cummulative_number,
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
 where dea.continent is not null
 ORDER BY 2,3

-- Using CTE
------------------------------------------------------------------------
with PopvsVac (Continent, Location,Date,Population,New_vaccinations, people_vaccinated)
 as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as people_vaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
 where dea.continent is not null
 --ORDER BY 2,3
 )
 select *
 From PopvsVac

 --Create view to store data for visualizations--
Create VIEW Percent_population_vaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as people_vaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
 where dea.continent is not null
 --ORDER BY 2,3
 
 select *
 from Percent_population_vaccinated