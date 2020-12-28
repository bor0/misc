public class BrokenCalculator {

	static String operation="";
	static float b;
	static int maxd = 10;

	static void r(String op, int depth, float a) {
		if (a == b) {
			if (op.length() < operation.length() || operation.equals("")) operation = op;
			return;
		}
		if (depth == maxd) return;

		r(op + "*", depth+1, a*a);
		r(op + "+", depth+1, a+a);
		r(op + "-", depth+1, a-a);
		r(op + "/", depth+1, (float)a/a);
	}

	static public String operations(int starting, int result) {
		b = result;
		r("",0,starting);
		return operation;
	}

}