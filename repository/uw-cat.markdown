---
layout: default
title: Myria - UW-CAT CoAddition Testing Use-Case
---

# UW-CAT: University of Washington CoAddition Testing Use-Case

**Requests**: If you have any questions about this use-case, please contact [Emad Soroush](http://homes.cs.washington.edu/~soroush/).

## Overview of Application Domain

The [Large Synoptic Survey Telescope (LSST)](http://www.lsst.org/lsst/) is a large-scale, multi-organization initiative to build a new telescope and use it to continuously survey the entire visible sky. The LSST will generate tens of TB of telescope images every night. The planned survey will cover more sky with more visits than any survey before. The novelty of the project means that no current dataset can exercise the full complexity of the data expected from the LSST. For this reason, before the telescope produces its first images in a few years, astronomers are testing their data analysis pipelines, storage techniques, and data exploration using realistic but simulated images. More information on the simulation process can be found in [this](http://spie.org/x648.html?product_id=857819) paper.

This use-case provides a set of such simulated LSST images (approximately 1TB in binary format) and presents a simple but fundamental type of processing that needs to be performed on these images.

Please visit this page often as we plan to expand the type of analysis described in this use-case!

## Dataset 

As the telescope operates, it continuously scans the sky through a series of "visits" to individual, possibly overlapping locations, which are called _patches_. Each visit is one exposure on the sky. The dataset in this use-case comprises _25 exposures_. 

The dataset is organized hierarchically: The root directory contains all the patches (e.g. 69,71/). Each patch directory contains a subset of visits (e.g. v865833781-fr/). These are the visits that overlapped this patch. Each visit contains a subset of raft directories (e.g. R01). Finally, each raft holds individual 2D ccd images. A sample directory structure is: "69,71/v865833781-fr/R01/S00". Each ccd image is a 2D array of pixels stored in a binary file (compatible with the [SciDB](http://scidb.org/) array processing engine). The ccd images were originally represented in the [FITS](http://en.wikipedia.org/wiki/FITS) format. Fits files are available upon request. We do not post them because they are much bigger in size due to null values.

The total number of pixels is approximately 44 billion and the total size of all the binary files is approximately one terabyte.

* Each binary file comprises a list of tuples of the form: (int64 x, int64 y, int64 t, float data, int16 mask, float variance). Each tuple represents a pixel in (x,y,t) coordinates and consists of three measurements. In this use-case, we only use the first measurement, called "data":
  1. *data*: This is the flux information recorded by the detector with some corrections for systematic issues.
  2. *mask*: This value is a bitmask encoded as an integer and related to pixel quality (e.g. was this pixel saturated, interpolated, marked as bad, etc.)
  3. *variance*: This value encodes the measurement error for each pixel.  


The format of each tuple in the binary output file is as follows: 8 bytes (big-endian) for "x" att + 8 bytes for "y" att + 8 bytes for "t" att + 1 byte purge + 4 bytes for "data" att + 1 byte purge + 2 bytes for "mask" att + 1 byte purge + 4 bytes for "variance" att. The "purge" bytes indicate whether the following value is NULL or not. It is a SciDB-specific encoding. 

**Link to the data:** [http://lsst-data-washington.s3.amazonaws.com/](http://lsst-data-washington.s3.amazonaws.com/)

**Link to tech report with details about the data and analysis**: [The Image Co-Addition Benchmark for Big Data Research](http://scidb.cs.washington.edu/paper/p807-soroush.pdf) (full reference at the bottom of this page).

## <span>Analysis</span>

In Astronomy, some sources are too faint to be detected in one telescope image but can be detected by stacking multiple images from the same location of the sky. The pixel value (flux value) summation over all images is called image co-addition. Before performing the co-addition, astronomers often run a &ldquo;sigma-clipping&rdquo; noise-reduction algorithm. The analysis in this use-case thus has two steps: (1) outlier filtering with "sigma-clipping" and then (2) image co-addition.

The input is the relation AllImages(int x, int y, int t, float data, int mask, float var) comprising the pixels from all the x-y images over time t.

### Pseudocode

```
//Part 1: Iterative “sigma-clipping”
 while (some pixels changes)
     for each (x,y) location
            compute mean/stddev of all pixel values at that location

            filter any pixel value that is k standard deviations away from the mean  
// Part 2: Image co-addition
sum all non-null pixel values grouped by x-y
```

### Concrete "Sigma-Clipping" Algorithm

```python
Input: Relation A(int x, int y, int t, float data, int mask, float var) 
Input: k a constant parameter.
WHILE(some tuples in A are filtered)
   T = SELECT AVG(data) AS avg, STDV(data) AS stdv, x, y FROM A GROUP BY x,y
   S = SELECT A.x, A.y, A.t, A.data, T.stdv, T.avg FROM T join A on T.x = A.x AND T.y=A.y
   A = SELECT S.x, S.y, S.t, S.data FROM S WHERE S.data> S.avg - k*S.stdv AND S.data < S.agv + k*S.stdv
Result = SELECT SUM(data) AS coadd from Filtered GROUP BY x,y 
```

## Acknowledgment Request

If you use this use-case in your paper, we ask you to please:

1.  Add the following statement to your acknowledgments section: "**We thank the AstroDB group from the U. of Washington for the&nbsp;UW-CAT use-case and dataset [cite tech report below].**"
2.  Please cite the following tech report, which contains the full-length description of the use-case and the expanded acknowledgments:
 * Emad Soroush, Simon Krughoff, Matthew Moyers, Jake Vanderplas, Magdalena Balazinska, Andrew Connolly, and Bill Howe [The Image Co-Addition Benchmark for Big Data Research](http://scidb.cs.washington.edu/paper/p807-soroush.pdf) Technical Report. University of Washington. April 2013

1.  Please let us know when your paper gets published and we will add a link to it from this page.

## Acknowledgments

LSST project activities are supported in part by the National Science Foundation through Governing Cooperative Agreement 0809409 managed by the Association of Universities for Research in Astronomy (AURA), and the Department of Energy under contract DE-AC02-76-SFO0515 with the SLAC National Accelerator Laboratory. Additional LSST funding comes from private donations, grants to universities, and in-kind support from LSSTC Institutional Members.

This use-case was developed as part of a project supported in part by NSF grant IIS-1110370 and the Intel Science and Technology Center for Big Data.