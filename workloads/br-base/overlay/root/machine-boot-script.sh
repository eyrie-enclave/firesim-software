cd /root
insmod keystone-driver.ko
#/bin/login -f root
cd /root
./test-runner.riscv attestation.eapp_riscv eyrie-rt
#for i in {1..10}; do ./test-runner.riscv attestation.eapp_riscv eyrie-rt; done
poweroff
