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

sed -i 's/..\/busybear-linux\/busybear.bin/..\/images\/br-base.img/g' sdk/Makefile
sed -i 's/..\/busybear-linux\/busybear.bin/..\/images\/br-base.img/g' linux-keystone-driver/Makefile
