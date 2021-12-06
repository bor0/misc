-- Construction of terms
-- Get these for free in Lisp due to symbolic calculation, or Haskell due to algebraic data structures)
function op_imp(x, y)
  return { x = x, y = y, op = "imp" }
end

function op_and(x, y)
  return { x = x, y = y, op = "and" }
end

function op_proof(x)
  return { x = x, op = "proof" }
end

-- Rules
-- Gotta go wild on the `if` checks due to lack of pattern matching
function rule_join(x, y)
  if type(x) ~= "table" or type(y) ~= "table" or x.op ~= "proof" or y.op ~= "proof" then
    return nil
  end

  return op_proof(op_and(x.x, y.x))
end

function rule_sep_l(x)
  if type(x) ~= "table" or x.op ~= "proof" or x.x.op ~= "and" then
    return nil
  end

  return op_proof(x.x.x)
end

function rule_fantasy(x, f)
  local prfx = op_proof(x)
  local res  = f(prfx)

  if res ~= null then
    return op_proof(op_imp(x, res.x))
  end

  return nil
end

-- In Haskell it's just `deriving Show`, in Lisp it's just.. nothing
-- In Lua, it's `pp` (pretty print)
function pp(x)
  if type(x) ~= "table" then
    return x
  end

  if x.op == "proof" then
    return "|- " .. pp(x.x)
  end

  if x.op == "and" then
    return "(" .. pp(x.x) .. ") & (" .. pp(x.y) .. ")"
  end

  if x.op == "imp" then
    return "(" .. pp(x.x) .. ") -> (" .. pp(x.y) .. ")"
  end
end

prfA = op_proof("A") -- axiom
prfB = op_proof("B") -- axiom
prf = rule_join(prfA, prfB)
print(pp(prf))

prf = rule_fantasy(op_and("A", "B"), function(x) return x end) -- no axioms
print(pp(prf))

prf = rule_fantasy(op_and("A", "B"), rule_sep_l)
print(pp(prf))
