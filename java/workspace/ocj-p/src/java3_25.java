import java.io.Serializable;
import java.io.*;

public class java3_25 {
	public static void main(String[] args) {
		Employee emp = new Employee();
		
		try {
			FileOutputStream o1 = new FileOutputStream("emp.ser");
			ObjectOutputStream o2 = new ObjectOutputStream(o1);
			o2.writeObject(emp);
			o2.close();
			
			FileInputStream i1 = new FileInputStream("emp.ser");
			ObjectInputStream i2 = new ObjectInputStream(i1);
			emp = (Employee)i2.readObject();
			
			emp.print();
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
}

class Employee implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public void print() {
		System.out.println("Hello");
	}
}