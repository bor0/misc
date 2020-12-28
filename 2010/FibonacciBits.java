/*
[22:22:29] <@Karlo_> Oh, actually since you're considering all 31-bit strings (other than 0), you could solve that with combinatorics.
[22:23:10] <@Karlo_> The number of m-bit strings with exactly r bits set is mCr.
[22:23:44] <Bor0> with exactly r 1 bits or both 1 and 0 ?
[22:24:24] <@Karlo_> Exactly r 1-bits, and m-r 0-bits.
[22:25:28] <Bor0> I still can't see the big picture
[22:27:32] <@Karlo_> Should be able to do it in O(lg(a)+lg(b)) time rather than O(b-a).
[22:27:54] <@Karlo_> Which I guess is just O(lg(b)), since lg(a) is absorbed.
[22:31:03] <Bor0> could you explain that combinatorics thing ?
[22:32:00] <@Karlo_> mCr = binomial(m,r) = m!/(r! (m-r)!) = number of r-element subsets of an m-element set.
[22:32:35] <@Karlo_> (Useful keyword is "binomial coefficient", if you want to look it up somewhere.)
[22:32:50] <Bor0> yes I know the function of "choose", but I can't see how to implement it in here
[22:33:19] <Bor0> I have to check if each number in that set is a fibonacci number as well
[22:34:05] <Galois> you only care about the values of r which are fibonacci numbers
[22:34:23] <Galois> that is, r = 1,2,3,5,8,13,21 is all you care about. r=34 is too large (you are guaranteed b < 2^32)
[22:34:28] <@Karlo_> If a = c+a' and b = c+b', where c is the bits they have in common, a' = 0, and b' = 2^k-1, and the lowest k bits of c are all zero...
[22:34:44] <@Karlo_> (E.g., a = 1101 0000 and b = 1101 1111)
[22:35:00] <@Karlo_> Then you can do a bulk treatment of that interval.
[22:35:01] <Galois> For each r in the set {1,2,3,5,8,13,21}, define f_r(x) = number of integers less than x having exactly r 1-bits. Then f_r(2^m) is what Karlo_ said, and easy to calculate. Given an arbitrary b = 2^i0 + 2^i1 + .. + 2^ik, we have f_r(b) = f_r(2^ik) + (1 + f_r(2^i_{k-1})) + (2 + f_r(2^i_{k-2})) + ...
[22:35:06] <Galois> so f_r(b) is easy to calculate
[22:35:11] <Galois> you want f_r(b) - f_r(a)
[22:35:52] <@Karlo_> Ah.  Galois is doing a second shortcut that I hadn't gotten to.
[22:36:16] <Bor0> thanks for all the input, now I'll need some time to sort that out, give me a sec :)
[22:36:19] * swingman (~swing_gur@adsl-99-93-38-226.dsl.snlo01.sbcglobal.net) has joined #math
[22:36:24] <Galois> more precisely, you want f_1(b) + f_2(b) + f_3(b) + f_5(b) + f_8(b) + f_13(b) + f_21(b) - (f_1(a) + f_2(a) + f_3(a) + f_5(a) + f_8(a) + f_13(a) + f_21(a))
[22:37:33] <@Karlo_> This would make a good interview question.
*/
public class FibonacciBits {
	static int [] fibonacci = {1,2,3,5,8,13,21,34};

	public static int modernFibonacci(int S, int E) {
		int count=0;
		for (int i=S;i<=E;i++) {
			int tmp = Integer.bitCount(i);
			for (int p=0;p<8;p++) if (fibonacci[p] == tmp) { count++; break; }
		}
		return count;
	}

}