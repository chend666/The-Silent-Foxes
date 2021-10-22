
## Data Exploration

### Getting Started
#### To run Tableau
We've saved our charts in a Tableau workbook. As long as you have the CPDP database on your computer, it should run without an issue. Double click on the .twb (or .twbx) file to open the workbook in Tableau. You may be prompted to enter your password for the 'postgres' user. The descriptions below correspond to the tabs at the bottom left of the workbook.

### Our Questions
### Q1
Is there a correlation between the salary of the officer and the number of complaints?

-- A line chart showing the trend of annual allegation count over years by running:
```
Open Q1.twb with Tableau, and connect to database CPDB, 
a table called 'Allegation Annual Count' shows how total number of allegations received by officers changes over years
```
-- A line chart showing the trend of annual average salary over years
```
Open Q1.twb with Tableau,
a table called 'Average Annual Salary' shows how average salary of officers changes over years
```
-- A double-line chart combined both two charts above
```
Open Q1_A_S.twb with Tableau,
a table called <Annual Allegation Count & Average Salary> we use to compare the trend of annual salary with the allegation count over years
```
-- A side-by-side bar chart for comparison
```
a table called 'compare Average Salary & Allegation Count' for same observation as above chart
```

### Q2
Is there a correlation between the number of allegations received before an officer’s first settlement case and number of allegations received after?

