# this uses bruteforce approach, i.e. generated tree consists of all combinations of points
class Point:
    def __init__(self, x, y, values):
        self.x = x
        self.y = y
        self.values = values

def check_win(sudoku):
    for i in range(0, 9):
        L = []
        for j in range(0, 9):
            if sudoku[i][j] in L or sudoku[i][j] == 0:
                return False
            L.append(sudoku[i][j])

    return True

def parse_tree(tree, sudoku):
    if check_win(sudoku):
        return sudoku

    if tree == []:
        return False

    for i in tree[0].values:
        sudoku[tree[0].x][tree[0].y] = i

        pt = parse_tree(tree[1], sudoku, unknowns - 1)
        if pt != False:
            return pt

    sudoku[tree[0].x][tree[0].y] = 0

    return False

def make_tree(L, depth = None):
    if depth == None:
        depth = len(L) - 1
        return make_tree(list(reversed(L)), depth)

    if depth == 0:
        return [L[depth], []]

    return [L[depth], make_tree(L, depth - 1)]

def make_points(sudoku):
    L = []

    for i in range(0, 9):
        for j in range(0, 9):
            if sudoku[i][j] == 0:
                values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
                for k in range(0, 9): # handle vertical and horizontal
                    if sudoku[i][k] in values: values.remove(sudoku[i][k])
                    if sudoku[k][j] in values: values.remove(sudoku[k][j])
                for k in range(0, 3): # handle 3x3 squares
                    for l in range(0, 3):
                        kk = i - i % 3
                        ll = j - j % 3
                        if sudoku[k+kk][l+ll] in values: values.remove(sudoku[k+kk][l+ll])
                p = Point(i, j, values)
                L.append(p)

    return L

sudoku = [
    [3, 0, 6, 5, 0, 8, 4, 0, 0],
    [5, 2, 0, 0, 0, 0, 0, 0, 0],
    [0, 8, 7, 0, 0, 0, 0, 3, 1],
    [0, 0, 3, 0, 1, 0, 0, 8, 0],
    [9, 0, 0, 8, 6, 3, 0, 0, 5],
    [0, 5, 0, 0, 9, 0, 6, 0, 0],
    [1, 3, 0, 0, 0, 0, 2, 5, 0],
    [0, 0, 0, 0, 0, 0, 0, 7, 4],
    [0, 0, 5, 2, 0, 6, 3, 0, 0]
]

points = make_points(sudoku)
tree = make_tree(points)

solution = parse_tree(tree, sudoku)

if solution:
    for i in solution:
        print(i)
