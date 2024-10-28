#################################################################################

## Reference: https://bookdown.org/yih_huynh/Guide-to-R-Book/tidyverse.html

###############################################################################
# tidyverse comes with other packages like dplyr, ggplot2 etc
# loads all functions in dplyr, ggplot...etc
library(tidyverse)

# we see that filter() and lag() functions are masked i.e. there is a naming conflict
# Both dplyr and the (base R) stats packages have functions filter() and lag()
# How does R pick which package’s definition to use for filter()? 
# It decides based on which package was loaded most recently. 

## loads ONLY the filter function from dplyr
dplyr::filter() 

#################################################################################

data("diamonds")
View(diamonds)
str(diamonds)

### mutate() - to add new columns or modify existing columns

# adding new column called "price_per_carat"
new_df = diamonds %>% mutate(price_per_carat = price/carat)
names(new_df); names(diamonds)

# multiple columns at once
new_df = new_df %>%  
  mutate(vol_diamond = x*y*z,         # volume of diamond
         price20off = price * 0.20)   # 20% of the original price

str(new_df)


## code below does NOT add a new column to the diamonds dataset
diamonds %>% mutate(price_per_carat = price/carat)

############################################################################
## Nesting functions


# creates 3 new columns with the same value in the each column
diamonds %>% 
  mutate(m = mean(price),     # calculates the mean price
         sd = sd(price),      # calculates standard deviation
         med = median(price)) # calculates the median price

########################################################################
## recode() function - to correct inconsistent coding
## basic structure: data %>% 
##                    mutate(Variable = recode(Variable, "old value" = "new value"))

class(diamonds$cut)
levels(diamonds$cut)

# recode existing factor or create new factor
# notice that sequence of recoding matters
diamonds %>% 
  mutate(cut = recode(cut, "Ideal" = "IDEAL"), 
         cut.new = recode(cut, "Very Good" = "VG",
                              "Fair" = "OK OK") )
############################################################################

## summarize() - collapses all rows and returns a one-row summary

# create a  tibble called avg_price with one column called avg.price
avg_price = diamonds %>% 
  summarize(avg.price = mean(price))

names(avg_price)

useful_quantities = diamonds %>% 
  summarise(avg_price_per_carat = mean(price/carat), 
            m = mean(price),
            sd = sd(price),
            n = n()) # n() calculates total num. of obs.

useful_quantities

###################################################################

## group_by() and ungroup()
data("iris")
str(iris)

### not saved
iris %>% 
  group_by(Species) %>% # all code below is performed on each species type
  summarise(avg.sepal.length = mean(Sepal.Length),
            avg.petal.length = mean(Petal.Length),
            num_of_species = n())
  
#create synthetic data
########################################################################
## Creating identification number to represent 50 individual people
ID <- c(1:50)

## Creating sex variable (25 males/25 females)
Sex <- rep(c("male", "female"), 25) # rep stands for replicate

## Creating age variable (20-39 year olds)
Age <- c(26, 25, 39, 37, 31, 34, 34, 30, 26, 33, 
         39, 28, 26, 29, 33, 22, 35, 23, 26, 36, 
         21, 20, 31, 21, 35, 39, 36, 22, 22, 25, 
         27, 30, 26, 34, 38, 39, 30, 29, 26, 25, 
         26, 36, 23, 21, 21, 39, 26, 26, 27, 21) 

## Creating a dependent variable called Score
Score <- c(0.010, 0.418, 0.014, 0.090, 0.061, 0.328, 0.656, 0.002, 0.639, 0.173, 
           0.076, 0.152, 0.467, 0.186, 0.520, 0.493, 0.388, 0.501, 0.800, 0.482, 
           0.384, 0.046, 0.920, 0.865, 0.625, 0.035, 0.501, 0.851, 0.285, 0.752, 
           0.686, 0.339, 0.710, 0.665, 0.214, 0.560, 0.287, 0.665, 0.630, 0.567, 
           0.812, 0.637, 0.772, 0.905, 0.405, 0.363, 0.773, 0.410, 0.535, 0.449)

## Creating a unified dataset that puts together all variables
data <- tibble(ID, Sex, Age, Score)
######################################################################

head(data)
str(data)

## group by one variable
data %>%
  group_by(Sex) %>%
  summarise(avg_age = mean(Age),
            avg_Score = mean(Score),
            number = n()) %>%
ungroup()

## num. of unique age values in the 50 people
length(unique(data$Age))

data %>% 
  group_by(Sex, Age) %>%
  summarise(number = n(),
            avg_score = mean(Score)) %>%
ungroup()

## group_by() and mutate()
data %>% 
  group_by(Sex) %>%
  mutate(avg_val = mean(Age)) %>%
  ungroup()


################################################
## Always use ungroup() after we use group_by()
## Why is it important to ungroup?

## Ex 1.1
data %>% 
  group_by(Sex) %>%
  mutate(m = mean(Age)) %>%
  mutate(x = mean(Score)) %>%
  ungroup()
  
  
## Ex 1.2
data %>% 
  group_by(Sex) %>%
  mutate(m = mean(Age)) %>%
  ungroup() %>%
  mutate(x = mean(Score)) 

## important to ungroup when creating new data objects
## Ex 2.1
data1 = data %>% 
  group_by(Sex) %>%
  mutate(m = mean(Age))

# anytime we use data1, it will be grouped by sex
data1 %>%
  summarise(n = n())
  
#################################################################  

## filter() function: to retain specific rows of data that meet
###                   the specified requirement(s).

table(diamonds$cut)

diamonds %>% 
  filter(cut == "Fair") %>% # filter rows corresponding to "fair" cut
  summarise(n_fair = n()) # count number of fair cut diamonds


## Pipe | denotes "OR" while , denotes "AND"
## order of the conditions matter
d1 = diamonds %>%
  filter(cut == "Ideal" | cut == "Premium", price <= 500)


d2 = diamonds %>%
  filter(cut == "Ideal", price <= 500 | cut == "Premium")
table(d2$cut)


## another way of constructing d1
diamonds %>%
  filter(cut %in% c("Ideal" ,"Premium"), price <= 500)

## disply data that doesn't have a fair cut
diamonds %>% filter(cut != "Fair")

##############################################################################

## select() - Select only the columns (variables) that you want to see. 
##            Gets rid of all other columns.
##            The order in which you list the column names/positions is the 
##            order that the columns will be displayed.

## retain specific columns
diamonds %>% 
  select(cut, color)

# order matters
diamonds %>%
  select(color, cut)

# retain columns 5 to 9
diamonds %>%
  select(5:9)

# retain all columns except the last 3 columns
diamonds %>% 
  select(-c(8,9,10))

diamonds %>%
  select(-1,-4,-9)

# retain all columns except that of cut
diamonds %>% 
  select(-cut)

# retain all of the columns, but rearrange some of the columns to appear at the beginning
diamonds %>% 
  select(x,y,z, everything())

###################################################################################
## arrange() - Allows you arrange values within a variable in ascending or
##             descending order (if that is applicable to your values).
             

# arranges alphabetically
diamonds %>% arrange(cut) 

# descending alphabetical order
diamonds %>% arrange(desc(cut))

# arranges price in increasing order
diamonds %>% arrange(price) 

# arranges price in decreasing order
diamonds %>% arrange(desc(price))

############################################################################

