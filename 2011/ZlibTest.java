import java.util.zip.Deflater;
import java.util.zip.Inflater;


public class Main {

	class Info {
		Info() {}
		Info(byte[] bytes, int size) {
			this.bytes = bytes;
			this.size = size;
		}
		public byte[] bytes;
		public int size;
	}

	public Info zlibCompress(byte[] input) {
		byte[] bytes = new byte[512];
		
		// Compress the bytes
		Deflater compresser = new Deflater();
		compresser.setInput(input);
		compresser.finish();
		return new Info(bytes, compresser.deflate(bytes));
	}

	public Info zlibDecompress(Info data) {
		Inflater decompress = new Inflater(); int len;
		byte[] output = new byte[512];
		decompress.setInput(data.bytes, 0, data.size);
		try {
			len = decompress.inflate(output);
		} catch (Exception e) {
			decompress.end();
			return null;
		}
		decompress.end();
		return new Info(output, len);
	}
	
	public void okgo() {
		Info x = zlibCompress("What are these barries that keep people from reaching anywhere near their real potential? The answer to that can be found in another question and that's this: Which is the most universal human characteristic?".getBytes());
		System.out.println("Compressed bytes size " + x.size);
		for (int i=0;i<x.size;i++) System.out.print(x.bytes[i]+", ");
		System.out.println();

		Info y = zlibDecompress(x);
		System.out.println("Decompressed bytes size " + y.size);
		for (int i=0;i<y.size;i++) System.out.print(y.bytes[i]+", ");
		System.out.println();

		String output = new String(y.bytes, 0, y.size);
		System.out.println(output);
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Main t = new Main();
		t.okgo();
	}

}
