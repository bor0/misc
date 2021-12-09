-- Construction of terms
-- Get these for free in Lisp due to symbolic calculation, or Haskell due to algebraic data structures)

-- Construct not
function Not(x, y)
  return { x = x, type = "not" }
end

-- Construct and
function And(x, y)
  return { x = x, y = y, type = "and" }
end

-- Construct or
function Or(x, y)
  return { x = x, y = y, type = "or" }
end

-- Construct imp
function Imp(x, y)
  return { x = x, y = y, type = "imp" }
end

-- Construct a proof for a term (don't use directly)
function Proof(x)
  return { x = x, type = "proof" }
end

-- Given a proof, return its term
function FromProof(x)
  if type(x) ~= "table" or x.type ~= "proof" then
    error("Invalid type: FromProof")
  end

  return x.x
end

-- Rules
-- A, B |- A&B
function RuleJoin(x, y)
  if type(x) ~= "table" or type(y) ~= "table" or x.type ~= "proof" or y.type ~= "proof" then
    error("Invalid type: RuleJoin")
  end

  return Proof(And(FromProof(x), FromProof(y)))
end

-- A&B |- A
function RuleSepL(x)
  if type(x) ~= "table" or x.type ~= "proof" or FromProof(x).type ~= "and" then
    error("Invalid type: RuleSepL")
  end

  return Proof(FromProof(x).x)
end

-- A&B |- B
function RuleSepR(x)
  if type(x) ~= "table" or x.type ~= "proof" or FromProof(x).type ~= "and" then
    error("Invalid type: RuleSepR")
  end

  return Proof(FromProof(x).y)
end

-- A |- !!A
function RuleDoubleTildeIntro(x)
  if type(x) ~= "table" or x.type ~= "proof" then
    error("Invalid type: RuleDoubleTildeIntro")
  end

  return Proof(Not(Not(FromProof(x))))
end

-- !!A |- A
function RuleDoubleTildeElim(x)
  if type(x) ~= "table" or x.type ~= "proof" then
    error("Invalid type: RuleDoubleTildeElim")
  end

  if FromProof(x).type ~= "not" or FromProof(x).x.type ~= "not" then
    return x
  end

  return Proof(FromProof(x).x.x)
end

-- |- x -> f(x)
function RuleFantasy(x, y)
  return Proof(Imp(x, FromProof(y(Proof(x)))))
end

-- Either !x->!y |- y->x or x->y |- !y -> !x
function RuleContra(x)
  if type(x) ~= "table" and x.type ~= "proof" then
    error("Invalid type: RuleContra")
  end

  local xx = FromProof(x)

  if xx.type == "imp" and xx.x.type == "not" and xx.y.type == "not" then
    return Proof(Imp(xx.y.x, xx.x.x))
  end

  if xx.type == "imp" then
    return Proof(Imp(Not(xx.y), Not(xx.x)))
  end

  return x
end

-- Either !x&!y |- !(x|y) or !(x|y) |- !x & !y
function RuleDeMorgan(x)
  if type(x) ~= "table" and x.type ~= "proof" then
    error("Invalid type: RuleDeMorgan")
  end

  local xx = FromProof(x)

  if xx.type == "and" and xx.x.type == "not" and xx.y.type == "not" then
    return Proof(Not(Or(xx.x.x, xx.y.x)))
  end

  if xx.type == "not" and xx.x.type == "or" then
    return Proof(And(Not(xx.x.x), Not(xx.x.y)))
  end

  return x
end

-- Either x|y |- !x->y or !x->y |- x|y
function RuleSwitcheroo(x)
  if type(x) ~= "table" and x.type ~= "proof" then
    error("Invalid type: RuleSwitcheroo")
  end

  local xx = FromProof(x)

  if xx.type == "or" then
    return Proof(Imp(Not(xx.x), xx.y))
  end

  if xx.type == "imp" and xx.x.type == "not" then
    return Proof(Or(xx.x.x, xx.y))
  end

  return xx
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

  if x.type == "not" then
    return "!(" .. pp(x.x) .. ")"
  end

  if x.type == "and" then
    return "(" .. pp(x.x) .. ") & (" .. pp(x.y) .. ")"
  end

  if x.type == "or" then
    return "(" .. pp(x.x) .. ") | (" .. pp(x.y) .. ")"
  end

  if x.type == "imp" then
    return "(" .. pp(x.x) .. ") -> (" .. pp(x.y) .. ")"
  end
end

prf1 = RuleFantasy("X", function(x) return x end)
print(pp(prf1))

prf2 = RuleFantasy(And("X", "Y"), function(x) return RuleJoin(RuleSepR(x), RuleSepL(x)) end);
print(pp(prf2))

prf3 = RuleDoubleTildeIntro(prf2)
print(pp(prf3))

prf4 = RuleDoubleTildeElim(prf3)
print(pp(prf4))

prf5 = RuleFantasy(Imp(Not("X"), Not("Y")), RuleContra)
print(pp(prf5))

prf6 = RuleFantasy(Imp("X", "Y"), RuleContra)
print(pp(prf6))

prf7 = RuleFantasy(And(Not("X"), Not("Y")), RuleDeMorgan)
print(pp(prf7))

prf8 = RuleFantasy(Not(Or("X", "Y")), RuleDeMorgan)
print(pp(prf8))

prf9 = RuleFantasy(Or("X", "Y"), RuleSwitcheroo)
print(pp(prf9))

prf10 = RuleFantasy(Imp(Not("X"), "Y"), RuleSwitcheroo)
print(pp(prf10))
