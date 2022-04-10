import pprint

# Manually constructing the syntax here
def Var(x): return {'children': [], 'expr': x, 'rule': 'var'}
def And(x, y): return { 'expr': 'and', 'rule': 'conj', 'children': [x, y]}
def Not(x): return {'expr': 'not', 'rule': 'neg', 'children': [x]}

def Imp(x, y): return { 'expr': 'imp', 'rule': 'impl', 'children': [x, y]}
def Proof(x): return {'children': [x], 'expr': 'prf', 'rule': 'proof'}
def FromProof(x):
  if not isinstance(x, dict) or not 'children' in x or x['rule'] != 'proof': return None
  return x['children'][0]
def RuleSepL(x):
  if x['rule'] == 'proof': return Proof(FromProof(x)['children'][0])
  else: return None
def RuleSepR(x):
  if x['rule'] == 'proof': return Proof(FromProof(x)['children'][1])
  else: return None
def RuleFantasy(x, y):
  if not isinstance(x, dict) or not 'rule' in x or not callable(y): return None
  return Proof(Imp(x, FromProof(y(Proof(x)))))

pprint.pprint(RuleFantasy(And(Var('p'), Var('q')), RuleSepL))

def rule_match(grammar, expr, rule_name, partial = False):
  for rule in grammar[rule_name]:
    (process_next, rules_applied, expr_tok, rule_tok) = (False, { 'children': [] }, expr.split(' '), rule.split(' '))
    for token in rule_tok:
      # string has been consumed but not all rule rule_tok were rules_applied
      if expr_tok == []: process_next = True; break # proceed to next rule
      if token not in grammar:
        # treat literal as string since it's not defined in the grammar list
        if token != expr_tok[0]: process_next = True; break # proceed to next rule
        expr_tok.pop(0)
        rules_applied['expr'] = token
      else:
        # treat token as a grammar name
        [new_expr_tok, new_rules_applied, valid] = rule_match(grammar, ' '.join(expr_tok), token, True)
        if not valid: process_next = True ; break # proceed to next rule
        # skip adding empty nodes
        rules_applied['children'].append(new_rules_applied)
        # now that it's valid, use the new_expr_tok which is the remaining of the expr
        expr_tok = new_expr_tok
    # either the string is fully parsed, or this is a sub-call (we still have more stuff to parse)
    rules_applied['rule'] = rule_name
    if not process_next and (expr_tok == [] or partial):
      if not ('expr' in rules_applied): rules_applied = rules_applied['children'].pop()
      return [expr_tok, rules_applied, True]
  return [[], {}, False]

def grammar_match(grammar, expr):
  for rule_name in grammar:
    [ _, rules_applied, valid ] = rule_match(grammar, expr, rule_name)
    if valid:
      return rules_applied
  return False

"""
var  := "p" | "q" | "r"
expr := var | not expr | and expr expr | imp expr expr
prf  := proof expr
"""

# Instead of manually constructing the syntax, rely on a grammar and a grammar parser
grammar = {
  'var':  [ 'p', 'q', 'r' ],
  'neg':  [ 'not expr' ],
  'conj': [ 'and expr expr' ],
  'impl': [ 'imp expr expr' ],
  'expr': [ 'var', 'neg', 'conj', 'impl' ],
  'prf': [ 'proof expr' ],
}

foo = grammar_match(grammar, 'and p q')
pprint.pprint(RuleFantasy(foo, RuleSepL))
