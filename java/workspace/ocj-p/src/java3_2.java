
public class java3_2 {
	public static void main(String[] args) {
		String str = "abc";
		String str2 = "abc";
		String str3 = new String("abc");
		String str4 = new String("abc");
		
		System.out.println(str.getClass());
		System.out.println(str3.getClass());
		if (str == str3) {
			System.out.println("true");
		}
	}
}
