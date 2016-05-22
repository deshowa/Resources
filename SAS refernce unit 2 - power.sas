proc power;
onesamplemeans
nullmean = 0 
mean = 5
stddev = 25
power = .8
ntotal = .;
run;
* tells us we need 199 observations to get that power
*the mean value is the value that you think is possible
* for the above, SAS assumes the probability of type 1 error, but you can specify
* let's add alpha;
proc power;
onesamplemeans
alpha = .01
mean = 5
stddev = 25
power = .8
ntotal = .;
run;
* need to find out what null mean defaulted to, but now we need alot more obs: 296

* if we change the alpha to .05, n = 199;
proc power;
onesamplemeans
alpha = .05
mean = 5
stddev = 25
power = .8
ntotal = .;
run;

* challenge question : how would we do the test for one tailed?;
* we would add the sides argument : sides: 1 = 1 side, 2 = 2 side, u = upper, l = lower

* calcing power for 2 sample t tests;
proc power;
twosamplemeans
alpha = .01
sides = 1
groupmeans = 10|14
stddev = 20
power = .8
ntotal = .;
run;

* what about using sattersthwaite approximation for df;
proc power; 
twosamplemeans test = diff_satt
meandiff = 3 6
groupstddevs = 7|7 9 12
power = .9
ntotal = .;
plot x = effect min = 3 max = 6;
run;
* gives curve for each possible combination of the stddevs
