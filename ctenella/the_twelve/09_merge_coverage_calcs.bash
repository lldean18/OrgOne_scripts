#!/bin/bash
# 3/4/26

# merge the per site depth calculations to give overall depth per individual

# move to the working directory
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/bams

# copy all the depth statistics to a single file
cat mapping_info/*_mapping_cov_depth.txt > mapping_info/per_ind_coverage_depth.txt

# and get rid of the file extension and path leaving just the individual name and the mean depth
sed -i 's/\.bam//' mapping_info/per_ind_coverage_depth.txt
sed -i 's@.*/@@' mapping_info/per_ind_coverage_depth.txt

