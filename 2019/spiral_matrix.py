grid = [[ 1, 2, 3, 4, 5 ],
        [ 6, 7, 8, 9, 10 ],
        [ 11, 12, 13, 14, 15 ],
        [ 16, 17, 18, 19, 20 ]]

def get_next_index(current_index, grid):
    (y, x, visited, direction) = current_index
    (size_y, size_x) = (len(grid), len(grid[0]))

    if size_y * size_x == len(visited):
        return False

    directions = [['r', x + 1 < size_x and (y, x + 1) not in visited, (y, x + 1), 'd'],
                  ['d', y + 1 < size_y and (y + 1, x) not in visited, (y + 1, x), 'l'],
                  ['l', x - 1 >= 0     and (y, x - 1) not in visited, (y, x - 1), 'u'],
                  ['u', y - 1 >= 0     and (y - 1, x) not in visited, (y - 1, x), 'r']]

    for (it_direction, it_cond, (x_coord, y_coord), next_direction) in directions:
        if direction == it_direction:
            if it_cond:
                # Try moving respectively
                return (x_coord, y_coord, visited + [(x_coord, y_coord)], direction)
            else:
                # Change direction
                return get_next_index((y, x, visited, next_direction), grid)

def matrix_spiral_print(M):
    next_index = (0, 0, [(0, 0)], 'r')

    while next_index:
        print(M[next_index[0]][next_index[1]])
        next_index = get_next_index(next_index, M)

matrix_spiral_print(grid)
