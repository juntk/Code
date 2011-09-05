
public class java1_1 {
	public static void main(String[] args) {
		Sample1 s1 = new Sample1();
		Sample1 s2 = new Sample1();
		s1.num = 1;
		s2.num = 2;
		
		System.out.println(Sample1.num);
	}
}

class Sample1 {
	public static int num = 0;
}
