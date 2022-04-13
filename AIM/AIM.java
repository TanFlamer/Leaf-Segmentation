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

        File file = new File("C:\\Users\\zxtan\\Documents\\Uni\\Coursework\\AIM\\Results\\Test.txt"); //input txt file
        Scanner sc = new Scanner(file);

        String[] hold = new String[4];
        LinkedHashMap<Integer,LinkedHashMap<String,LinkedHashMap<Integer,String>>> trueData = new LinkedHashMap<>();
        LinkedHashMap<Integer,LinkedHashMap<String,LinkedHashMap<Integer,String>>> data = new LinkedHashMap<>();
        LinkedHashMap<Integer,LinkedHashMap<String,LinkedHashMap<Integer,Integer>>> score = new LinkedHashMap<>();

        LinkedHashMap<Integer,LinkedHashMap<String,Calculation>> calculation = new LinkedHashMap<>();
        LinkedHashMap<Integer,LinkedHashMap<String,Results>> finalResults = new LinkedHashMap<>();

        LinkedHashMap<Integer,Integer> total = new LinkedHashMap<>();

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

            hold[3] = t1.nextToken();
            hold[3] = hold[3].replaceAll("[^0-9]", "");

            int dimension = Integer.parseInt(hold[3]);
            double trueValue = Double.parseDouble(hold[2]);

            String trueStingValue = String.format("%1.4e",trueValue);

            trueData.computeIfAbsent(dimension,k -> new LinkedHashMap<>());
            trueData.get(dimension).computeIfAbsent(hold[0],k -> new LinkedHashMap<>());
            trueData.get(dimension).get(hold[0]).put(Integer.parseInt(hold[1]),trueStingValue);

            calculation.computeIfAbsent(dimension,k -> new LinkedHashMap<>());
            calculation.get(dimension).putIfAbsent(hold[0],new Calculation(0,0));
            calculation.get(dimension).put(hold[0],new Calculation(calculation.get(dimension).get(hold[0]).sum + trueValue,calculation.get(dimension).get(hold[0]).sumOfSquares + trueValue * trueValue));

            if(hold[2].charAt(0) == '-' || hold[2].equals("0.0000e+00") || (hold[2].charAt(7) == '-' && Integer.parseInt(hold[2].substring(8)) > 14))
                hold[2] = "1.0000e-14";
            else if(hold[2].charAt(7) == '+' && Integer.parseInt(hold[2].substring(8)) >= 3)
                hold[2] = "1.0000e+03";

            if(trueValue < 1.0000e-14)
                trueValue = 1.0000e-14;
            else if (trueValue > 1.0000e+03)
                trueValue = 1.0000e+03;

            String stringValue = String.format("%1.4e",trueValue);

            data.computeIfAbsent(dimension,k -> new LinkedHashMap<>());
            data.get(dimension).computeIfAbsent(hold[0],k -> new LinkedHashMap<>());
            data.get(dimension).get(hold[0]).put(Integer.parseInt(hold[1]),stringValue);

            double log = -Math.log10(trueValue);
            int rank = (int) Math.floor(log);

            score.computeIfAbsent(dimension,k -> new LinkedHashMap<>());
            score.get(dimension).computeIfAbsent(hold[0],k -> new LinkedHashMap<>());
            score.get(dimension).get(hold[0]).put(Integer.parseInt(hold[1]),rank);
        }

        sc.close();

        for(Map.Entry<Integer, LinkedHashMap<String, Calculation>> dimension : calculation.entrySet())
            for(Map.Entry<String, Calculation> loop : dimension.getValue().entrySet()){
                finalResults.computeIfAbsent(dimension.getKey(),k -> new LinkedHashMap<>());
                finalResults.get(dimension.getKey()).putIfAbsent(loop.getKey(),new Results(0,0));
                finalResults.get(dimension.getKey()).put(loop.getKey(),new Results(loop.getValue().sum/15,Math.sqrt(loop.getValue().sumOfSquares/15 - (loop.getValue().sum/15) * (loop.getValue().sum/15))));
            }

        PrintWriter excel = new PrintWriter("C:\\Users\\zxtan\\Documents\\Uni\\Coursework\\AIM\\Results\\Data.txt", StandardCharsets.UTF_8); //output txt file

        for(Map.Entry<Integer, LinkedHashMap<String, LinkedHashMap<Integer, String>>> dimension : trueData.entrySet()) {
            excel.format("%d-D\n",dimension.getKey());
            for(Map.Entry<String, LinkedHashMap<Integer, String>> loop : dimension.getValue().entrySet()) {
                for (Map.Entry<Integer, String> print : loop.getValue().entrySet()) {
                    excel.format("%11s ", print.getValue());
                }
                excel.write("\n");
            }
            excel.write("\n");
        }

        for(Map.Entry<Integer, LinkedHashMap<String, LinkedHashMap<Integer, String>>> dimension : data.entrySet()) {
            excel.format("%d-D\n",dimension.getKey());
            for(Map.Entry<String, LinkedHashMap<Integer, String>> loop : dimension.getValue().entrySet()) {
                for (Map.Entry<Integer, String> print : loop.getValue().entrySet()) {
                    excel.format("%s ", print.getValue());
                }
                excel.write("\n");
            }
            excel.write("\n");
        }

        for(Map.Entry<Integer, LinkedHashMap<String, LinkedHashMap<Integer, Integer>>> dimension : score.entrySet()) {
            int totalScore = 0;
            excel.format("%d-D\n",dimension.getKey());
            for(Map.Entry<String, LinkedHashMap<Integer, Integer>> loop : dimension.getValue().entrySet()) {
                for (Map.Entry<Integer, Integer> print : loop.getValue().entrySet()) {
                    excel.format("%2d ", print.getValue());
                    totalScore += print.getValue();
                }
                excel.write("\n");
            }
            excel.write("\n");
            total.put(dimension.getKey(),totalScore);
        }

        for(Map.Entry<Integer, Integer> print : total.entrySet())
            excel.format("%d-D:%d\n",print.getKey(),print.getValue());

        excel.close();

        PrintWriter result = new PrintWriter("C:\\Users\\zxtan\\Documents\\Uni\\Coursework\\AIM\\Results\\Results.txt", StandardCharsets.UTF_8); //output txt file

        for(Map.Entry<Integer, LinkedHashMap<String, Results>> dimension : finalResults.entrySet()) {
            for (Map.Entry<String, Results> loop : dimension.getValue().entrySet()) {
                result.format("%1.4e ", loop.getValue().average);
            }
            result.write("\n");
        }

        result.write("\n");

        for(Map.Entry<Integer, LinkedHashMap<String, Results>> dimension : finalResults.entrySet()) {
            for (Map.Entry<String, Results> loop : dimension.getValue().entrySet()) {
                result.format("%1.4e ", loop.getValue().standardDeviation);
            }
            result.write("\n");
        }

        result.close();
    }
}

class Calculation{

    double sum;
    double sumOfSquares;

    public Calculation(double sum, double sumOfSquares){
        this.sum = sum;
        this.sumOfSquares = sumOfSquares;
    }
}

class Results{

    double average;
    double standardDeviation;

    public Results(double average, double standardDeviation){
        this.average = average;
        this.standardDeviation = standardDeviation;
    }
}
