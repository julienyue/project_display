# Project #2, an analysis of the State of the Union speeches

> *Note:* thanks to professor Deb Nolan for providing a previous version of this project along with a solution outline in R.  Some of these notes are taken from her version.

The goal of this project is for you to analyze the State of the Union speeches from 1790 to 2017. To do this you will need to prepare the speeches in a form that is suitable for statistical analysis. For example, you will be examining the words that each president used in his State of the Union address and their frequency of use. With this information, you can compare the presidents and see how they differ across time.

## Team setup and logistics

**Due date:** the last commit should be no later than *Friday, November 17th, at 11pm local (Pacific) Time*.

**Teams:** the project is to be completed in teams of three.  You should preferably form teams that consist of people all in the same lab session, as we will allow lab time to work on this project with Eli's assistance.

**Team names:** create your team named p2-XX-YY-ZZ, where XX, YY and ZZ are the first two letters of each member's last name.

## Notes and guidelines

* The data is provided in a directory called `data/`.  I strongly suggest that you make a small version of the data to work with during development, by removing many of the speeches.  It will make it easier to run the code over and over until you're confident you have it right. You can then re-execute the lot with the full dataset.

* You will break down your analysis into 5 separate notebooks. I've provided a rough skeleton of the first four, outlining what you should do.  The fifth should contain some new analysis done by you, where you explore a new feature/question related to this dataset in your own words.

* At the end of each notebook, you will create files in the `results/` directory to store key data structures that you may need in subsequent notebooks.  You will use the numpy [`savez`](https://docs.scipy.org/doc/numpy-1.13.0/reference/generated/numpy.savez.html) function to store numpy arrays, the pandas [`to_hdf`](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.to_hdf.html) method for dataframes, and the Python [`shelve`](https://docs.python.org/3/library/shelve.html) module to store regular Python variables (lists, dicts, strings, etc.). 

* Write a `main.ipynb` that summarizes and discusses your results. It can contain figures referenced from `fig/` directory or simple summary information (for example if you want to display part of a dataframe) from variables read from your `results/` directory, but *no significant computations at all*. Think of this as your "paper".

* Environment: just like in Project #1, you will create an `environment.yml` file that creates an environment, in this case called `sunion`, with all necessary dependencies to run the code.

* Makefile: you will also create a Makefile with `env` and `all` targets, similar to that of Project #1. The `env` target should make the environment with all necessary libraries, `all` should run all notebooks.

* Don't forget to control your random seeds for anything that has a stochastic component.


## Breakdown of the complete analysis 

Each of the provided notebooks has some outputs left in place, to provide you with a bit of guidance as to what you're after. I suggest you keep a copy of all of them in their original state in a reference folder, for convenience (they are obviously in git's history, but it's easier to look at them for quick comparisons if you keep them around).

The notebooks contain more detailed instructions of the quantities you should find and compute, this description is a high-level overview.


### Notebook 1

You will start with one text file containing all the speeches and some data about the speeches. You will need to first process this text file and create some initial datastructures to use in the next step of the analysis. For instance, you will first need to extract the individual speeches.

1. P1: finish with dataframe of addresses. Monthly disribution and rug plot. Summary stats. Save DF.

1. Load the data and break it up into speeches.
1. Create a data frame of presidents and addresses/dates. Donald Trump is the 45th president, how many are there in the data? Why?
1. Time between oldest and newest speech. How many years have passed?
1. Summarize the distribution of speeches and make a rugplot of the speeches timeline.
1. Discuss gaps in data: are there any? If so, when and why?
1. Remember to save key variables that you'll need later on for the next steps (example code provided for the first notebook, you'll need to do the same in the others).


### Notebook 2

Here you will do some text processing with NLTK to compute aggregate text statistics of the speeches as well as visualize some of their properties.

1. Start with addresses DataFrame and add new columns for text analysis.
1. You'll need to do proper stopword removal and stemming.
1. Explore some of the relations between the properties of the speeches, their authors, and the passage of time, provide a novel visualization of the relevant information.


### Notebook  3

Next you will create a term-document matrix. A term-document matrix is a standard format for representing a collection of documents. Each row of the term-document matrix corresponds to a term (or word) and each column corresponds to a different document (in this case speech). Each entry of the matrix is an integer that specifies the number of times the corresponding word occurred in the corresponding speech. Each column of the resulting matrix is a word vector representing the speech in word frequency space.


1. Create word_vector function.
1. Creation of term-document matrix.
1. Compute sparsity of the TD matrix.


### Notebook 4

Finally, you will compute a speech-by-speech matrix containing the distances between every pair of speeches in word frequency space. Using the speech-by-speech distance matrix, you will create visualizations of the presidents using multi-dimensional scaling from [scikit-learn](http://scikit-learn.org/stable/modules/generated/sklearn.manifold.MDS.html).

1. Collapse TD matrix int `pres_mat` that groups by president.
1. Turn `wmat` and `pres_mat` into probability density matrices.
1. Compute the pair-wise Jensen-Shannon divergence matrices at the speech- and president- levels (a function `JSdiv` is provided for you).
1. Present MDS plots both grouping the data by president and at the level of individual speeches.  Label the individual points with the president's last name when grouping by presidents, and with their initials when showing all individual speeches.
1. Compare the MDS plots that you get if you use the raw frequency data vs. if you do it with a the Jensen-Shannon divergences.


### Notebook 5

Free-form: here you will add one bit of original analysis about some feature of the data that you find interesting.
