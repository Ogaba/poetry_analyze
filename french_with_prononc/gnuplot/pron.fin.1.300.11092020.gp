# The polynomial approximation
#f(x) = a*x**5 + b*x**4 + c*x**3 + d*x**2 + e*x + f
#f(x) = a*exp(b/(c*(x+11)))+d			# variance of residuals (reduced chisquare) = WSSR/ndf   : 21337.6
#f(x) = a*exp(b/(c*(x+11)))+d*log(x)+e
#f(x) = exp(1/(x*x+a))+log(x*x+b)+c
#f(x) = a*exp(b/(x+11))+c*log(x*x)+d
#f(x) = a*exp(1/((x+11)))+b*log(x)+c
#f(x) = a*exp(1/((x+11)))+b			# variance of residuals (reduced chisquare) = WSSR/ndf   : 20317.3
#f(x) = a*exp(b/(x+11))+c*log(d*(x+11))+e	# variance of residuals (reduced chisquare) = WSSR/ndf   : 2248.64
#f(x) = a*exp(b/(x+11))+c*log(x+11)+d		# variance of residuals (reduced chisquare) = WSSR/ndf   : 2194.51
#f(x) = a*exp(b/(x+11))*log(x+11)+c		# variance of residuals (reduced chisquare) = WSSR/ndf   : 3058.01
#f(x) = (-1/log(0.5))*(b*(1-0.5)*exp(-b*x))/(1-(1-0.5)*exp(-b*x))
#f(x) = (b/a)*(x/a)**(b-1)/((1+(x/a)**(b))**2)
f(x) = a/x+b					# variance of residuals (reduced chisquare) = WSSR/ndf   : 9010.7
 
# Initial values for parameters
a = 0.1
b = 0.1
c = 0.1
d = 0.1
e = 0.1
f = 0.1
 
# Fit f to the following data by modifying the variables
#fit f(x) '-' via a, b, c, d
fit f(x) '-' via a, b
1 2880
2 2786
3 2082
4 1023
5 1014
6 887
7 645
8 633
9 610
10 560
11 554
12 546
13 497
14 410
15 404
16 385
17 372
18 345
19 316
20 313
21 291
22 285
23 284
24 282
25 269
26 265
27 258
28 253
29 250
30 246
31 242
32 236
33 235
34 226
35 221
36 216
37 210
38 210
39 207
40 200
41 197
42 196
43 195
44 195
45 193
46 185
47 184
48 183
49 183
50 176
51 175
52 174
53 173
54 173
55 173
56 172
57 171
58 169
59 168
60 167
61 162
62 156
63 150
64 150
65 143
66 142
67 136
68 134
69 134
70 133
71 133
72 131
73 131
74 131
75 130
76 130
77 127
78 126
79 124
80 120
81 119
82 119
83 116
84 115
85 114
86 114
87 113
88 113
89 113
90 112
91 111
92 109
93 109
94 106
95 106
96 105
97 104
98 102
99 100
100 99
101 99
102 98
103 98
104 98
105 95
106 95
107 95
108 94
109 93
110 93
111 93
112 93
113 92
114 91
115 90
116 89
117 89
118 88
119 88
120 87
121 87
122 86
123 86
124 85
125 85
126 85
127 84
128 83
129 82
130 81
131 81
132 81
133 80
134 80
135 80
136 80
137 79
138 79
139 79
140 79
141 78
142 77
143 77
144 77
145 76
146 76
147 75
148 73
149 72
150 72
151 72
152 71
153 71
154 71
155 70
156 70
157 70
158 68
159 68
160 68
161 67
162 66
163 66
164 66
165 65
166 65
167 64
168 64
169 63
170 63
171 62
172 62
173 62
174 61
175 61
176 61
177 61
178 61
179 61
180 60
181 60
182 59
183 59
184 58
185 56
186 56
187 56
188 56
189 56
190 55
191 55
192 55
193 55
194 55
195 54
196 54
197 54
198 53
199 53
200 53
201 53
202 53
203 53
204 52
205 52
206 52
207 50
208 50
209 50
210 50
211 50
212 50
213 50
214 50
215 49
216 49
217 48
218 48
219 48
220 48
221 47
222 46
223 46
224 46
225 46
226 46
227 45
228 45
229 45
230 45
231 45
232 45
233 44
234 44
235 44
236 44
237 44
238 44
239 43
240 43
241 43
242 43
243 43
244 43
245 43
246 43
247 42
248 42
249 42
250 42
251 41
252 41
253 41
254 41
255 40
256 40
257 40
258 40
259 40
260 40
261 40
262 40
263 40
264 39
265 39
266 39
267 39
268 39
269 39
270 39
271 39
272 39
273 39
274 38
275 38
276 38
277 38
278 37
279 37
280 37
281 37
282 37
283 37
284 37
285 37
286 37
287 36
288 36
289 36
290 36
291 36
292 35
293 35
294 35
295 35
296 35
297 35
298 35
299 35
300 35
e
 
#print sprintf("\n --- \n Polynomial fit: %.4f x^2 + %.4f x + %.4f\n", a, b, c)
#print sprintf("\n --- \n Exponantial fit: %.4f/(%.4f * (exp(x)) + %.4f\n", a, b, c)
#print sprintf("\n --- \n Exponantial fit: %.4f*exp(%.4f/((x+11)))+%.4f*log(x*x)+%.4f\n", a, b, c, d)
#print sprintf("\n --- \n Exponantial fit: %.4f*exp(%.4f/((x+11)))+%.4f*log(x+11)+%.4f\n", a, b, c, d)
print sprintf("\n --- \n Exponantial fit: %.4f*exp(%.4f/((x+11)))*log(x+11)+%.4f\n", a, b, c)
