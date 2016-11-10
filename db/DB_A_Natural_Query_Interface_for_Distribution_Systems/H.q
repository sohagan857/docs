// Companion to _A natural query interface for distribution systems_ 
// a Kx Develop Briefing by Sean Keevey
// 2014.10.04

.H.H:([alias:`trade`quote`traders]host:`:localhost:29001`:localhost:29002`:localhost:29001;name:`t`q`traders; handle:3#0N);
//open handle to each distinct process
update handle:.Q.fu[hopen each] host from `.H.H;
//utilities to lookup handle or table-name for a given alias
.H.h:{.H.H[x[`handle]};
.H.n:{.H.H[x][`name]}; 


//check if subject of select/exec is configured as a remote table
.H.is_configured_remote:{$[(1 = count x 1)and(11h = abs type x 1);notnull .H.h first x 1;0b]};
//check valence and first list element to determine function
.H.is_select:{(count[x] in 5 6 7) and (?)~first x}; 
.H.is_update:{(count[x]=5) and (!)~first x}; 


.H.is_remote_exec:{$[.H.is_select[x] or .H.is_update[x]; .H.is_configured_remote[x];0b]}; 

.H.remote_evaluate:{(.H.h x 1)@(eval;@[x;1;.H.n])};

.H.E:{$[.H.is_remote_exec x;.H.E_remote x;1=count x;x;.z.s'[x]]}; 

.H.E_remote:{
	//need to examine for subqueries
	r:.H.remote_evaluate{$[(0h~type x)and not .H.is_remote_exec x;.z.s'[x];.H.is_remote_exec x;.H.E_remote x;x]}'[x];
	//need special handling for symbols so that they aren't
	//interpreted as references by name
	$[11h=abs type r;enlist r;r]}; 

.H.evaluate:{eval .H.E parse x}; 

.H.e:{@[.H.evaluate;x;{'"H-err -",x}]}; 
