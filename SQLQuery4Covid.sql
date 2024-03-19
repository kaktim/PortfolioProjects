

select *
from [PortfolioProject].[dbo].[CovidDeaths$]
where continent is not null
order by 3,4

--select *
--from [PortfolioProject].[dbo].[Covid19Vaccinations$]
--order by 3,4

--Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from [PortfolioProject].[dbo].[CovidDeaths$]
where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 
as DeathPercentage
from [PortfolioProject].[dbo].[CovidDeaths$]
where location like '%states%'
and continent is not null
order by 1,2

--Looking at Total Cases vs Population

select location, date, population, total_cases, (total_cases/population)*100 
as PercentPopulationInfected
from [PortfolioProject].[dbo].[CovidDeaths$]
--where location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

select location, population, max(total_cases) as HighestInfectionCount, 
max(total_cases/population)*100 as PercentPopulationInfected
from [PortfolioProject].[dbo].[CovidDeaths$]
--where location like '%states%'
group by location, population
order by PercentPopulationInfected desc

--Showing Countries with the Highest Death Count Per Population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject].[dbo].[CovidDeaths$]
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc

--Lets Break Things Down By Continent

select location, max(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject].[dbo].[CovidDeaths$]
--where location like '%states%'
where continent is null
group by location
order by TotalDeathCount desc

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject].[dbo].[CovidDeaths$]
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Showing Continent with the Highest Death Count Per Population

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject].[dbo].[CovidDeaths$]
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [PortfolioProject].[dbo].[CovidDeaths$]
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

--Looking at Total Population vs Vaccinations

with PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [PortfolioProject].[dbo].[CovidDeaths$] dea
join [PortfolioProject].[dbo].[Covid19Vaccinations$] vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


--USE CTE

with PopvsVac
as

--Temp Table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [PortfolioProject].[dbo].[CovidDeaths$] dea
join [PortfolioProject].[dbo].[Covid19Vaccinations$] vac
   on dea.location = vac.location
   and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating View to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [PortfolioProject].[dbo].[CovidDeaths$] dea
join [PortfolioProject].[dbo].[Covid19Vaccinations$] vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated























