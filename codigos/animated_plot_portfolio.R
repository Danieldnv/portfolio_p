library(ggplot2)
library(lubridate)
library(GetBCBData)
library(tidyverse)
library(gganimate)
library(gifski)


############### Colecting default data from the central bank of Brazil #####################
serie_bcb2 <- c(individuals = 21083, legal_entities = 21084)
initial_date<-'2011-03-01'

default_bcb2<- gbcbd_get_series(id=serie_bcb2, first.date = data_inicial,
                                      last.date = Sys.Date(), use.memoise = F)

############### Building a data frame from the data I just obtained #########################
PJ<- default_bcb2%>%
  filter(series.name == 'legal_entities')%>%
  select(value)

PF <- default_bcb2%>%
  filter(series.name == 'individuals')%>%
  select(value)

df_default <- data.frame(inadimplencia_bcb2$ref.date, PF, PJ)
colnames(df_default)= c('Year', 'Individuals', 'Legal_entities')

########################### Plotting the graph and animating it #######################
estatico <- ggplot(data= df_default, aes(x=Year))+
  theme_gray()+
  geom_line(aes(y= Individuals, colour='Individuals'), size=.9)+
  geom_line(aes(y= Legal_entities, colour='Legal_entities'), size=.9)+
  labs(x='Year', y= 'Default rate (%)', title = 'Default rate - Individuals and legal entities', 
       subtitle = '(2011-2024)', caption= 'Source: Central Bank of Brazil', colour= '')+
  theme(plot.title = element_text(size = 17, face='bold', hjust = 0.5, 
                                  family='serif'))+
  theme(plot.subtitle =element_text(size = 16, face='bold', hjust = 0.5, 
                                    family='serif'))+
  theme(axis.text.x = element_text(size= 15, face ='bold', hjust=1 , family=
                                     'serif', angle= 45))+
  theme(axis.text.y = element_text(size= 15, face ='bold', colour= 'black', angle=1,
                                   hjust=1 , family='serif'))+
  theme(legend.position = 'bottom')+
  scale_x_date(date_labels = '%Y', breaks ='1 year')

estatico #visualizing the static plot

animated_plot <- estatico +  
  transition_reveal(Year) +    
  ease_aes('linear')        

# agora, usando 'animate' para animar 'animated_plot', criado anteriormente.
#Now, I am going to use 'animate' to animate 'animated_plot'


ap_better <- animate(animated_plot, nframes = 400, fps = 50,width = 600, height = 400, 
                     renderer = gifski_renderer())

#saving the GIF 'animated_plot'
anim_save("animated_plot_better.gif", ap_better , path = 'C:/Users/nunes/Documents')

