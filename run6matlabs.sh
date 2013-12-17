#!/bin/sh
matlab13  -r "makeHistograms(1,2,4); exit" &
matlab13  -r "makeHistograms(1,3,4); exit" &
matlab13  -r "makeHistograms(1,4,4); exit" &
matlab13  -r "makeHistograms(2,2,4); exit" &
matlab13  -r "makeHistograms(2,3,4); exit" &
matlab13  -r "makeHistograms(2,4,4); exit" &

wait
echo "All 6 complete."