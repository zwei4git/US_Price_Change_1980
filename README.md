# US_Price_Change_1980
### Prices Change of Selected Items in the U.S. from 1980

## Data Sources
### All in current dollars without adjustment for inflation
Median house price: https://fred.stlouisfed.org/series/MSPUS
(Median Sales Price of Houses Sold for the United States)

Mean tuition: https://nces.ed.gov/programs/digest/d19/tables/dt19_330.10.asp?current=yes
(All institution: private/public, 2/4yrs; Average yearly total tuition + fees + room + board)
(The 19-20 tuition estimated by multiply 1.03 to 18-19 data. "1.03" estimated from previous annual growth from 2016-2019: mean(c(1.033,1.029,1.032,1.033))=1.032,
1.032*24623=25410) 

Bacon, Coffee, Elec: https://www.bls.gov/cpi/data.htm (U.S. city average)

#Bacon - Bacon, sliced, per lb. (453.6 gm) in U.S. city average, average price, not seasonally adjusted				

#Coffee - Coffee, 100%, ground roast, all sizes, per lb. (453.6 gm) in U.S. city average, average price, not seasonally adjusted				
(2008 no data, estimated by average 05-06, 06-07, 09-10 changes -- 3.469*(1.083+1.065+0.982)/3 = 3.619)

#Electricity - Electricity per KWH in U.S. city average, average price, not seasonally adjusted				

Dow jones: http://www.1stock1.com/1stock1_139.htm (Yearly ending price)

Income: https://www.census.gov/data/tables/time-series/demo/income-poverty/historical-income-households.html 
(Census historical household income)
(2020 estimated by previous 5 changes -- 68703*((1.087+1.033+1.036+1.045+1.053)/5) = 72193)


## Tools: Animation made with gganimate package in RStudio
