# K-Means-and-Single-Link-Hierarchical-Clustering-on-World-Cities-data

![Image of cities](https://github.com/nikopetr/K-Means-and-Single-Link-Hierarchical-Clustering-on-Geodata/blob/main/images/cities.jpg =100x20)

A Data Mining project which focuses on the comparison between different un-supervised clustering algorithms.

The project was part of the [Data Mining and Data Warehouses class](https://qa.auth.gr/el/class/1/40049931), where it was ranked first among the same type of projects.

The code of the project is located in the **clustering.R** file

**Authors**: Nikolas Petrou, Salome Nikolaishvili

## Abstract - Introduction
* This simple work compares the K-Means algorithm versus the Single-Link Hierarchical Clustering algorithm
* Mostly emphasized on the quality of the results and not on the performance
* Consists of examples of geodata where the weaknesses of each algorithm were clearly shown
* Programming language: R

## Dataset
* Dataset:  [World Cities database](https://www.kaggle.com/juanmah/world-cities)
* Data for cities around the world
* Geographical coordinates
* Each different sample corresponds to a different city
* The last update of the dataset took place in November 2020

## Data Pre-processing
* Only kept samples with non-null features
* Only the geographical coordinates (Latitude and Longitude) were kept and used as features

## Comparison - Evaluation examples
* Choice of cities of different countries - the cities of each country represent the actual-real clusters
* The choice of cities and countries was done in a manner such that the different expected behaviour of the clustering methods would have been easily visualized and proved

### Example 1
* **Selected countries**: 
 * India
 * Iran
 * Mongolia
* **648 cities (data samples)**

### Example 2
* **Selected countries**: 
 * Papua New Guinea
 * China
 * Philippines
* **906 cities (data samples)**

## K-Means Clustering Results

* During the evaluation of the K-Means algorithm, the elbow method showed that "optimal" number of clusters is three (as it was previously known since the cities used belong to three different countries)
* The **Lloyd**  K-Means algorithm was used
* For more accurate assumptions,  the algorithm has run 20 times in total, for different initial data-points as centers
* Selected centers for model with the smallest SSE

### Example 1
* Accurate clustering
* As expected since:
   * The clusters form spherical - elliptical shapes
   * The actual clusters are uniformly distributed in the space
* Algorithm always converges (in iterations <30)
* Execution time: 0.013 secs (nstart = 20)

### Example 2
* Poor clustering results
* As expected since:
  * The actual clusters have significantly different sizes
  * Non-spherical actual clusters
  * Different density of actual clusters
* Algorithm always converges (in iterations <30)
* Execution time: 0.017 secs (nstart = 20)

## Single-Link Hierarchical Clustering Results

* Used **Euclidean Distance** as a comparison metric between the different data-points
* The hierarchical tree that the algorithm had produced, was pruned in a manner such that the total clusters would have been three in total

### Example 1
* Poor clustering results
* A bridge (connection between data-points that occurred in the same cluster) was created between two nearby points-cities
* Isolation of Port Blair in a different, non-accurate cluster
* As expected since:
  * The Port Blair is isolated (outlier) compared to the other cities of India
  * The nearby cities between India and Iran created a bridge during the process
* Execution time: 0.033 secs 

### Example 2
* Accurate clustering
* As expected since: Distances between countries (real clusters) are greater than the distances of the respective pairs of cities in each different country. That is, the algorithm finds a bridge to connect the cities of the same countries to the same cluster
* Execution time: 0.042 secs 

### References - Useful Links
* [K-means Clustering](https://en.wikipedia.org/wiki/K-means_clustering)
* [Single-Link Hierarchical Clustering](https://en.wikipedia.org/wiki/Single-linkage_clustering#:~:text=In%20statistics%2C%20single%2Dlinkage%20clustering,same%20cluster%20as%20each%20other.)
* [DataComp: Machine Learning with R Tutorial](https://www.youtube.com/watch?v=xjpzDx_nywc&t=194s)
* [Tutorial: Hierarchical clustering in R](https://www.youtube.com/watch?v=r_bowNoNrg8&t=406s)
* [World Cities database](https://www.kaggle.com/juanmah/world-cities)


