from collections import OrderedDict

def question(q):
    if isinstance(q, str):
        return list(map(lambda x: "What do you mean by '%s'?" % x, q.split(" ")))
    return list(OrderedDict.fromkeys([y for x in list(map(question, q)) for y in x]))
