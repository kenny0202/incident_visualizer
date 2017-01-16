#Change working directory
setwd("C:/Users/I850366/Desktop/R_app")
#Load csv file into variable "slt"
slt <- read.csv("slt_inc.csv")
#slt is now a data frame, print the contents
print(slt)

#load filter functions
#ask user for input of from date
read_from_date <- function() {
	print("Date format is yyyy-mm-dd.")
	from_date <- readline("Enter a from date: ")
	if(!grepl("^\\d{4}\\-(0?[1-9]|1[012])\\-(0?[1-9]|[12][0-9]|3[01])$", from_date)) {
		return(read_from_date())
	}
		return(as.Date(from_date))
}

#ask user for input of to date
read_to_date <- function() {
	print("Date format is yyyy-mm-dd.")
	to_date <- readline("Enter a to date: ")
	if(!grepl("^\\d{4}\\-(0?[1-9]|1[012])\\-(0?[1-9]|[12][0-9]|3[01])$", to_date)) {
		return(read_to_date())
	}
		return(as.Date(to_date))
}

#load all num of incidents into vector
slt_vec <- c(slt$num_of_inc)
#visualize incoming slt incidents all time
#barplot(slt_vec,names.arg=slt$date, main="SLT Incidents", xlab="Days", ylab="# of Incidents", col="green")
#calculate the mean number of incidents coming in and draw mean line
#abline(h=mean(slt_vec, trim=0, na.rm=TRUE))

#create new window
#win.graph()
#create subset of data. This example will grab all incidents from october.
#slt_sub <-subset(slt, as.Date(date) >= '2016-10-24' & as.Date(date) <= '2016-10-31')
#create subset of date based on user filtered dates.
#slt_sub <-subset(slt, as.Date(date) >= print(read_from_date()) & as.Date(date) <= print(read_to_date()))
#view data frame of slt_subplot()
#print(slt_sub)
#load all num of incidents into vector from the subset of data
#slt_sub_vec <- c(slt_sub$num_of_inc)
#visualize october data
#barplot(slt_vec, main="SLT Incidents from October", xlab="Days", ylab="# of Incidents", col="red")
#load plotly lib
library(plotly)
#create bar graph using external lib
plot_ly(y=(slt_vec),
		x=(slt$date),
		type="bar",
		color = I("green")) %>%
layout(title="SLT Incidents",
	   xaxis = list(title="Date"),
	   yaxis = list(title="# of Incidents"))

#create line chart
plot_ly(y=(slt_vec),
		x=(slt$date),
		type="scatter",
		mode = 'lines+markers',
		color = I("blue")) %>%
layout(title="SLT Incidents",
	   xaxis = list(title="Date"),
	   yaxis = list(title="# of Incidents"))


