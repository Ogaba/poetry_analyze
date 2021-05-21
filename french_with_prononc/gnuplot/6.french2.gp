# The polynomial approximation
f(x) = (b**p)*((1/(x-5.1))**(p+1))*exp(-b/(x-5.1))/(gamma(p))+a			# variance of residuals (reduced chisquare) = WSSR/ndf   : 6.21785e+06
#f(x) = a*(exp(-(sqrt(x)-b)*(sqrt(x)-b)/c))+d			# variance of residuals (reduced chisquare) = WSSR/ndf   : 17602.6
#f(x) = a*sqrt(x)*exp(-(x-b)*(x-b)/c)+d*sqrt(x)+e*sqrt(x)*log(x)+f*sqrt(x)*x+g		# variance of residuals (reduced chisquare) = WSSR/ndf   : 39934
#f(x) = a*exp(-(x-b)*(x-b)/c)+d*sqrt(x)+e*sqrt(x)*log(x)+f*x+g	# variance of residuals (reduced chisquare) = WSSR/ndf   : 44941.3
#f(x) = a*exp(-(x-b)*(x-b)/c)+d*log(x)+e*x+f			# variance of residuals (reduced chisquare) = WSSR/ndf   : 50319.8
#f(x) = a*exp(-(x-b)*(x-b)/c)+d*log(x)				# variance of residuals (reduced chisquare) = WSSR/ndf   : 117122
#f(x) = a*exp(-(x-b)*(x-b)/c)					# variance of residuals (reduced chisquare) = WSSR/ndf   : 120248
#f(x) = a + (b/(1 + (x/c)**(d)))
#f(x) = 75.18449 + 4204.51151/(1 + (x/8.688213)**13.34441)
#f(x) = a + exp(-(x-b)*(x-b))/(1 + (x/c)**(d))
 
# Initial values for parameters
a = 0.1
b = 1
p = 3
 
# Fit f to the following data by modifying the variables
fit [2:20] f(x) '-' via b, p
2 446
3 2248
4 5332
5 6864
6 6274
7 4548
8 2867
9 1647
10 886
11 453
12 212
13 99
14 59
15 27
16 12
17 8
18 4
19 3
20 2
e
 
#a*sqrt(x)*(exp(-(x-b)*(x-b)/c)+d*log(x)+e*x+f)+g
#print sprintf("\n --- \n Gaussian squareroot-log fit: %.4f*sqrt(x)*(exp(-(x-%.4f)*(x-%.4f)/%.4f)+*%.4f*log(x)+%.4f*x+%.4f)+%.4f\n", a, b, b, c, d, e, f, g)
#a*(exp(-(sqrt(x)-b)*(sqrt(x)-b)/c))+d
#print sprintf("\n --- \n Gaussian squareroot fit: %.4f*(exp(-(sqrt(x)-%.4f)*(sqrt(x)-%.4f)/%.4f)+*%.4f\n", a, b, b, c, d)
