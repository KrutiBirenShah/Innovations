program define detpattskip
   args b c d s f   //b=first question in varlist c=last question in varlist d=common difference s=id variable f=threshold of repetitions
   unab vlist:`b'-`c'
   local suffix: display %tdCCYY-NN-DD =daily("`c(current_date)'", "DMY")
   local nvar: word count `vlist'
   forval j=1/`d'{
   	  forval i = `j'(`d')`nvar' {
         local nextvar: word `i' of `vlist'
         local newname = "`nextvar'" +"_" +"q`j'g`d'"
         rename `nextvar' `newname'
      }
	 egen pattskip_q`j'g`d'=concat(*_q`j'g`d')
   }
   gen repfreq=0
   gen pattname=""
   gen group=""
   foreach var of varlist pattskip_*{
	 duplicates tag `s' `var', gen(repfreq`var')
	 replace repfreq=repfreq`var' if repfreq`var'>=`f'
	 replace pattname=`var' if repfreq`var'>=`f'
     replace group="`var'" if repfreq`var'>=`f'
	}
   keep if repfreq>=`f'
   bysort `s' pattname group: gen dup=_n
   export excel `s' repfreq pattname group using "Skips_cheats_`suffix'" if dup==1, sheet("g`d'") sheetreplace firstrow(variables)
   drop pattname repfreq group dup 
end

