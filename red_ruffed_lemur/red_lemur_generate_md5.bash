


srun --partition defq --cpus-per-task 1 --mem 50g --time 8:00:00 --pty bash

# move to simplex directory
cd /gpfs01/home/mbzlld/data/OrgOne/red_ruffed_lemur/pod5_files/simplex

# generate md5 check sums
md5sum red_ruffed_lemur_P1_pod5s.tar.gz > red_ruffed_lemur_P1_pod5s.md5
md5sum red_ruffed_lemur_sheared_P1_pod5s.tar.gz > red_ruffed_lemur_sheared_P1_pod5s.md5

# move to duplex directory
cd /gpfs01/home/mbzlld/data/OrgOne/red_ruffed_lemur/pod5_files/duplex

# generate md5 check sums
md5sum red_ruffed_lemur_duplex_pod5s.tar.gz > red_ruffed_lemur_duplex_pod5s.md5




# move to duplex directory
cd /gpfs01/home/mbzlld/data/OrgOne/red_ruffed_lemur/pod5_files/duplex/
