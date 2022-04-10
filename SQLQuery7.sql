--select data that we are going to be using
select location, date, total_cases, new_cases, total_deaths, population
from dbo.Covid_Deaths
where continent is not null
order by 1,2

--Looking at total cases vs total deaths
--Shows the likelihood of death if you contract covid in your country

select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from dbo.Covid_Deaths
where location='India'
and continent is not null
order by 1,2

--Looking at Total cases vs Population
--Shows what percentage of population got covid

select location, date, population, total_cases,  (total_deaths/population) as PercentPopulationInfected
from dbo.Covid_Deaths
where location='India'
and continent is not null
order by 1,2

--–Looking at countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestInfectionCount,  max((total_cases/population)*100) as PercentPopulationInfected
from dbo.Covid_Deaths
--where location='India'
where continent is not null
group by location, population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from dbo.Covid_Deaths
--where location='India'
where continent is not null
group by location
order by TotalDeathCount desc

--Showing Continent with Highest Death Count per Population
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from dbo.Covid_Deaths
--where location='India'
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers
select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from dbo.Covid_Deaths
--where location='India'
where continent is not null
--group by date
order by 1,2

--Join two tables on location and date
select * from dbo.Covid_Deaths as dea
join dbo.Covid_Vaccinations as vac
on dea.location=vac.location
and dea.date=vac.date

--Looking at Total Population vs vaccinations
--use CTE
with PopsVac(Continent, Location, Date, Population, New_vaccinations, CumulativePeopleVaccinated)
as 
(
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as CumulativePeopleVaccinated
from dbo.Covid_Deaths as dea
join dbo.Covid_Vaccinations as vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
 select *,(CumulativePeopleVaccinated/Population)*100
 From PopsVac





--For Tableau Visualizations
select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from dbo.Covid_Deaths
--where location='India'
where continent is not null
--group by date
order by 1,2

select location, sum(cast(new_deaths as int)) as TotalDeathcount
from Covid_Deaths
where continent is null
and location not in ('World', 'European Union', 'International','Upper middle income','High income','Lower middle income','Low income')
group by location
order by TotalDeathcount desc

select location, population, max(total_cases) as HigehestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
from Covid_Deaths
group by location, population
order by PercentPopulationInfected desc

select location,population,date, max(total_cases) as HigehestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
from Covid_Deaths
group by location, population, date
order by PercentPopulationInfected desc