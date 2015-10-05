import java.util.*;
import java.math.*;

public class Main {
 
    public static void main(String[] args) {
        Scanner s = new Scanner(System.in);
        while(s.hasNext())
            System.out.println(s.nextBigInteger()
               .subtract(s.nextBigInteger()).abs());
    }
}