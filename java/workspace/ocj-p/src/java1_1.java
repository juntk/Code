
public class java1_1 {
	public static void main(String[] args) {
		Sample s1 = new Sample();
		Sample s2 = new Sample();
		s1.num = 1;
		s2.num = 2;
		
		System.out.println(Sample.num);
	}
}

class Sample {
	public static int num = 0;
}
