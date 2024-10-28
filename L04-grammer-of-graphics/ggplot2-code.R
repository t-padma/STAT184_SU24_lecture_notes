################################################################################
## L04: ggplot2 grammar
################################################################################

library(tidyverse)


data(mpg) # load the data set

?mpg # about the data set

str(mpg) # structure of data

# focus on variables displ (engine size in lit) and hwy (fuel efficiency)
# Question:  What does the relationship between engine size and fuel efficiency look like? 

# Plot engine size (displ) on x-axis and fuel efficiency (hwy) on y-axis
# we observe negative correlation i.e. bigger engine implies less fuel efficiency

ggplot(data = mpg) +                               # create co-ord system i.e. empty graph
  geom_point(mapping = aes(x = displ, y = hwy))    # adds a layer of points



















