-- Construction of terms
-- Get these for free in Lisp due to symbolic calculation, or Haskell due to algebraic data structures)

-- Construct imp
function term_imp(x, y)
  return { x = x, y = y, type = "imp" }
end

-- Construct and
function term_and(x, y)
  return { x = x, y = y, type = "and" }
end

-- Construct a proof for a term (don't use directly)
function term_proof(x)
  return { x = x, type = "proof" }
end

-- Given a proof, return its term
function from_proof(x)
  if type(x) ~= "table" or x.type ~= "proof" then
    return nil
  end
  return x.x
end

-- Rules
-- Gotta go wild on the `if` checks due to lack of pattern matching
function rule_join(x, y)
  if type(x) ~= "table" or type(y) ~= "table" or x.type ~= "proof" or y.type ~= "proof" then
    return nil
  end

  return term_proof(term_and(from_proof(x), from_proof(y)))
end

-- This rule accepts a proof that A&B, and returns A. i.e. A&B |- A
function rule_sep_l(x)
  if type(x) ~= "table" or x.type ~= "proof" or from_proof(x).type ~= "and" then
    return nil
  end

  return term_proof(from_proof(x).x)
end

-- This rule accepts a term x, and returns a proof of the form |- x -> f(x).
function rule_impintro(x, f)
  if type(x) ~= "table" and x.type ~= "imp" and x.type ~= "and" then
    return nil
  end

  local prfx = term_proof(x)
  local res  = f(prfx)

  if res ~= null then
    return term_proof(term_imp(x, from_proof(res)))
  end

  return nil
end

-- In Haskell it's just `deriving Show`, in Lisp it's just.. nothing
-- In Lua, it's `pp` (pretty print)
function pp(x)
  if type(x) ~= "table" then
    return x
  end

  if x.type == "proof" then
    return "|- " .. pp(x.x)
  end

  if x.type == "and" then
    return "(" .. pp(x.x) .. ") & (" .. pp(x.y) .. ")"
  end

  if x.type == "imp" then
    return "(" .. pp(x.x) .. ") -> (" .. pp(x.y) .. ")"
  end
end

prf1 = rule_impintro(term_and("A", "B"), function(x) return x end)
print(pp(prf1))

prf2 = rule_impintro(term_and("A", "B"), rule_sep_l)
print(pp(prf2))

prf3 = rule_join(prf1, prf2)
print(pp(prf3))
