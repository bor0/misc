import java.util.Stack;

public class RecursiveStack {

	public static int numberDigits = 5;
	public static char charStart = 'a', charEnd = 'z';

	private static class T {
		public String t;
		int numberDigits;
		T(String t, int numberDigits) {
			this.t = t;
			this.numberDigits = numberDigits;
		}
	}

	static void count(String t, int numberDigits) {
		if (numberDigits == -1) return;
		else if (numberDigits == 0) System.out.println(t);
		else for (char i=charStart;i<=charEnd;i++)
		count(t+i, numberDigits-1);
	}

	static void stack(String t, int numberDigits) {
		Stack<T> stack = new Stack<T>();
		T m;
		stack.push(new T(t, numberDigits));
		while (stack.empty() == false) {
			m = stack.pop();

			if (m.numberDigits == -1) continue;
			else if (m.numberDigits == 0) System.out.println(m.t);
			else for (char i=charEnd;i>=charStart;i--)
			stack.push(new T(m.t+i, m.numberDigits-1));

		}
	}

	public static void main(String[] args) {
		System.out.println("Recursion: ");
		count("", numberDigits);

		//System.out.println("\nStack: ");
		//stack("", numberDigits);
		return;
	}
}