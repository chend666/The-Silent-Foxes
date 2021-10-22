
## Data Exploration

### Getting Started
#### To run Tableau
We've saved our charts in a Tableau workbook. As long as you have the CPDP database on your computer, it should run without an issue. Double click on the .twb (or .twbx) file to open the workbook in Tableau. You may be prompted to enter your password for the 'postgres' user. The descriptions below correspond to the tabs at the bottom left of the workbook.

### Our Questions
### Q1
Is there a correlation between the salary of the officer and the number of complaints?
--A line chart showing the trend of annual allegation count over years by running:
```
Open Q1.twb with Tableau, and connect to database CPDB, 
a table called 'Allegation Annual Count' shows how total number of allegations received by officers changes over year
```

### Q2
Is there a correlation between the number of allegations received before an officer’s first settlement case and number of allegations received after?

