# Personalized Thought Chart
<<<<<<< HEAD
The R and Matlab scripts used to create a personalized Thought Chart
=======
>>>>>>> Inilization

The scripts and functions here were used to do the analysis in the paper here: https://doi.org/10.1101/2020.06.19.162461

*The scripts will be uploaded upon successful publication of the above paper.*

# Methods

Most of the Thought Chart method is done using Matlab. Dependencies are all open source toolboxes:

- [Brain Connectivity Toolbox](https://sites.google.com/site/bctnet/) for network analyses
- [FieldTrip](http://www.fieldtriptoolbox.org/) for construction of the WPLI
- [EEGLAB](https://sccn.ucsd.edu/eeglab/index.php) for preprocessing EEG files

## Preprocessing

We tried to keep the preprocessing as simple as possible, in order to automate the process for reliability and reproducibility. Here are the steps taken:

1. Reference to the channel average (do this after every step).
2. Down-sample to 512 Hz.
3. High-pass filter at 0.5 Hz to remove motion artifacts.
4. Use `clean_rawdata` to automatic reject artifacts using ASR [@chang_evaluation_2018-1].
5. Quality control check.

The first four steps can be done using the `preprocess_eeg_files.m` script with minor edits to reflect your local file ecosystem.

## Functional Connectivity

The functional connectivity of the EEG files was computed using [weighted phase lag index](https://pubmed.ncbi.nlm.nih.gov/21276857/) via the FieldTrip toolbox. This is automated with the `create_wpli_connectomes.m` script.

## Thought Chart

Creating the Thought Chart from the dynamic functional connectome involves the following steps:

1. Construct a dissimilarity matrix between every time point.
2. Run the *k*-nearest neighbor algorithm on the dissimilarity matrix.
3. Run the Dijkstra algorithm.

And that's it! In practice it's a bit more complicated than that, to dive into the math, please see the above paper about this method. This portion is written out in the `create_thoughtchart_from_wpli.m` script.

## Additional Analyses

From here you can do whatever you like with the Thought Chart. We included some properties of the Thought Charts we made in our paper on the topic, as a reference to compare to. To measure the separation between to clusters in the state space, we use Hausdorff distance (`find_hausdroff_of_thoughtchart.m`).

We also used R for the statistical analysis, which is also included here.
