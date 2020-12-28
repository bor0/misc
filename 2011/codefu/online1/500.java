import java.util.Comparator;

/**
 *
 * @author b.sitnikovski
 */
public class DirectoryNavigation {

    // Directory Navigation
    String dirname = "";
    DirectoryNavigation[] sub = new DirectoryNavigation[50];
    int count = 0;
    // Directory Navigation
    DirectoryNavigation root, tmp; int thecounter = 0;
    String commands = ""; String []q = new String[1024];

    public void countTree(DirectoryNavigation root) {
        if (root.dirname.equals("/") == false) {
            commands += "cd " + root.dirname + ";";
        }
        for (int i = 0; i < root.count; i++) {
            if (root.dirname.equals("/") == true) {
                System.out.println("Cycle! " + commands);
                q[thecounter++] = commands;
                commands = "";
            }
            countTree(root.sub[i]);
        }
        if (root.dirname.equals("/") == false) {
           commands += "cd ..;";
        }
    }

    public int min(String[] directories) {
        int i, j, k;
        root = new DirectoryNavigation();
        root.dirname = "/";

        java.util.Arrays.sort(directories, new Comparator<String>() {

            public int compare(String s, String t) {
                if (s.length() != t.length()) {
                    return t.length() - s.length();
                } else {
                    return s.compareTo(t);
                }
            }
        });

        for (i = 0; i < directories.length; i++) {
            String[] dirs = directories[i].split("/");
            boolean isin = false;

            for (j = 0; j < root.count; j++) {
                if (dirs[1].equals(root.sub[j].dirname)) {
                    isin = true;
                    break;
                }
            }
            if (!isin) {
                tmp = root.sub[root.count++] = new DirectoryNavigation();
                tmp.dirname = dirs[1];
            } else {
                tmp = root.sub[j];
            }

            for (k = 2; k < dirs.length; k++) {
                isin = false;
                for (j = 0; j < tmp.count; j++) {
                    if (dirs[k].equals(tmp.sub[j].dirname)) {
                        isin = true;
                        break;
                    }
                }
                if (!isin) {
                    tmp.sub[tmp.count] = new DirectoryNavigation();
                    tmp.sub[tmp.count].dirname = dirs[k];
                    j = tmp.count++;
                }
                tmp = tmp.sub[j];
            }
        }

        countTree(root);
        System.out.println("Cycle! " + commands);
        q[thecounter++] = commands;
        java.util.Arrays.sort(q, 0, thecounter, new Comparator<String>() {
            public int compare(String s, String t) {
                if (s.length() != t.length()) {
                    return s.length() - t.length();
                } else {
                    return s.compareTo(t);
                }
            }
        });
        commands = "";
        for (i=1;i<thecounter;i++) commands+=q[i];

        String cmds[] = commands.split(";");

        for (i = cmds.length - 1; i >= 0; i--) if (cmds[i].equals("cd ..") == false) break;
        System.out.println(commands);
        return i+1;
    }

    public static void main(String[] args) {
        DirectoryNavigation t = new DirectoryNavigation();
        System.out.println(t.min(new String[]{"/a/b","/b","/a/c"}) + " = 6");
        //System.out.println(t.min(new String[]{"/dir"}) + " = 1");
        //System.out.println(t.min(new String[]{"/dir1", "/dir2", "/dir3", "/dir4", "/dir5", "/dir6", "/dir7", "/dir8", "/dir9", "/dir10"}) + " = 19");
        //System.out.println(t.min(new String[]{"/dir1","/dir2","/dir3","/dir4","/dir5","/dir5","/dir7","/dir8","/dir9","/dir10"}) + " = 17");
        //System.out.println(t.min(new String[]{"/dir", "/dir/dir"}) + " = 2");
        //System.out.println(t.min(new String[]{"/b","/b/c","/b/c/d","/b/c/d/a/g/h","/b/c/d/a"}) + " = 6");
        //System.out.println(t.min(new String[]{"/b","/b/c","/b/c/d/a/g/h","/b/c/d/a"}) + " = 6");
        //System.out.println(t.min(new String[]{"/b","/b/c","/b/c/d/a"}) + " = 4");
        //System.out.println(t.min(new String[]{"/a/a/a/a/a/a/a/a/a/a"}) + " = 10");
    }
}