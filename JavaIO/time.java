import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class time
{

	public static void main(String args[])
	{
		DateFormat hour = new SimpleDateFormat("HH");
		DateFormat min = new SimpleDateFormat("mm");
        Date date = new Date();		
		int hr = Integer.parseInt(hour.format(date));
		int mn = Integer.parseInt(min.format(date));		
		System.out.println(hr);
		System.out.println(mn);
        
	}
}