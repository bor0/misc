# this uses backtrack approach, i.e. generated tree consists only of validated combinations of points
class Point:
    def __init__(self, x, y, value):
        self.x = x
        self.y = y
        self.value = value

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

    for t in tree:
        sudoku[t[0].x][t[0].y] = t[0].value

        pt = parse_tree(t[1], sudoku)

        if pt != False:
            return pt

        sudoku[t[0].x][t[0].y] = 0

    return False

def find_unassigned(sudoku):
    for i in range(0, 9):
        for j in range(0, 9):
            if sudoku[i][j] == 0:
                return (i, j)

    return False

def get_possible_values(sudoku, i, j):
    values = [1, 2, 3, 4, 5, 6, 7, 8, 9]

    for k in range(0, 9): # handle vertical and horizontal
        if sudoku[i][k] in values: values.remove(sudoku[i][k])
        if sudoku[k][j] in values: values.remove(sudoku[k][j])

    for k in range(0, 3): # handle 3x3 squares
        for l in range(0, 3):
            kk = i - i % 3
            ll = j - j % 3
            if sudoku[k+kk][l+ll] in values: values.remove(sudoku[k+kk][l+ll])

    return values

def make_tree(sudoku):
    L = []

    f = find_unassigned(sudoku)

    if f == False: return []

    i, j = f[0], f[1]

    values = get_possible_values(sudoku, i, j)

    for v in values:
        p = Point(i, j, v)
        sudoku[i][j] = v
        L.append((p, make_tree(sudoku)))

    sudoku[i][j] = 0

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

tree = make_tree(sudoku)

solution = parse_tree(tree, sudoku)

if solution:
    for i in solution:
        print(i)
