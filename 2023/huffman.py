class Node:
    def __init__(self, key, value, l = None, r = None):
        self.key = key
        self.value = value
        self.l = l
        self.r = r
    def __str__(self):
        return "{ key: %s, value: %s, l: %s, r: %s }" % (self.key, self.value, self.l, self.r)
    # need this for max()
    def __lt__(self, obj):
        return self.value < obj.value

def node_freqs(s):
    freq = {}

    # Store all chars' frequencies
    for i in list(s):
        if i not in freq: freq[i] = 0
        freq[i] += 1

    # Convert all chars to Nodes
    return [Node(k, v) for k, v in freq.items()]

"""
Generate a Huffman coding tree given a string.
Sort the letters by frequencies, and keep merging the two highest nodes together in a tree
"""
def huffman_tree(s):
    nodes = node_freqs(s)

    while len(nodes) > 1:
        # Get the two largest keys by frequence (m1, m2)
        # Node is sorted by .value (frequency)
        # While the key will be the string represented
        m2 = min(nodes, key=lambda x: x.value)
        nodes.remove(m2)
        m1 = min(nodes, key=lambda x: x.value)
        nodes.remove(m1)

        # Combine the frequency nodes
        nodes.append(Node(m1.key + m2.key, m1.value + m2.value, m1, m2))

    return nodes[0]

"""
Once a tree has been generated, we traverse it. Going left means bit 0, going right means bit 1
"""
def huffman_codes(tree, data = ''):
    q = [(tree, '')]
    d = {}

    while q:
        (tree, data) = q.pop()
        if not tree.l and not tree.r:
            d[tree.key] = data
        else:
            if tree.l: q.append((tree.l, '0' + data))
            if tree.r: q.append((tree.r, '1' + data))

    return d

tree = huffman_tree("helloworld")
print(huffman_codes(tree))
