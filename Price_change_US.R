library(tidyverse)
library(readxl)
library(devtools)
library(directlabels)
library(ggplot2)
library(gganimate)
library(gifski)
library(scales)

##Data Sources
#Meidan house price: https://fred.stlouisfed.org/series/MSPUS
##(Median Sales Price of Houses Sold for the United States)

#Mean tuition: https://nces.ed.gov/programs/digest/d19/tables/dt19_330.10.asp?current=yes
##(All institution, private/public, 2/4yrs; Average yearly total tuition, fees, room, board)

#Bacon, Coffee, Elec: https://www.bls.gov/cpi/data.htm

#Bacon
#Bacon, sliced, per lb. (453.6 gm) in U.S. city average, average price, not seasonally adjusted				
#U.S. city average

#Coffee Coffee, 
#100%, ground roast, all sizes, per lb. (453.6 gm) in U.S. city average, average price, not seasonally adjusted				
#U.S. city average

#Electricity 
#Electricity per KWH in U.S. city average, average price, not seasonally adjusted				
#U.S. city average


#Dow jones: http://www.1stock1.com/1stock1_139.htm
#Yearly ending price

#Income: https://www.census.gov/data/tables/time-series/demo/income-poverty/historical-income-households.html
##Census historical household income
##########################

#Coffee Coffee, 
#100%, ground roast, all sizes, per lb. (453.6 gm) in U.S. city average, average price, not seasonally adjusted				
#U.S. city average				

coffee <- read_excel("~/coffee.xlsx",skip = 9)
coffee$mean<-rowMeans(coffee[,c(2:13)],na.rm = TRUE)

coffee%>%
  arrange(Year)%>%
  filter(Year>=1980 & 2020>=Year)%>%
  select(Year,coffee=mean)->coffee_1

#2008 estimated by 05-06, 06-07, 09-10 changes -- 3.469*(1.083+1.065+0.982)/3 = 3.619
coffee_1<-rbind(c(2008,3.619),coffee_1)
coffee_1%>%
  arrange(Year)%>%
  mutate(cof_pct=100*(coffee/first(coffee))-100)%>%
  select(Year,cof_pct)->coffee_2


#Electricity 
#Electricity per KWH in U.S. city average, average price, not seasonally adjusted				
#U.S. city average
				
Elec <- read_excel("~/Elec.xlsx", skip = 9)
Elec$mean<-rowMeans(Elec[,c(2:13)],na.rm = TRUE)    
Elec%>%
  arrange(Year)%>%
  filter(Year>=1980 & 2020>=Year)%>%
  select(Year,Elec=mean)->Elec_1

Elec_1%>%
  arrange(Year)%>%
  mutate(Elec_pct=100*(Elec/first(Elec))-100)%>%
  select(Year,Elec_pct)->Elec_2
  

#Bacon
#Bacon, sliced, per lb. (453.6 gm) in U.S. city average, average price, not seasonally adjusted				
#U.S. city average
			
bacon <- read_excel("~/bacon.xlsx",skip = 9)
bacon$mean<-rowMeans(bacon[,c(2:13)],na.rm = TRUE)  
bacon%>%
  arrange(Year)%>%
  filter(Year>=1980 & 2020>=Year)%>%
  select(Year,bacon=mean)->bacon_1

bacon_1%>%
  arrange(Year)%>%
  mutate(bacon_pct=100*(bacon/first(bacon))-100)%>%
  select(Year,bacon_pct)->bacon_2

#The 19-20 tuition estimated by *1.02 to 18-19 data ("1.03" estimated from 
# previous annual growth from 2016-2019:mean(c(1.033,1.029,1.032,1.033))=1.032
# 24623*1.032=25410
tuition <- read_excel("~/tuition.xls")
tuition$Year<-as.numeric(substr(tuition$year,1,4))+1

tuition%>%
  arrange(Year)%>%
  filter(Year>=1980 & 2020>=year)%>%
  select(Year,tuition=cost)->tuition_1

tuition_1%>%
  arrange(Year)%>%
  mutate(tuition_pct=100*(tuition/first(tuition))-100)%>%
  select(Year,tuition_pct)->tuition_2


#Home price
Home_price <- read_csv("~/Home_price.csv")
Home_price%>%
  mutate(Year=as.numeric(substr(DATE,1,4)))%>%
  group_by(Year)%>%
  slice(n())%>%
  arrange(Year)%>%
  filter(Year>=1980 & 2020>=Year)%>%
  select(Year,home=MSPUS)->Home_price_1

Home_price_1%>%
  as.data.frame()%>%
  arrange(Year)%>%
  mutate(home_pct=100*(home/first(home))-100)%>%
  select(Year,home_pct)->Home_price_2


#Dow
#http://www.1stock1.com/1stock1_139.htm
#Yearly ending price
Dow_jones <- read_excel("~/Dow_jones.xlsx")

dow<-Dow_jones[,c(1,3)] #year and ending price
colnames(dow)<-c('Year','price')

dow%>%
  arrange(Year)%>%
  mutate(price=as.numeric(as.character.numeric_version(price)))%>%
  filter(Year>=1980 & 2020>=Year)->dow_1

dow_1%>%
  arrange(Year)%>%
  mutate(dow_pct=100*(price/first(price))-100)%>%
  select(Year,dow_pct)->dow_2


#Household Income
income <- read_excel("~/income.xlsx", skip = 5)
income<-income[c(1:44),c(1,3)]  #filter only US overall, and median unadj.
colnames(income)<-c('Year','income')
income$Year<-as.numeric(substr(income$Year,1,4))
income$income<-as.numeric(income$income)
income<-distinct(income,Year,.keep_all = TRUE)
#2020 estimated by previous 5 changes -- 68703*((1.087+1.033+1.036+1.045+1.053)/5) = 72193
income<-rbind(c(2020,72193),income)

income%>%
  arrange(Year)%>%
  filter(Year>=1980 & 2020>=Year)->income_1

income_1%>%
  arrange(Year)%>%
  mutate(income_pct=100*(income/first(income))-100)%>%
  select(Year,income_pct)->income_2


##merge tables
lapply(c(coffee_2,Elec_2,bacon_2,tuition_2,Home_price_2,dow_2,income_2),NROW)
cbind.data.frame(coffee_2,Elec_2,bacon_2,tuition_2,Home_price_2,dow_2,income_2)->price_change
price_change%>%
  select(1,cof_pct,Elec_pct,bacon_pct,tuition_pct,home_pct,dow_pct,income_pct)%>% 
  pivot_longer(cols = -c(Year),values_to = 'price_pct',names_to='cate')%>%
  #convert Year to date, use integer in trans_reveal
  mutate(Year = as.Date.character(Year, "%Y"),
         type=ifelse(cate=='cof_pct','Coffee',
                     ifelse(cate=='Elec_pct','Electricity',
                            ifelse(cate=='bacon_pct','Bacon',
                                   ifelse(cate=='tuition_pct','College Tuition',
                                          ifelse(cate=='home_pct','House',
                                                 ifelse(cate=='dow_pct','Dow Jones',
                                                        ifelse(cate=='income_pct','Household Income',NA))))))))->price_change_1

View(price_change_1)

library(RColorBrewer)
myColors <- brewer.pal(8,"Accent")

price_change_1%>%
  ggplot(aes(x =Year, y=price_pct))+
  geom_line(aes(color=type),size=1,key_glyph = "timeseries")+
  geom_dl(aes(label=paste0(type,': ',scales::comma(round(price_pct,0)),'%'),group=type,color=type),
         method=list('last.bumpup',hjust=0,cex=1))+
  scale_y_continuous(labels = scales::comma)+
  scale_x_date(date_labels = '%Y') +
  scale_color_manual(values = myColors)+
  coord_cartesian(clip='off')+
  labs(subtitle = '(%) Price Change from 1980 in the U.S.)',
       x=NULL,y=NULL)+
  theme(plot.margin = unit(c(1,5,1,1.5),units = 'cm'),
        panel.border = element_blank(),
        text=element_text(size=15),
        axis.line = element_line(color = 'white'),
        axis.text = element_text(color = 'white'),
        axis.text.x = element_text(angle = 45,vjust=1,hjust = 1),
        title = element_text(color = 'white'),
        legend.title = element_blank(),
        legend.position = 'bottom',
        legend.background = element_blank(),
        legend.key = element_blank(),
        legend.text = element_text(color = 'white'),
        panel.grid = element_blank(),
        plot.title.position = "plot",
        plot.background = element_rect(fill = 'black'),
        panel.background = element_rect(fill = 'black'))+
  transition_reveal(Year)+
  view_follow(fixed_y = c(-100,NA))->price_anim


animate(price_anim,duration = 40, fps = 10, end_pause =80,
        height=600,width=800, res=100,renderer = gifski_renderer())



