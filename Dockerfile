FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

LABEL maintainer="Badger 2-3"
LABEL repository="https://github.com/jbraunsmajr/contributiongraph"

# label as github action
LABEL com.github.actions.name = "Generate Contribution Graph"
LABEL com.github.actions.description = "Uses your PAT to generate a contribution graph that you can use for your profile"
LABEL com.github.actions.icon = "sliders"
LABEL com.github.actions.color = "purple"

RUN apt-get update && apt-get install -y libx11-6 libx11-xcb1 libatk1.0-0 libgtk-3-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libpango-1.0-0 libcairo2 libasound2 libxshmfence1 libnss3

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Github.Actions.ContributionGraph/Github.Actions.ContributionGraph.csproj", "Github.Actions.ContributionGraph/"]
RUN dotnet restore "Github.Actions.ContributionGraph/Github.Actions.ContributionGraph.csproj"
COPY . .

WORKDIR "/src/Github.Actions.ContributionGraph"
RUN dotnet build "Github.Actions.ContributionGraph.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Github.Actions.ContributionGraph.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "/app/Github.Actions.ContributionGraph.dll"]
