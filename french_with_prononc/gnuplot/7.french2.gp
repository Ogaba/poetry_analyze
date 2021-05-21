# The polynomial approximation
#f(x) = a*(b-x)*(b-x)+c					# variance of residuals (reduced chisquare) = WSSR/ndf   : 3161.53
f(x) = a*(b-x)*(b-x)*(b-x)+c*(b-x)*(b-x)+d*(b-x)+e	# variance of residuals (reduced chisquare) = WSSR/ndf   : 1137.92
 
# Initial values for parameters
a = 0.1
b = 0.1
c = 0.1
d = 0.1
e = 0.1
 
# Fit f to the following data by modifying the variables
fit f(x) '-' via a, b, c, d, e
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
 
#print sprintf("\n --- \n Polynomial fit: %.4f*(%.4f-x)**2+%.4f\n", a, b, c)
print sprintf("\n --- \n Polynomial fit: %.4f*(%.4f-x)*(%.4f-x)*(%.4f-x)+%.4f*(%.4f-x)*(%.4f-x)+%.4f*(%.4f-x)+%.4f\n", a, b, b, b, c, b, b, d, b, e)
