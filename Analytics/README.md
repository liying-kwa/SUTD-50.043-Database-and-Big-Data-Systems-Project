# Analytics System

## Description

This system consists of a cluster of servers, and support the following features:
* Loading data from the production system, and store in a distributed file system.
* Implementing two analytics tasks:
    * Correlation: compute the Pearson correlation between price and average review length.
    * TF-IDF: compute the term frequency inverse document frequency metric on the review text. Treat one review as a document.
* Scaling up and down (adding or removing nodes)