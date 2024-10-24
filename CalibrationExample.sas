
/*Example*/
%let N=1000;
%let inclprob =0.2;

data prob;
	do unitid = 1 to &N;
		prob=&inclprob;
		output;
	end;
run;

data weight;
	set prob;
	weight=1/prob;
	if rand('uniform') < 0.2 then do;
		lb=1;
		ub=3;
	end;
	else do;
		lb=1;
		ub=8;
	end;
run;

data coef;

	do unitid = 1 to &N;
		var1=1;
		var2=rand('Bernoulli',0.5);
		var3=rand('Bernoulli',0.5);
		var4=rand('Bernoulli',0.5);
		var5=rand('Bernoulli',0.5);
		var6=rand('Bernoulli',0.5);
		var7=rand('Bernoulli',0.5);
		var8=rand('Bernoulli',0.5);
		var9=rand('Bernoulli',0.5);
		var10=rand('Bernoulli',0.5);
		output; 
	end;
run;
data BalCoef;
	merge weight(keep=unitid weight) coef;
run;
proc means data= BalCoef noprint; weight weight; var var1 var2 var3 var4 var5 var6 var7 var8 var9 var10; output out=BalSum sum= /autoname;run;
proc transpose data=BalSum out= TBalSum;run;
data targets(keep=consId target);
	length consId $6;
	set TBalSum;
	if _N_ >2;
	consId=_NAME_;
	pos=find(consID,"_");
	consId=substr(ConsId,1,pos-1);
	target=Col1*(rand('uniform')+0.5);
run;
proc delete data= BalSum TBalSum;run;


options notes;
%Calibration(weight,consCoef=coef,Targets=targets,DataOut=Calweight);

