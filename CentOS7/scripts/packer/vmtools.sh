# Use fully supported and open source open-vm-tools: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2073803
yum -y install open-vm-tools
systemctl enable vmtoolsd
