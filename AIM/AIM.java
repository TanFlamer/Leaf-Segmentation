import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.StringTokenizer;

public class AIM {

    public static void main(String[] args) throws IOException {

        File file = new File("C:\\Users\\zxtan\\Documents\\University Documents\\Coursework\\AIM\\Test.txt");
        Scanner sc = new Scanner(file);

        String[] hold = new String[3];
        LinkedHashMap<String,LinkedHashMap<Integer,String>> data = new LinkedHashMap<>();

        while(sc.hasNextLine()){

            String line = sc.nextLine();
            line = line.replaceAll(" ", "");
            StringTokenizer st = new StringTokenizer(line,",");

            if(st.countTokens() != 4)
                continue;

            for (int count = 0; count < 3; count++){
                hold[count] = st.nextToken();
            }

            StringTokenizer t1 = new StringTokenizer(hold[0],"i");
            hold[0] = t1.nextToken();

            StringTokenizer t2 = new StringTokenizer(hold[1],":");
            hold[1] = t2.nextToken();

            StringTokenizer t3 = new StringTokenizer(hold[1],"e");
            t3.nextToken();
            hold[1] = t3.nextToken();

            StringTokenizer t4 = new StringTokenizer(hold[2],"=");
            t4.nextToken();
            hold[2] = t4.nextToken();

            if(hold[2].charAt(0) == '-' || hold[2].equals("0.0000e+00") || (hold[2].charAt(7) == '-' && Integer.parseInt(hold[2].substring(8)) > 14))
                hold[2] = "1.0000e-14";
            else if(hold[2].charAt(7) == '+' && Integer.parseInt(hold[2].substring(8)) > 3)
                hold[2] = "1.0000e+03";

            data.computeIfAbsent(hold[0],k -> new LinkedHashMap<>());
            data.get(hold[0]).put(Integer.parseInt(hold[1]),hold[2]);
        }

        sc.close();

        PrintWriter excel = new PrintWriter("C:\\Users\\zxtan\\Documents\\University Documents\\Coursework\\AIM\\Data.txt", StandardCharsets.UTF_8);

        for(Map.Entry<String, LinkedHashMap<Integer, String>> loop : data.entrySet()) {
            for(Map.Entry<Integer, String> print : loop.getValue().entrySet())
                excel.format("%s ",print.getValue());
            excel.write("\n");
        }

        excel.close();

        for(Map.Entry<String, LinkedHashMap<Integer, String>> loop : data.entrySet()) {
            for(Map.Entry<Integer, String> print : loop.getValue().entrySet())
                System.out.println(loop.getKey() + " " + print.getKey() + " " + print.getValue());
            System.out.println();
        }
    }
}
