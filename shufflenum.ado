program define shufflenum 
    preserve
	clear
	args n s e  // n=no of columns=no of rows  s=seed e=column names
	mat c=J(1,`n'+1,0)  // creating a 1 X n+1 zero row vector
	set seed `s' // setting the seed
	   forval i=1/`n'{
	     numlist "1/`i'" // creating the numlist
         local numlist `r(numlist)' //passing numlist into a local 
         local numlist : subinstr local numlist " " ",", all       
         mat x = (`numlist') // passing numlist into a row vector after removing inverted commas from local
		 mat x=x'  // converting row vector to a column vector
		 svmat x   // converting to dataframe
	     gen random=runiform()   // generating random numbers 
	     sort random      // sorting based on the variable random
		 drop random      // dropping the random variable
		 mata: y=st_data(.,.)  // creating a copy of the dataset in mata
		 mata: y=y'     // converting to a row vector in mata
		 drop x1  // dropping variable x1
		 mata: st_matrix("y",y) // converting to standard stata matrix 
		 mat b=J(1,`n'+1-`i',0)  // appending n+1-i zeroes
		 mat z=y,b   // adding observations of row vector b to row vector y
		 mat x`i'=z'  // transposing matrix z
		 svmat x`i'  // converting matrix xi to dataframe
		 rename x`i' a`i' //renaming columns
		 mata: t=st_data(.,.)  //creating a copy of dataframe in mata
		 mata: st_matrix("t",t) // converting to standard stata matrix
		 mat t=t'  // transposing t
		 mat c=c\t // adding row vector to matrix c
		 drop a*  // clearing variables in current dataframe
		 }
	 mat c=c' // transposing matrix c
	 svmat c  // converting matrix c to a dataframe
	 drop c1  // dropping variable c1
	 drop in L  // dropping n+1 th row
	 local k=`n'+1
	 forval i=2/`k'{
	    local j=`i'-1
		rename c`i' `e'`j'  // renaming variables as per argument e. 
	}
	export excel using "Seed_`s'_Max_Obs_`n'.xlsx",sheet("data") sheetreplace firstrow(variables) //saving the excel file specifying seed and no of columns. 
end

