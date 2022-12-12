program define detpattconsec
   preserve
   args a c d e f // a=variable name c=id variable  d= length of substring  e=length of an answer value  f=threshold of repetitions
   local i=1
   local suffix: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
   while `i'<=1+strlen(`a')-`d'{
	  gen pattconsec_q`i'_g`d'=substr(`a',`i',`d')
	  local i=`i'+`e'
   }
   gen repfreq=0
   gen pattname=""
   gen group=""
   foreach var of varlist pattconsec_*{
	  duplicates tag `c' `var', gen(repfreq`var')
	  replace repfreq=repfreq`var' if repfreq`var'>=`f'
	  replace pattname=`var' if repfreq`var'>=`f'
	  replace group="`var'" if repfreq`var'>=`f'
   }
   keep if repfreq>=`f'
   bysort `c' pattname group : gen dup=_n
   export excel `c' repfreq pattname group using "Consec_cheats__`a'_`suffix'" if dup==1, sheet("g`d'") sheetreplace firstrow(variables)
end

