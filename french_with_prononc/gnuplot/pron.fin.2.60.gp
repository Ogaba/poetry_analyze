# The polynomial approximation
#f(x) = a*x**5 + b*x**4 + c*x**3 + d*x**2 + e*x + f
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
#f(x) = a*exp(b/(x+12))+c/((x+12)*(x+12))+d      # variance of residuals (reduced chisquare) = WSSR/ndf   : 531
f(x) = a*exp(b/(x+11))+c/((x+11)*(x+11))+d      # variance of residuals (reduced chisquare) = WSSR/ndf   : 433
#f(x) = a*exp(b/(x+2))+c/((x+2)*(x+2))+d      # variance of residuals (reduced chisquare) = WSSR/ndf   : 511.199
#f(x) = a*exp(b/(x+3))+c/((x+3)*(x+3))+d      # variance of residuals (reduced chisquare) = WSSR/ndf   : 499.486
#f(x) = a*exp(b/(x+10))+c/((x+10)*(x+10))+d      # variance of residuals (reduced chisquare) = WSSR/ndf   : 
 
# Initial values for parameters
a = 0.1
b = 0.1
c = 0.1
d = 0.1
e = 0.1
f = 0.1
 
# Fit f to the following data by modifying the variables
fit f(x) '-' via a, b, c, d
1 702
2 683
3 425
4 304
5 255
6 233
7 223
8 204
9 198
10 191
11 175
12 164
13 151
14 146
15 129
16 123
17 121
18 113
19 108
20 105
21 101
22 100
23 93
24 93
25 92
26 90
27 86
28 86
29 76
30 75
31 74
32 70
33 70
34 70
35 68
36 64
37 63
38 60
39 57
40 55
41 55
42 53
43 50
44 49
45 48
46 48
47 47
48 47
49 47
50 46
51 46
52 46
53 45
54 45
55 45
56 45
57 44
58 44
59 43
60 43
e
 
#print sprintf("\n --- \n Polynomial fit: %.4f x^2 + %.4f x + %.4f\n", a, b, c)
#print sprintf("\n --- \n Exponantial fit: %.4f/(%.4f * (exp(x)) + %.4f\n", a, b, c)
#print sprintf("\n --- \n Exponantial fit: %.4f*exp(%.4f/((x+11)))+%.4f*log(x*x)+%.4f\n", a, b, c, d)
#print sprintf("\n --- \n Exponantial fit: %.4f*exp(%.4f/((x+11)))+%.4f*log(x+11)+%.4f\n", a, b, c, d)
#print sprintf("\n --- \n Exponantial fit: %.4f*exp(%.4f/((x+11)))*log(x+11)+%.4f\n", a, b, c)
print sprintf("\n --- \n Exponantial fit 10: %.4f*exp(%.4f/(x+11))+%.4f/((x+11)*(x+11))+%.4f\n", a, b, c, d)
#print sprintf("\n --- \n Exponantial fit 10: %.4f*exp(%.4f/(x+2))+%.4f/((x+2)**2)+%.4f\n", a, b, c, d)
