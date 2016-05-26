### runbeast: scripts for running BEAST

This script makes running multiple (BEAST)[http://beast.bio.ed.ac.uk/] jobs easier by looking
for a standard directory structure, with the BEAST XML file in the current directory and one
subdirectory for each replicate you want to run, and then submitting jobs to the cluster
for each subdirectory it finds. So if you are in `/cip0/research/scratch/user/mybeast`
and the current directory contains `mybeastjob.xml` the script looks for all
subdirectories (e.g. ones names `rep1`, `rep2`, etc) and starts a BEAST job
in each subdirectory using `mybeastjob.xml` as input.

#### BEAST settings

The default way of running `runbeast.sh` is:

    runbeast.sh <XML filename>

where `<XML filename>` is the filename of your BEAST XML file. E.g.

    runbeast.sh mybeastjob.xml

This uses the default version of BEAST installed on the cluster. To see which versions
of BEAST are available use the command:

    module avail beast

By default BEAGLE support is also enabled. 

Further settings can be passed to the script using environment variables:

| Variable Name | Purpose                                     | Example                            |
| --------------|---------------------------------------------|------------------------------------|
| BEAST\_QUEUE  | Queue jobs will be submitted to.            | export BEAST\_QUEUE=gordon.q       |
| BEAST\_HMEM   | Amount of RAM requested for BEAST job       | export BEAST\_HMEM=10G             |
| BEAST\_SEED   | Manually set the BEAST random seed          | export BEAST\_SEED=1437498772784   |
| BEAGLE        | Flag passed to determine BEAGLE usage       | export BEAGLE=-beagle              |
| BEAST\_MEM    | Amount of heap space allocated to java VM   | export BEAST\_MEM=4096m            |
| BEAST\_STACK  | Amount of stack space allocated to java VM  | export BEAST\_STACK=128m           |

These need to be set before running `runbeast.sh`.
