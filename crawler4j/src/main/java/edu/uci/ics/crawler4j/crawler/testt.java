package edu.uci.ics.crawler4j.crawler;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;



public class testt {
	public static void main(String[] args) {
		FileInputStream fstream;
		try {
			fstream = new FileInputStream("C:/Users/rishi.sijariya/Documents/Downloads/tax.txt");
			BufferedReader br = new BufferedReader(new InputStreamReader(fstream));
			String strLine;
			int cnt=0;
			int p=0;
			int n=0;
			int m=0;
			PrintWriter writer = new PrintWriter("C:/Users/rishi.sijariya/Documents/Downloads/ram.txt");
			try {
				while ((strLine = br.readLine()) != null)   {
					if(strLine.startsWith(" ............")){
						p++;
						writer.println(String.format("%04d", cnt)+"."+String.format("%04d", m)+"."+String.format("%04d", n)+"."+String.format("%04d", p)+"@@"+strLine);
						
					}
					else if(strLine.startsWith(" ........")){
						n++;
						p=0;
						writer.println(String.format("%04d", cnt)+"."+String.format("%04d", m)+"."+String.format("%04d", n)+"@@"+strLine);
					}
					else if(strLine.startsWith(" ....")){
						m++;
						n=0;
						p=0;
						writer.println(String.format("%04d", cnt)+"."+ String.format("%04d", m)+"@@"+strLine);
						
					}
					else if(!strLine.startsWith(" ")){
						cnt++;
						m=0;
						n=0;
						p=0;
						writer.println(String.format("%04d", cnt)+"@@"+strLine);
					}
					}
				writer.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
}
