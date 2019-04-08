git submodule update --init -- riscv-pk
cd riscv-pk
git remote add firesim https://github.com/firesim/riscv-pk/
git fetch firesim
git cherry-pick -n e5846a2bc707eaa58dc8ab6a8d20a090c6ee8570..cad3deb357d25773a22e2c346ef464d3d66dd37c
cd ..

sed -i 's/..\/busybear-linux\/busybear.bin/..\/images\/br-disk.img/g' sdk/Makefile
sed -i 's/..\/busybear-linux\/busybear.bin/..\/images\/br-disk.img/g' linux-keystone-driver/Makefile
