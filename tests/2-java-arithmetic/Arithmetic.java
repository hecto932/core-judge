import java.lang.ArithmeticException;

public class Arithmetic {
 
    public static void main(String[] args) {
        System.out.println("Hello, World");

        try {
    		int i = 0 / 0;
		} catch (ArithmeticException e) {
		     System.out.println("ArithmeticException occured!");
		}
    }
}