# The polynomial approximation
#f(x) = a*x**5 + b*x**4 + c*x**3 + d*x**2 + e*x + f
#f(x) = a*exp(b/x)+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 332.7
#f(x) = a*exp(b/(x+11))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 229.045
#f(x) = a*exp(b/(x+10))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 221.571
#f(x) = a*exp(b/(x+9))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 213.621
#f(x) = a*exp(b/(x+8))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 205.176
#f(x) = a*exp(b/(x+7))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 196.232
#f(x) = a*exp(b/(x+6))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 186.819
#f(x) = a*exp(b/(x+5))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 177.039
#f(x) = a*exp(b/(x+4))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 167.144
#f(x) = a*exp(b/(x+3))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 157.716
#f(x) = a*exp(b/(x+2))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 150.167
#f(x) = a*exp(b/(x+1))+c			# variance of residuals (reduced chisquare) = WSSR/ndf   : 154.869
f(x) = a*exp(b/(x+2))+c/((x+2)*(x+2))+d			# variance of residuals (reduced chisquare) = WSSR/ndf   : 10.6482
#f(x) = a*exp(b/(c*(x+11)))+d			# variance of residuals (reduced chisquare) = WSSR/ndf   : 
#f(x) = a*exp(b/(c*(x+11)))+d*log(x)+e
#f(x) = exp(1/(x*x+a))+log(x*x+b)+c
#f(x) = a*exp(b/(x+11))+c*log(x*x)+d
#f(x) = a*exp(1/((x+11)))+b*log(x)+c
#f(x) = a*exp(1/((x+11)))+b			# variance of residuals (reduced chisquare) = WSSR/ndf   : 
#f(x) = a*exp(b/(x+11))+c*log(d*(x+11))+e	# variance of residuals (reduced chisquare) = WSSR/ndf   : 
#f(x) = a*exp(b/(x+11))+c*log(x+11)+d		# variance of residuals (reduced chisquare) = WSSR/ndf   : 
#f(x) = a*exp(b/(x+11))*log(x+11)+c		# variance of residuals (reduced chisquare) = WSSR/ndf   : 
#f(x) = (-1/log(0.5))*(b*(1-0.5)*exp(-b*x))/(1-(1-0.5)*exp(-b*x))
#f(x) = (b/a)*(x/a)**(b-1)/((1+(x/a)**(b))**2)
#f(x) = a/x+b					# variance of residuals (reduced chisquare) = WSSR/ndf   : 
#f(x) = a*exp(b/(x+11))+c/((x+11)*(x+11))+d      # variance of residuals (reduced chisquare) = WSSR/ndf   : 134.695
 
# Initial values for parameters
a = 0.1
b = 0.1
c = 11
d = 0.1
e = 0.1
f = 0.1
 
# Fit f to the following data by modifying the variables
fit f(x) '-' via a, b, c, d
#fit f(x) '-' via a, b, c
1 435
2 257
3 204
4 177
5 171
6 163
7 156
8 151
9 148
10 140
11 136
12 124
13 120
14 118
15 104
16 99
17 96
18 93
19 91
20 90
21 89
22 87
23 85
24 82
25 79
26 79
27 78
28 75
29 74
30 74
31 74
32 74
33 73
34 69
35 68
36 67
37 67
38 65
39 62
40 62
41 61
42 61
43 59
44 59
45 58
46 57
47 57
48 57
49 57
50 55
51 55
52 54
53 54
54 52
55 51
56 51
57 50
58 50
59 49
60 49
e
 
#print sprintf("\n --- \n Polynomial fit: %.4f x^2 + %.4f x + %.4f\n", a, b, c)
#print sprintf("\n --- \n Exponantial fit: %.4f/(%.4f * (exp(x)) + %.4f\n", a, b, c)
#print sprintf("\n --- \n Exponantial fit: %.4f*exp(%.4f/((x+11)))+%.4f*log(x*x)+%.4f\n", a, b, c, d)
#print sprintf("\n --- \n Exponantial fit: %.4f*exp(%.4f/((x+11)))+%.4f*log(x+11)+%.4f\n", a, b, c, d)
#print sprintf("\n --- \n Exponantial fit: %.4f*exp(%.4f/((x+11)))*log(x+11)+%.4f\n", a, b, c)
print sprintf("\n --- \n Exponantial fit 10: %.4f*exp(%.4f/(x+2))+%.4f/((x+2)**2)+%.4f\n", a, b, c, d)
