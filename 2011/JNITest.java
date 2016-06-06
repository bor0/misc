import java.util.*;

class JNITest {
	native static int messageBox(String name);

	public static void main(String args[]) {
		int testResult;
		System.loadLibrary("JNITest");

		testResult = messageBox("ReadFile.java");

		String result = (testResult==1)?"OK":"Cancel";
		System.out.print("The user pressed: " + result);
	}
}