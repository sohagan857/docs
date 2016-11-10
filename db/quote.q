// Companion to _A natural query interface for distribution systems_ 
// a Kx Develop Briefing by Sean Keevey
// 2014.10.04

\p 29002
//set random seed
\S 1 

rnorm:{$[x=2*n:x div 2;raze sqrt[-2*log n?1f]*/:(sin;cos)@\:(2*acos - 1)*n?1f;-1_.z.s 1+x]};
q:([]time:asc 1000?01:00:00.000000000;sym:`g#1000?`ABC`DEF`GHI;bsize:1000*1+1000?10;bid:1000#0N;ask:1000#0N;asize:1000*1+1000?10); 

//simulate bids as independent random walks
update bid:abs rand[100f]+sums rnorm[count i] by sym from `q; 

//asks vary above bids
update ask:bid + count[i]?0.5 from `q; 
