-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaFloatMath.html

--codeExampleStart 1 -----------------------------------------------------------
> f=123.456
tty: stdin:1: malformed number near '123.456'
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
> =nxt.float(123, 456)
123.000457
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
> =nxt.float(123, 456000)
123.456001
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
> =nxt.float(-123, 456000)
-122.543998
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
> =nxt.float(-123, -456000)
-123.456001
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
> =-nxt.float(123, 456000)
-123.456001
--codeExampleEnd 6

--codeExampleStart 7 -----------------------------------------------------------
> =nxt.float(123)
123.000000
--codeExampleEnd 7

--codeExampleStart 8 -----------------------------------------------------------
> =nxt.float()
0.000000
--codeExampleEnd 8

--codeExampleStart 9 -----------------------------------------------------------
> =nxt.float(32456,9)
32456.000000
--codeExampleEnd 9

--codeExampleStart 10 -----------------------------------------------------------
> =nxt.float("08056.2984")
8056.298339
--codeExampleEnd 10

--codeExampleStart 10a -----------------------------------------------------------
> f=nxt.float("08056.2984")
> =nxt.int(f)
8056    298339
--codeExampleEnd 10a

--codeExampleStart 11 -----------------------------------------------------------
> =nxt.float("123.45E17")
1.234496E19
> =nxt.float("123.45e-10")
1.234500E-8
--codeExampleEnd 11

--codeExampleStart 12 -----------------------------------------------------------
> =1+2
3
--codeExampleEnd 12

--codeExampleStart 13 -----------------------------------------------------------
> ="11"+2
13
--codeExampleEnd 13

--codeExampleStart 14 -----------------------------------------------------------
> =1+4.567
tty: stdin:1: malformed number near '4.567'
> ="123.45"+98
tty: stdin:1: attempt to perform arithmetic on a string value
--codeExampleEnd 14

--codeExampleStart 15 -----------------------------------------------------------
> f=nxt.float(1)
> =f
1.000000
> =9+f
10.000000
--codeExampleEnd 15

--codeExampleStart 16 -----------------------------------------------------------
f=nxt.float(3)
g=nxt.float(4)
=f+g
7.000000

=f-g
-1.000000

=f*g
12.000000

=f/g
0.750000
--codeExampleEnd 16

--codeExampleStart 17 -----------------------------------------------------------
f=nxt.float(45,0)
=f
45.000000

f=nxt.float("45.0")
=f
45.000000

=nxt.sin(f)
0.707106

=nxt.sin(45)
0.707106

=nxt.sin("45")
0.707106
--codeExampleEnd 17

--codeExampleStart 18 -----------------------------------------------------------
f = nxt.float(49)
g = nxt.float(234)
=nxt.max(f,g)
234.000000

=nxt.min(f,g)
49.000000

f=49
g=234
=nxt.max(f,g)
234

=nxt.min(f,g)
49
--codeExampleEnd 18

--codeExampleStart 19 -----------------------------------------------------------
d = 56
=nxt.pi()*d
175.929199
--codeExampleEnd 19

--codeExampleStart 20 -----------------------------------------------------------
d = 56
t = nxt.TimerRead()
for i=1,10000 do
  c = nxt.pi()*d
end
print( "10,000 iterations in ", nxt.TimerRead()-t, " milliseconds " )
print( "c is ", c )

10,000 iterations in    3426     milliseconds 
c is    175.929199
--codeExampleEnd 20

--codeExampleStart 21 -----------------------------------------------------------
=nxt.float(355)/nxt.float(113)
3.141592

=nxt.pi()
3.141592

=355/113
3
--codeExampleEnd 21

--codeExampleStart 22 -----------------------------------------------------------
d = 56
t = nxt.TimerRead()
for i=1,10000 do
  c = (d*355)/113
end
print( "10,000 iterations in ", nxt.TimerRead()-t, " milliseconds " )
print( "c is ", c )

10,000 iterations in    304      milliseconds 
c is    175
--codeExampleEnd 22

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


