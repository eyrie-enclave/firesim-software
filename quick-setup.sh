#!/bin/bash
KEYSTONE_ROOT=""
if [!$KEYSTONE_ROOT]
then
    echo You must set KEYSTONE_ROOT in the script!
    exit 1
fi

git submodule update —init —recursive

# BBL patch
cd riscv-pk
git remote add firesim https://github.com/firesim/riscv-pk/
git fetch firesim
git checkout -f .
git cherry-pick -n e5846a2bc707eaa58dc8ab6a8d20a090c6ee8570..cad3deb357d25773a22e2c346ef464d3d66dd37c
cd ..

# linux patch
cd riscv-linux
git remote add upstream https://github.com/riscv/riscv-linux
git fetch upstream
git checkout -f riscv-linux-4.15-modules
git cherry-pick -n 87cb3b7930572ac03ffefeb4b5c473b899c9f875..cae6324ee35760c1ef91989c5e522ab35fa8375b
patch -p0 --forward --ignore-whitespace <  ../patches/linux-cma.patch || true
cd ..

# Build SDK
cd sdk
make all
export KEYSTONE_SDK_DIR=$(pwd)

# Copy and Build Tests
rm -rf test
cp -r $(KEYSTONE_ROOT)/tests .
sed -i ’s+OUTPUT_DIR=$VAULT_DIR/../../buildroot_overlay/root/$NAME+OUTPUT_DIR=../../../workloads/br-base/overlay/root+g’ tests/tests/vault.sh
./tests/tests/vault.sh
cd ..

# Linux Keystone Driver
cd linux-keystone-driver
sed -i ‘s+OVERLAY_DIR=../buildroot_overlay+OVERLAY_DIR=../workloads/br-base/overlay/root+g’ Makefile
make 
make copy
cd ..

# Marshal Commands
cd ../..
source sourceme-f1-manager.sh
cd sw/firesim-software
./marshal clean workloads/br-base.json
./marshal build workloads/br-base.json


