--datatype Expr = Add(Expr, Expr) | Sub(Expr, Expr) | Lit(nat)

function expr_add(e1, e2, value)
  return { type = 'expr', constructor = 'add', args = { e1, e2 } }
end

function expr_sub(e1, e2, value)
  return { type = 'expr', constructor = 'sub', args = { e1, e2 } }
end

function expr_lit(n)
  return { type = 'expr', constructor = 'lit', args = { tonumber(n) } }
end

function eval(e)
  if e.type ~= 'expr' then error("Invalid expression type " .. e.type) end

  if e.constructor == 'lit' then return e.args[1] end
  if e.constructor == 'add' then return (eval(e.args[1]) + eval(e.args[2])) end
  if e.constructor == 'sub' then return (eval(e.args[1]) - eval(e.args[2])) end

  error("Invalid expression constructor " .. e.constructor)
end

eg1 = expr_add(expr_lit(1), expr_lit(2))
