using Test
include("grad.jl")

x = Variable([2.0])
A = Square()
y = forward(A,x)
@test y.data[1] == 4.0

backward(y)
@test x.grad == 2.0

println("Test is done")
