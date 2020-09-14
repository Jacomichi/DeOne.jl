mutable struct Variable
    data::Union{Array,Nothing}
    grad
    creator
end

Variable(data) = Variable(data,nothing,nothing)

abstract type Func end

mutable struct Square <:Func
    input
    output
end

mutable struct Expo <: Func
    input
    output
end

Expo() = Expo(nothing,nothing)
Square() = Square(nothing,nothing)

function forward(square::Square,x::Variable)
    square.input = x
    y = Variable(x.data .* x.data)
    y.creator = square
    square.output = y
    return y
end

function backward(square::Square,grad)
    return 2 * square.input.data .* grad
end

function forward(expo::Expo,x::Variable)
    expo.input = x
    y = Variable(exp.(x.data))
    y.creator = expo
    expo.output = y
    return y
end

function backward(expo::Expo,grad)
    return exp.(expo.input.data) .* grad
end

function ones_like(data)
    return ones(eltype(data),size(data))
end

function backward(x::Variable)
    if isnothing(x.grad)
        x.grad = ones_like(x.data)
    end

    func = Any[]
    append!(func,[x.creator])

    while !isempty(func)
        f = pop!(func)
        z,y = f.output,f.input
        println(z)
        y.grad = backward(f,z.grad)
        if y.creator != nothing
            append!(func,[y.creator])
        end
    end
end
