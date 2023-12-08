#With this command we open the .csv file

df <- read.csv("C:/Users/cobi/Desktop/ASSIGNMENTR/HollywoodsMostProfitableStories (1).csv")

# Step1: Initial Exploratory Analysis

## View the data

View(df)

## Installing the Library

install.packages("tydiverse")

## Importing the Library

library(tidyverse)

## Check the structure of the data set, with all the different data types

str(df)


### We can check the column names easily with the "names()" function
### which corresponds to columns() in Python

names(df)

### We immediately notice that the column names are not in the best
### format, one example is "Audience..score.."
### Before any in depth analysis, let's clean the data

# Step 2 : Clean Data
## Check for missing values

colSums(is.na(df)) 
### With this we are basically saying, calsulate the column sums of
### null values. It is going to tell us if there are any missing values
### and where they are located. It looks lithe there are 5 in total.

## Drop the missing values
### One way is with the omit function

df = na.omit(df)  
### Here, we are just omitting all the missing values in the data set
### and assigning the new set of values to the original data frame df.

colSums(is.na(df))
### If we check now, we see that there are no missing values in the data frame.

### Another method uses the drop function

df = df %>% drop_na()
### Here we are using the "%>%" (pipe) operator, which is used to pipe
### the left side object (in our case the data frame df) into the next
### expression on the right side
### It is basically saying: "Take the dataframe df, and then(%>%) drop
### the missing values, then apply the changes to the original df".

# Step 3: Exploratory Data Analysis

## The summary function gives us statistics of the data set

summary(df)

## Some observations:
### The data set consists in 70 movies.
### The avg audience score is 64.46, lowest score is 35, highest is 89.
### We have to keep an eye on the outliers for the Profitability and Gross
#### as we have very low values.
### RT scores vary from min of 3(incredibly low) and 96, with avg of 47.76.
### The movies range from 2007 to 2011.

#### Just out of curiosity, let's see those very low values in Gross
#### and profitability.

df[df$Profitability < 1 | df$Worldwide.Gross < 15, ]

#### We see that most of the movies selected are Independent, which 
#### suggest low budgets and smaller audiences.

#### Let's now sort them by scores:

lowG_P = df[df$Profitability < 1 | df$Worldwide.Gross < 15, ]

lowG_P[order(-lowG_P$Audience..score.., lowG_P$Rotten.Tomatoes..), ]

##### The "-" sign is asking to show the values in descending order.
##### We see immediately that low budget doesn't mean necessarely low score.

## Let's now use plots to make the data more easily understandable:

ggplot(df, aes(x=Lead.Studio, y=Rotten.Tomatoes..)) + 
geom_point()+ scale_y_continuous(labels = scales::comma)+
coord_cartesian(ylim = c(0, 110))+
theme(axis.text.x = element_text(angle = 90))

### It appears there is an entry with blank Lead Studio;
### Lets try to sort it out:

df[is.na(df$Lead.Studio), ]

### Our movie is not appearing, might it be represented by a space or 0?

df[df$Lead.Studio == "" | df$Lead.Studio == 0 | is.na(df$Lead.Studio), ]

### There is our movie, named "No Reservation"
### Now, we can remove this value as we couldn't find
### the actual value online.

missing_v = df[df$Lead.Studio == "" | df$Lead.Studio == 0 | is.na(df$Lead.Studio), ]

df = df[!(df$Film %in% missing_v$Film), ]

view(df)

### Another issue is that "20th Century Fox" and "Fox" appear as separate,
### Where generally refer to the same film studio
### Let's combine the two names in "20th Century Studios"

df$Lead.Studio[df$Lead.Studio %in% c("20th Century Fox", "Fox")] = "20th Century Studios"

view(df)
## Let's now take a look at the updated scatter plot chart:

ggplot(df, aes(x=Lead.Studio, y=Rotten.Tomatoes..)) + 
geom_point()+ scale_y_continuous(labels = scales::comma)+
coord_cartesian(ylim = c(0, 110))+
theme(axis.text.x = element_text(angle = 90))

### Some observations:
### The chart shows the relationship between movies by studios ans RT score.
### Warner Bros and Independent movies have most entries.
### The Weinstein Company has relatively high total scores.
### Most studios only have few or one entry.
### Only 4 movies appear to have scored 90+.

## An example of a simple bar chart:

ggplot(df, aes(x=Year)) + 
geom_bar()

## The chart shows how many entries there are for each year.
## Most movies were released in 2008 and 2010.

## Another example to show correlations:

ggplot(df, aes(x = Worldwide.Gross, y = Audience..score..)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "black")

### It doesn't look the correlation is very strong
### Let's double check using the cor function

cor(df$Worldwide.Gross, df$Audience..score..)

### The result is 0.396, which suggests there is a weak positive correlation.
### It means that when the Gross increases, the score increases,
### but as we have seen before, there are some exceptions.

ggplot(df, aes(x = Worldwide.Gross, y = Rotten.Tomatoes..)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "black")

### The correlation between gross and RT score is a flat line
### meaning there is no relation at all between the two variables.

cor(df$Worldwide.Gross, df$Rotten.Tomatoes..)

### In fact, the correlation formula gives a 0.0085 coefficient.

## Just before we export the file to work in PowerBI
## I want to rename those columns

### Method 1: using colnames()

colnames(df) = c("FilmTitle", "Genre", "LeadStudio", "AudienceScore", "Profitability", "RottenTomatoes", "WorldwideGross", "Year")

view(df)

### Method 2 : using names()

names(df) = c("FilmTitle", "Genre", "LeadStudio", "AudienceScore", "Profitability", "RottenTomatoes", "WorldwideGross", "Year")

view(df)

### Now that the column names are more tidy, we can export the file

# Step 4: Export Data

## Export the clean data using "write.csv()"

write.csv(df, "clean_df.csv")

### This will export the new file in the document folder.
