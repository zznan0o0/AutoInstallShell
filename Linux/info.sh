cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l
cat /proc/cpuinfo| grep "cpu cores"| uniq
cat /proc/cpuinfo| grep "processor"| wc -l
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
cat /proc/meminfo
df -h