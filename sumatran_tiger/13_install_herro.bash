
# install dependent software
# install rustup
curl https://sh.rustup.rs -sSf | sh
# enter for default installation
# restart shell
# source cargo environment
. "$HOME/.cargo/env"
# check installation
rustc -V

# Rust is installed now. Great!

# To get started you may need to restart your current shell.
# This would reload your PATH environment variable to include
# Cargo's bin directory ($HOME/.cargo/bin).

# To configure your current shell, you need to source
# the corresponding env file under $HOME/.cargo.

# This is usually done by running one of the following (note the leading DOT):
# . "$HOME/.cargo/env"            # For sh/bash/zsh/ash/dash/pdksh
# source "$HOME/.cargo/env.fish"  # For fish
# [mbzlld@hpclogin02(Ada) rustup]$

# create herro environment
cd ~/software_bin
git clone https://github.com/dominikstanojevic/herro.git
cd herro
conda env create --file scripts/herro-env.yml

conda activate herro


# install libtorch
# first try proper install of libtorch
# download from the link in the herro github page
# copied to Ada with scp
# unzip libtorch
unzip ~/software_bin/libtorch-shared-with-deps-2.0.1+cu117.zip
#module load gcc-uoneasy/13.2.0
export LIBTORCH=/gpfs01/home/mbzlld/software_bin/libtorch
export LD_LIBRARY_PATH=$LIBTORCH/lib:$LD_LIBRARY_PATH
#RUSTFLAGS="-Ctarget-cpu=native-l$LD_LIBRARY_PATH" cargo build -q --release
RUSTFLAGS="-Ctarget-cpu=native" cargo build -v --release
# NO

# load pytorch module which might contain libtorch
module load pytorch-uon/gcc11.3.0/2.3.0 # having this loaded added a bunch of stuff to $LD_LIBRARY_PATH but nothing to $LIBTORCH
LIBTORCH_USE_PYTORCH=1
RUSTFLAGS="-Ctarget-cpu=native" cargo build -q --release
module unload pytorch-uon/gcc11.3.0/2.3.0
# NO

# try conda install of pytorch
conda install pytorch
LIBTORCH_USE_PYTORCH=1
RUSTFLAGS="-Ctarget-cpu=native" cargo build -q --release
# NO








