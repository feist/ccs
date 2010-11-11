./ccs -f test --createcluster rh5single
./ccs -f test --addquorumd label="foo"
./ccs -f test --addheuristic program="/bin/true" score="1"
./ccs -f test --addheuristic program="/bin/false" score="1"
