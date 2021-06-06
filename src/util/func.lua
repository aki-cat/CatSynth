local Func = {}

function Func.noop()
    -- Does nothing
end

function Func.bind(f, v, ...)
    return function(...)
        return f(v, ...)
    end
end

return Func
