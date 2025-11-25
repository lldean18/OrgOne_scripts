

# setup tmux session
conda activate tmux
tmux attach

# request an interactive job
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash

rsync -rvh --progress prom@10.157.252.34:/data/ic_213 ./
