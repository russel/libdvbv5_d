#!/bin/sh

location=libdvbv5_d/source_new

mkdir -p $location
rm -rf $location/*

paths=$(ls -1 /usr/include/libdvbv5/*.h)

for p in $paths
do
    dstep --package libdvbv5_d --normalize-modules=true -o $location/$(basename $p .h | sed 's/-/_/g').d $p
done
