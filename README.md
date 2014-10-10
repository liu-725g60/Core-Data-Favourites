Core-Data-Favourites
====================
Den här uppgiften bygger vidare på labbskelettet med länksamlingen från labb 4. Allt gränsnitt är inlagt och det finns numera även en vy för att lägga till nya länkar. Ert uppdrag är dels att populera länktabellen med länkar från en Core Data-databas och dels att spara nya länkar i databasen. Allt grundarbete för att sätta upp Core Data är färdigt i app-delegaten.

Ert första jobb blir att sätta upp en entitet för en länk i modellfilen (Favourites.xcdatamodel). Det finns redan en Link-klass klar så se till att matcha namnen på attributen i er entitet till propertynamnen i klassen. Kom även ihåg att ange Link som klassen som representerar er entitet i modellfilen.

För att förbereda ytterligare får ni med en hjälpklass som baseras på XCode's Master/Detail projektmall med Core Data. Den heter MDMFetchedResultsTableDataSource och är en hjälpklass som använder en NSFetchedResultsController för att hantera data i tabellen. Det ni behöver göra för att slutföra jobbet är att överlagra två metoder i MasterViewController. En för att skapa själva NSFetchedResultsControllern och en för att koppla data från ett Link-objekt till en cell i tabellen. Leta efter kompilatorvarningarna i filen.

Slutligen ska ni även överlagra didPressSave i NewLinkTableViewController och där lägga in ett nytt Link-objek till databasen. Observera att NSFetchedResultsControllern i länk-tabellen automatiskt känner av när ett nytt objekt har lagts till i databasen och då uppdaterar tabellen. Ni behöver alltså inte manuellt lägga in en ny rad i tabellen som ni gjorde tidigare i labb 4.
