class Solution:
    def lengthLongestPath(self, input: str) -> int:
        input = input.split("\n")

        q     = ['']
        m     = 0

        for i in range(len(input)):
            file_or_dir   = input[i]
            current_depth = len(file_or_dir) - len(file_or_dir.lstrip('\t'))
            #remove leading tabs
            file_or_dir   = file_or_dir[current_depth:]
            #print("     => ", file_or_dir)
            #print("depth: ", depth, " current_depth:", current_depth)

            # if it's a file, just calculate
            if '.' in file_or_dir:
                abs_dir  = "/".join(q[:current_depth + 1])
                abs_path = abs_dir + file_or_dir
                #print("Path =>", abs_path)
                m = max(m, len(abs_path))
            else:
                # enter a new folder
                q = q[:current_depth + 1]
                q.append(file_or_dir)

        return m
