####################### Microdata-Unemployment ###########################


rm(list=ls(all=TRUE))
install.packages('PNADcIBGE')
install.packages('survey')
install.packages('convey')
library(PNADcIBGE)
library(survey)
library(convey)

#Selecting the desired variables from the survey

variaveis<-c('UF','Capital','RM_RIDE', 'VD4001', "VD4002", 'VD4004A')

#Colecting the data
pnadcbr<-get_pnadc(year=2024,quarter=3,vars=variaveis)

##Downloading it, for the environment to become less crowded
pnadcbr<-readRDS('C:/Users/nunes/rsetwd/pnadc3tri24.rds')

#Calculating brazil's unemployment rate
txdbr<-svyratio(~VD4002=="Pessoas desocupadas",
                ~VD4001=='Pessoas na força de trabalho', pnadcbr, na.rm=T)

txdbr
#Calculating the unemployment rate in the state of Pernambuco

pnadcpe<- subset(pnadcbr, UF=='Pernambuco')
txdpe<-svyratio(~VD4002=='Pessoas desocupadas',
                ~VD4001=='Pessoas na força de trabalho', pnadcpe, na.rm=T)

txdpe

#unemployment rate in the metropolitan region of recife
pnadcrmrec<-subset(pnadcpe, RM_RIDE=='Região Metropolitana de Recife (PE)')

txdrmrec<-svyratio(~VD4002=='Pessoas desocupadas',
                   ~VD4001=='Pessoas na força de trabalho', pnadcrmrec,na.rm=T)
txdrmrec

############# Microdata- Exploring other information available on the PNADc ####################
variaveis_selecionadas<- c('UF', 'Capital','RM_RIDE','V2007','V2009', 'V2010',
                           "VD3004", "VD4001", "VD4002", "VD4004A", 
                           "VD4005", "VD4010","VD4012", "VD4020")
### V2007 = (1=Men 2=woman)
### V2009 = Age.
### V2010 = Color or race.
### VD3004 = level of education.
### VD4001 = Employment status.
### VD4002 = Occupation condition

### VD4005 = Unemployed people who are not actively seeking work
### VD4010 = Industry classification
### VD4012 = Social security contribution (1 = contributor; 2 = non-contributor).
### VD4020 = monthly income.

################## I saved the data in RDS so the environment is less crowded
#pnadcbr324<- get_pnadc(year=2024, quarter=3, vars=variaveis_selecionadas)

pnadcbr324<- readRDS('C:/Users/nunes/rsetwd/pnadcommaisvariaveis.rds')
##########Calculating Brazil's total income
totalrenda <- svytotal(~VD4020, pnadcbr324, na.rm=T)
totalrenda

########## Total of inhabitants by sex
totalsexo<-svytotal(~V2007, pnadcbr324, nar.rm=T)
totalsexo

##########Total of inhabitants by sex and race
totalsexoeraca<- svytotal(~interaction(V2007, V2010), pnadcbr324, na.rm=T)
totalsexoeraca

########## percentage of inhabitants by sex

porsexo<- svymean(~V2007, pnadcbr324, na.rm=T)
porsexo

########## Brazil's average income
mediarenda <- svymean(~VD4020, pnadcbr324, na.rm = T)
mediarenda

########## Percentage of inhabitants by race
propraca<- svymean(~V2010, pnadcbr324, na.rm = T)
propraca

########## Quantilies of income
quantisrenda<- svyquantile(~VD4020, pnadcbr324 , quantiles = c(.1,.25,.5,.75,.9,
                                                               .99), na.rm=T)
quantisrenda

#################### Now, using the subset function

########## Average income for women in Brazil

rendamediaM<- svymean(~VD4020, subset(pnadcbr324, V2007=='Mulher'), na.rm=T)
rendamediaM

########## Average income for men in Brazil
rendamediaH<- svymean(~VD4020, subset(pnadcbr324, V2007=='Homem'), na.rm=T)
rendamediaH

########## Unemployment rate by sex
txdesmul<- svyratio(~VD4002=='Pessoas desocupadas', ~VD4001=='Pessoas na força de trabalho',
                    subset(pnadcbr324, V2007=='Mulher'), na.rm=T)
txdesmul

txdeshom<- svyratio(~VD4002=='Pessoas desocupadas', ~VD4001=='Pessoas na força de trabalho', 
                    subset(pnadcbr324, V2007=='Homem'), na.rm=T)
txdeshom

########## Income Quantile for men
quantisrendahom<- svyquantile(~VD4020, subset(pnadcbr324, V2007=='Homem'),
                              quantiles=c(.1,.25,.5,.75,.9,.99), na.rm=T)
quantisrendahom

########## Income Quantile for women
quantisrendamul<- svyquantile(~VD4020, subset(pnadcbr324, V2007=='Mulher'),
                              quantiles=c(.1,.25,.50,.75,.9,.99) ,na.rm=T)
quantisrendamul

########## Unemployment rate of people between the age of 20 and 30

desocup25mais<- svyratio(~VD4002=='Pessoas desocupadas', 
                         ~VD4001=='Pessoas na força de trabalho', 
                         subset(pnadcbr324, V2009>=20&V2009<=30), na.rm=T)
desocup25mais

###### Unemployment rate for people over 40 years old

desocup40mais<- svyratio(~VD4002=='Pessoas desocupadas', 
                         ~VD4001=='Pessoas na força de trabalho', 
                         subset(pnadcbr324, V2009>=40), na.rm=T)

######### Unemployment rate among Black women aged 20-30
txmulpreta<- svyratio(~VD4002=='Pessoas desocupadas',
                      ~VD4001=='Pessoas na força de trabalho',
                      subset(pnadcbr324, V2007=='Mulher' & V2010=='Preta'&
                               V2009>=20 & V2009<=30), na.rm=T)
txmulpreta

######### Unemployment rate among White women aged 20-30

txmulbranca <- svyratio(~VD4002=='Pessoas desocupadas',
                        ~VD4001=='Pessoas na força de trabalho',
                        subset(pnadcbr324, V2007=='Mulher' & V2010 == 'Branca' &
                                 V2009>=20 & V2009<=30), na.rm=T)
txmulbranca

######## Average income of White and Black men

rendahombranco<- svymean(~VD4020, subset(pnadcbr324, V2007=='Homem' & V2010=='Branca'), na.rm=T)
rendahombranco

rendahompreto<- svymean(~VD4020, subset(pnadcbr324, V2007=='Homem' & V2010=='Preta'),
                        na.rm=T)
rendahompreto

############### Average income of black women in the state of Pernambuco

pnadcpe2<- subset(pnadcbr324, UF=='Pernambuco')
rendamediamulppe<- svymean(~VD4020, subset(pnadcpe2, V2007=='Mulher', V2010=='Preta'),
                           na.rm=T)
rendamediamulppe
