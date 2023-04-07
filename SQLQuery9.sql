--select * from [Practice]..CovidDeaths$;

--select * from [Practice]..COVIDVACCS$
--order by 3,4

select location, date, new_cases, total_cases, total_deaths, population
from [Practice]..CovidDeaths$
where continent is not null
order by 1,2


-- Comparing the Total Cases to Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as percentage_deaths
from [Practice]..CovidDeaths$
where continent is not null
order by 1,2

--Now comparing the Total Cases to the Population

-- Showing the percentage of population infected in Africa

select location, date, population, total_cases, (total_cases/population) * 100 as population_infection_prctg
from [Practice]..CovidDeaths$
where continent is not null
order by 1,2


-- Now observing countries with highest date rates compared to infection

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulatonInfected
from [Practice]..CovidDeaths$
where continent is not null
group by population, location
order by PercentPopulatonInfected desc


--Now showing countries with the highest death count per population

select location, population, MAX(cast(total_deaths as int)) as HighestDeaths, MAX((total_deaths/population)) * 100 as TotalDeathsPerPopulation
from [Practice]..CovidDeaths$
where continent is not null
group by population, location
order by HighestDeaths desc

--ORDERING THE REPORT BY CONTINENT



--Showing Continents with highest death count per population

select continent, MAX(cast(total_deaths as int)) as HighestDeaths
from [Practice]..CovidDeaths$
where continent is not null
group by continent
order by HighestDeaths desc

--Global numbers


select date, SUM(new_cases) total_cases, SUM(cast(new_deaths as int)) total_deaths, SUM(cast(new_deaths as int))/SUM (new_cases)*100 as DeathPercentage
from [Practice]..CovidDeaths$
where continent is not null
group by date
order by 1,2

--Looking at the table for COVID VACCINATIONS
-- First, looking at everything within the data to get a feel

select dea.continent, dea.location, dea.date, dea.population, vaccs.new_vaccinations
from [Practice].[dbo].[CovidDeaths$] as dea
JOIN [Practice].[dbo].[COVIDVACCS$] as vaccs
	on dea.location = vaccs.location
	and dea.date = vaccs.date
where dea.continent is not null
order by 1,2,3

---Total Populations vs Vaccinations now 
as population_infection_prctg
-- Attempting the above, using a temp table

drop table if exists #PercentPopulationVaxxed2
create table #PercentPopulationVaxxed2 
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
aggregatingPeopleVaxed numeric
)

insert into #PercentPopulationVaxxed2
select dea.continent, dea.location, dea.date, dea.population, vaccs.new_vaccinations, 
sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as aggregatingPeopleVaxed 
from [Practice].[dbo].[CovidDeaths$] as dea
JOIN [Practice].[dbo].[COVIDVACCS$] as vaccs
	on dea.location = vaccs.location
	and dea.date = vaccs.date
where dea.continent is not null


select *, (aggregatingPeopleVaxed/population) * 100 as percentagevalue
from #PercentPopulationVaxxed2
order by 2,3

--Creating view to store data for later visualisations



create view HighestDeaths as
select continent, MAX(cast(total_deaths as int)) as HighestDeaths
from [Practice]..CovidDeaths$
where continent is not null
group by continent
--order by HighestDeaths desc

