# submitting roloway monkey pod5 files as a tar.gz archive to ENA

conda activate tmux

#tmux new -s laura # create a new session if necessary
tmux attach -t laura

srun --partition defq --cpus-per-task 1 --mem 50g --time 100:00:00 --pty bash


# # tried running on srun in a tmux window at work - that didn't work
# # tried running on a login node from home - that didn't work
# # send a test file using the written address from Sonal rather than the IP address
# curl --upload-file /share/StickleAss/OrgOne/roloway_monkey/test.txt \
# --verbose \
# --progress-bar \
# --user Webin-154:hjsH3ZTp ftp://webin2.ebi.ac.uk
# # this worked! Woohoo!!!!! Turns out they have changed the IP address again!! Bah!
# #193.62.193.143 # older IP address
# #193.62.193.163 # current IP address as of 15th March 2024


curl --upload-file /gpfs01/home/mbzlld/data/OrgOne/red_ruffed_lemur/pod5_files/simplex/red_ruffed_lemur_P1_pod5s.tar.gz \
--verbose \
--progress-bar \
--user Webin-154:hjsH3ZTp ftp://webin2.ebi.ac.uk


# this submission took like 2 or 3 days for roloway monkey but completed successfully :D
# running for the western chimpanzee took a bit less time & successfully completed :)
# running for the black and white ruffed lemur took a couple of days and 2 attempts but completed successfully
# running for the brown spider monkey this only took about a day!


