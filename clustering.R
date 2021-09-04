# The seed for reproducibility (same generated "random" numbers every time)
set.seed(800)

# The data-set has three columns of which the first two "determine" the third one

# Reads data from file specified
dataset <-read.csv(file.choose(), header =TRUE)
head(dataset)

# ??eeping only the columns we need (lat,lon,country)
#install.packages('tidyverse')
library(tidyverse)
dataset <- dataset %>% select(lat,lng,country)
head(dataset)


# PRE-PROCESSING PHASE
# Data statistics
summary(dataset)

# Keeping the desired countries
# DATASET FOR EXAMPLE 1
dataset <-dataset[dataset$country %in% c("Mongolia", "Iran", "India"), ]
# DATASET FOR EXAMPLE 2
#dataset <-dataset[dataset$country %in% c("Papua New Guinea", "China","Philippines"), ]

# Removes rows with NULL(missing) values in the data-set
dataset <- na.omit(dataset)
head(dataset)

# Data statistics after selecting the desired countries 
summary(dataset)

# Plot the original data-set
#install.packages('ggpubr')
#install.packages('ggplot2')
library(ggplot2)
library(ggpubr)
ggscatter(
  dataset, x = 'lng', y = 'lat', 
  color = "country", palette = "npg",
  shape = "country", size = 1,  legend = "right", ggtheme = theme_bw(),
  title = "Data-set"
)


# Scaling data by applying Min-Max normalization
# min_max_norm <- function(x){(x-min(x))/(max(x)-min(x))}
# scaled_dataset <- min_max_norm(dataset[1:2])
# dataset[1:2] <- scaled_dataset

# Scaling data by applying Z-score normalization
# scaled_dataset <- scale(dataset[1:2])
# dataset[1:2] <- scaled_dataset
# summary(dataset)

# Plotting original data-set after the scaling
# ggscatter(
#  dataset, x = 'lng', y = 'lat', 
#  color = "country", palette = "npg",
#  shape = "country", size = 1,  legend = "right", ggtheme = theme_bw(),
#  title = "Data-set"
#) + ylim(c(min(dataset[1:2]), max(dataset[1:2]))) + xlim(c(min(dataset[1:2]), max(dataset[1:2])))

# NOT USING NORMALIZATION because we have geographical data points


# Because the third column is the country (outcome) attribute,
# which is very correlated with the group membership, we exclude that attribute
# in order to run K-means and single-link algorithms
dataset_train <- dataset[, which(names(dataset) != "country")]
head(dataset_train)
summary(dataset_train)


# K-MEANS CODE
# For K-means the number of clusters (=k) must be specified (which is one of the downgrades of the algorithm as well, 
# but there are heuristic rules for determining a good number of clusters, which we will get to later). 

# Using the Elbow Method
# Initialize total SSE (sum of square error)
SSE <- 0

# Calculating the SSE for different number of centers for the k means algorithm
for (i in 1:10) {
  kmeansTEMP <- kmeans(dataset_train[1:2], iter.max = 75, centers=i, algorithm="Lloyd", nstart = 20)
  # Saving total within sum of squares to the SSE variable
  SSE[i] <- kmeansTEMP$tot.withinss
}

# Plotting the results. x axis-> number of clusters, y axis-> SSE variable (Total SSE)
plot(1:10, SSE, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Total SSE")

# Example with k=3
# also calculating the time 
start_time <- Sys.time()
clustersk3 <- kmeans(x=dataset_train, iter.max = 30, centers=3, algorithm="Lloyd", nstart=20)
end_time <- Sys.time()
total_time<-end_time-start_time
total_time
# Printing the objects which shows the size of the clusters, the cluster mean for each column,
# the cluster membership for each row and similarity measures.
clustersk3

clustersk3$iter

# Adding parts/components together (those will help us plot and see how the kmeans performed)
# Adding initial Coordinates (lat/lng) from the training dataset
result <- dataset_train
# Add clusters obtained using the K-means algorithm
result$cluster <- as.character(clustersk3$cluster)
# Add country groups from the original data sett
result$country <- dataset$country
# Data inspection
head(result)

# Plotting part 
# Since the "country" attribute determines where that city belongs,
# a strong correlation between the color and shape would indicate a good clustering.
ggscatter(
  result, x = 'lng', y = 'lat', 
  color = "cluster", palette = "npg", ellipse = TRUE, ellipse.type = "convex",
  shape = "country", size = 1,  legend = "right", ggtheme = theme_bw(),
  title = "K-means",
) +
  # Add cluster centroid (the big dot on the plot) using the stat_mean() [ggpubr] R function
  stat_mean(aes(color = cluster), size = 4) 




# HIERARCHICAL-SINGLE LINK CODE

# Calculating euclidean-distances in order to use for the algorithm
# also measuring the time
start_time <- Sys.time()
distances<- dist(dataset[1:2],method = "euclidean")
# Running the hierarchical-single-link algorithm,
hclust_single <- hclust(distances,method = "single" )
end_time <- Sys.time()
total_time<-end_time-start_time
total_time
# Plotting tree without any cut (labels=FALSE, in order for the tree to be clearer)
plot(hclust_single,hang=-1,labels=FALSE)
# Cutting tree for k=3 clusters
cut_hclust_single<- cutree(hclust_single,k=3)


# Adding parts/components together (those will help us plot and see how the hierarchical-single-link algorithm performed)
# Adding initial Coordinates (lat/lng) from the training dataset
result <- dataset_train
# Add clusters obtained using the hierarchical-single-link algorithm
result$cluster <- as.factor(cut_hclust_single)
# Add country groups from the original data sett
result$country <- dataset$country
# Data inspection
head(result)


# Plotting part 
# Since the "country" attribute determines where that city belongs,
# a strong correlation between the color and shape would indicate a good clustering.
ggscatter(
  result, x = 'lng', y = 'lat', 
  color = "cluster", palette = "npg", ellipse = TRUE, ellipse.type = "convex",
  shape = "country", size = 0.9,  legend = "right", ggtheme = theme_bw(),
  title = "Hierarchical Single-Link"
)