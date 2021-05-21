# The polynomial approximation
#f(x) = a*(b-x)*(b-x)+c					# variance of residuals (reduced chisquare) = WSSR/ndf   : 208284
#f(x) = a*(1-x)*(1-x)+b*x*(1-x)+c*x*x+d					# variance of residuals (reduced chisquare) = WSSR/ndf   : 224306
#f(x) = a*(e-x)*(e-x)+b*x*(e-x)+c*x*x+d					# variance of residuals (reduced chisquare) = WSSR/ndf   : 242999
f(x) = a*(e-x)*(e-x)*(e-x)+b*x*(e-x)*(e-x)+c*x*x*(e-x)+d*x*x*x					# variance of residuals (reduced chisquare) = WSSR/ndf   : 70294.3
#f(x) = a*(b-x)*(b-x)*(b-x)+c*(b-x)*(b-x)+d*(b-x)+e	# variance of residuals (reduced chisquare) = WSSR/ndf   : 70294.3
#f(x) = -a*(b-x)*(b-x)*(b-x)*(b-x)-c*(b-x)*(b-x)*(b-x)-d*(b-x)*(b-x)-e*(b-x)-f	# variance of residuals (reduced chisquare) = WSSR/ndf   : 66743.8
#f(x) = -a*(b-x)*(b-x)*(b-x)*(b-x)-c*(b-x)*(b-x)-d	# variance of residuals (reduced chisquare) = WSSR/ndf   : 259397
#f(x) = -a*x*x-b*x-c					# variance of residuals (reduced chisquare) = WSSR/ndf   : 208284
 
# Initial values for parameters
a = 0.1
b = 0.1
c = 0.1
d = 0.1
e = 0.1
f = 0.1
 
# Fit f to the following data by modifying the variables
fit f(x) '-' via a, b, c, d, e
2 17
3 114
4 423
5 933
6 1424
7 1700
8 1705
9 1514
10 1030
11 644
12 354
13 154
14 75
15 21
16 10
17 4
18 3
e
 
#print sprintf("\n --- \n Polynomial fit: %.4f*(%.4f-x)**2+%.4f\n", a, b, c)
print sprintf("\n --- \n Polynomial fit: %.4f*(%.4f-x)*(%.4f-x)*(%.4f-x)+%.4f*(%.4f-x)*(%.4f-x)+%.4f*(%.4f-x)+%.4f\n", a, b, b, b, c, b, b, d, b, e)
