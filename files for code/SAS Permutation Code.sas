*There is a lot of extra spaces to the right of the text here.
If you are using Notepad, I suggest turning off Word Wrap. -Chelsea;
                                                                                                                                                                                                                             
                                                                                                                                                                                                                             
data SSHA;                              * you will of course need to perform your own data step to load the creativity data.;                                                                                                
input womenormen score;                                                                                                                                                                                                      
datalines;                                                                                                                                                                                                                   
1      156                                                                                                                                                                                                                   
1      109                                                                                                                                                                                                                   
1      137                                                                                                                                                                                                                   
1      115                                                                                                                                                                                                                   
1      152                                                                                                                                                                                                                   
1      140                                                                                                                                                                                                                   
1      154                                                                                                                                                                                                                   
1      178                                                                                                                                                                                                                   
1      111                                                                                                                                                                                                                   
1      123                                                                                                                                                                                                                   
1      126                                                                                                                                                                                                                   
1      126                                                                                                                                                                                                                   
1      137                                                                                                                                                                                                                   
1      165                                                                                                                                                                                                                   
1      129                                                                                                                                                                                                                   
1      200                                                                                                                                                                                                                   
1      150                                                                                                                                                                                                                   
1      140                                                                                                                                                                                                                   
1      116                                                                                                                                                                                                                   
1      120                                                                                                                                                                                                                   
1      130                                                                                                                                                                                                                   
1      131                                                                                                                                                                                                                   
1      130                                                                                                                                                                                                                   
1      140                                                                                                                                                                                                                   
1      142                                                                                                                                                                                                                   
1      117                                                                                                                                                                                                                   
1      118                                                                                                                                                                                                                   
1      145                                                                                                                                                                                                                   
1      130                                                                                                                                                                                                                   
1      145                                                                                                                                                                                                                   
0      118                                                                                                                                                                                                                   
0      140                                                                                                                                                                                                                   
0      114                                                                                                                                                                                                                   
0      180                                                                                                                                                                                                                   
0      115                                                                                                                                                                                                                   
0      126                                                                                                                                                                                                                   
0      92                                                                                                                                                                                                                    
0      169                                                                                                                                                                                                                   
0      139                                                                                                                                                                                                                   
0      121                                                                                                                                                                                                                   
0      132                                                                                                                                                                                                                   
0      75                                                                                                                                                                                                                    
0      88                                                                                                                                                                                                                    
0      113                                                                                                                                                                                                                   
0      151                                                                                                                                                                                                                   
0      70                                                                                                                                                                                                                    
0      115                                                                                                                                                                                                                   
0      187                                                                                                                                                                                                                   
0      114                                                                                                                                                                                                                   
0      116                                                                                                                                                                                                                   
0      117                                                                                                                                                                                                                   
0      145                                                                                                                                                                                                                   
0      149                                                                                                                                                                                                                   
0      150                                                                                                                                                                                                                   
0      120                                                                                                                                                                                                                   
0      121                                                                                                                                                                                                                   
0      117                                                                                                                                                                                                                   
0      129                                                                                                                                                                                                                   
0      92                                                                                                                                                                                                                    
0      110                                                                                                                                                                                                                   
;                                                                                                                                                                                                                            
                                                                                                                                                                                                                             
* To get the observed difference;                                                                                                                                                                                            
proc ttest data=SSHA;  * You will need to change the dataset name here.;                                                                                                                                                     
                                                                                                                                                                                                                             
   class womenormen;    *and change the class variable to match yours here;                                                                                                                                                  
                                                                                                                                                                                                                             
   var score;          * and change the var name here.;                                                                                                                                                                      
                                                                                                                                                                                                                             
run;                                                                                                                                                                                                                         
                                                                                                                                                                                                                             
*borrowed code from internet ... randomizes observations and creates a matrix ... one row per randomization ;                                                                                                                
proc iml;                                                                                                                                                                                                                    
use SSHA;                        * change data set name here to match your data set name above;                                                                                                                              
read all var{womenormen score} into x;   *change varibale names here ... make sure it is class then var ... in that order.;                                                                                                  
p = t(ranperm(x[,2],1000));    *Note that the "1000" here is the number of permutations.;                                                                                                                                     
paf = x[,1]||p;                                                                                                                                                                                                              
create newds from paf;                                                                                                                                                                                                       
append from paf;                                                                                                                                                                                                             
quit;                                                                                                                                                                                                                        
                                                                                                                                                                                                                             
*calculates differences and creates a histogram;                                                                                                                                                                             
ods output conflimits=diff;                                                                                                                                                                                                  
proc ttest data=newds plots=none;                                                                                                                                                                                            
  class col1;                                                                                                                                                                                                                
  var col2 - col1001;                                                                                                                                                                                                        
run;                                                                                                                                                                                                                         
proc univariate data=diff;                                                                                                                                                                                                   
  where method = "Pooled";                                                                                                                                                                                                   
  var mean;                                                                                                                                                                                                                  
  histogram mean;                                                                                                                                                                                                            
run;                                                                                                                                                                                                                         
                                                                                                                                                                                                                             
*The code below calculates the number of randomly generated differences that are as extreme or more extreme thant the one observed (divide this number by 1000 you have the pvalue);                                         
*check the log to see how many observations are in the data set.... divide this by 1000 (or however many permutations you generated) and that is the (one sided)p-value;                                                     
data numdiffs;                                                                                                                                                                                                               
set diff;                                                                                                                                                                                                                    
where method = "Pooled";                                                                                                                                                                                                     
if abs(mean) >= 12.9;   *you will need to put the observed difference you got from t test above here.  note if you have a one or two tailed test.;                                                                           
run;                                                                                                                                                                                                                         
* just a visual of the rows produced ... you can get the number of obersvations from the last data step and the Log window.;                                                                                                 
proc print data = numdiffs;                                                                                                                                                                                                  
where method = "Pooled";                                                                                                                                                                                                     
run;                                                                                                                                                                                                                         
                                                                                                                                                                                                                             
                                                                                                                                                                                                                             
*Idea from http://sas-and-r.blogspot.com/2011/10/example-912-simpler-ways-to-carry-out.html ;
