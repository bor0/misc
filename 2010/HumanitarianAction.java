public class HumanitarianAction {

    public static int leni, lenj, countt, found, tmpi, tmpj;
    public static char foundchar;

    public static void findclosest(char mapa[][], int i, int j, int count) {
        if (i >= leni || i < 0 || j >= lenj || j < 0 || count > 15) {
            return;
        }
        if (mapa[i][j] == '#') {
            return;
        } else if (mapa[i][j] >= '0' && mapa[i][j] <= '9') {
            if (countt == -1) {
                foundchar = mapa[i][j];
                countt = count;
                found++;
                tmpi = i;
                tmpj = j;
            } else if (countt == count && (tmpi != i || tmpj != j)) {
                found++;
            } else if (countt > count) {
                foundchar = mapa[i][j];
                countt = count;
                found = 1;
                tmpi = i;
                tmpj = j;
            }
            return;
        }
        findclosest(mapa, i + 1, j, count + 1);
        findclosest(mapa, i, j + 1, count + 1);
        findclosest(mapa, i - 1, j, count + 1);
        findclosest(mapa, i, j - 1, count + 1);
        return;
    }

    public static String taken(String[] map, String dropouts) {
        char mapa[][] = new char[20][20];
        String q[];
        String lepinamene = "";

        for (int i = 0; i < map.length; i++) {
            for (int j = 0; j < map[i].length(); j++) {
                mapa[i][j] = map[i].charAt(j);
            }
        }

        leni = map.length; lenj = map[0].length();
        q = dropouts.split(";");

        for (int i = 0; i < q.length; i++) {
            String j[] = q[i].split(",");
            found = 0;
            countt = -1;
            int x = Integer.parseInt(j[0]), y = Integer.parseInt(j[1]);

            if (mapa[y][x] >= '0' && mapa[y][x] <= '9') {
                lepinamene = lepinamene + String.valueOf(mapa[y][x]);
            } else if (mapa[y][x] == '#') {
                lepinamene = lepinamene + "*";
            } else {
                findclosest(mapa, y, x, 0);
                if (found > 1) {
                    lepinamene = lepinamene + "?";
                } else if (found == 1) {
                    lepinamene = lepinamene + String.valueOf(foundchar);
                } else {
                    lepinamene = lepinamene + "*";
                }
            }
        }

        for (int i = 0; i < map.length; i++) {
            for (int j = 0; j < map[i].length(); j++) {
                System.out.print(String.valueOf(mapa[i][j]));
            }
            System.out.println("|");
        }
        System.out.println(lepinamene);
        return lepinamene;
    }

    public static void main(String[] args) {
        //String [] q = {"   # "," #3##","### #"," ## 2","## ##","   ##","6#   ","    #"," ####","#  ##","  1 #","##4# ","  ###","5#  #","0#   ","  ###"};
        //taken(q, "3,12;1,10;1,8;3,9;0,3;4,4;0,5;1,6;0,12;0,11;0,12;1,1;0,15;2,15;3,10;0,15;0,6;3,5;4,7");

        String[] q = {"  ###  ####  # #", "##    #  ###### ", "6# #### ###  # #", "# # ##       ###", "84 #    #  ## ##", " ##  ##         ", "##### ##   ### #", "#### #    ### # ", "## # ## #### ###", "# #     # ## ## ", "   ## ###  ### #", " #    ## ## ## #", "### ####3# # #  ", "#   # ## #    0 ", "  #######  # #  ", "7### ###     #  ", "##  # ####   # #", "    5   #   ####", "######  #2  #1 #", " ##  # #   # # #"};
        taken(q, "7,5");

    }
}