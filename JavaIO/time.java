import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import com.pi4j.io.gpio.GpioController;
import com.pi4j.io.gpio.GpioFactory;
import com.pi4j.io.gpio.GpioPinDigitalOutput;
import com.pi4j.io.gpio.PinState;
import com.pi4j.io.gpio.RaspiPin;

public class time 
{
 	//Create a GPIO Instance
	static final GpioController gpio = GpioFactory.getInstance();
        
         // Turn high the control pins of the SSD
        static final GpioPinDigitalOutput cpin1 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_01, "MyLED", PinState.HIGH);
        static final GpioPinDigitalOutput cpin2 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_02, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput cpin3 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_03, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput cpin4 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_04, "MyLED", PinState.HIGH);
		
	// Tun high the each pin of SSD
	static final GpioPinDigitalOutput a = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_05, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput b = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_06, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput c = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_07, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput d = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_08, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput e = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_09, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput f = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_10, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput g = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_11, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput h = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_12, "MyLED", PinState.HIGH);

	public static void main(String args[]) throws InterruptedException
	{
		DateFormat hour = new SimpleDateFormat("HH");
		DateFormat min = new SimpleDateFormat("mm");
       	Date date = new Date();		
		int hr = Integer.parseInt(hour.format(date));
		if(hr>12)
		hr=hr-12;
		int mn = Integer.parseInt(min.format(date));		
		Thread.sleep(1200);		 
		shutdown();	
		//minutes
		int m1=mn%10;
		int m2=mn/10;		
		//hour
		int h1=hr%10;
		int h2=hr/10;
		
		//print the time
		System.out.print(h2);
		System.out.print(h1);
		System.out.print(":");
		System.out.print(m2);
		System.out.print(m1);
		System.out.println("");
		
		//Display time on 4 Seven Segment Display
		for(int i=0;i<1000;i++)
		{
		cpin4.high();
		trans(h2);		
		Thread.sleep(5);
		cpin4.low();
		cpin3.high();
		trans(h1);
		h.high();
		Thread.sleep(5);
		h.low();
		cpin3.low();
		cpin2.high();
		trans(m2);
		Thread.sleep(5);
		cpin2.low();
		cpin1.high();
		trans(m1);
		Thread.sleep(5);
		cpin1.low();
		}
		
		//Used to check the correctness of each Seven Segment Display
		/*
		cpin3.high();		
		for(int i=0;i<10;i++){		
		trans(i);		
		Thread.sleep(1000);
		}		
		cpin3.low();
		*/		
		shutdown();  
		gpio.shutdown();		
	}	
	
	static void init() throws InterruptedException
	{
		a.high();
		b.high();
		c.high();
		d.high();
		e.high();
		f.high();
		g.high();		
	}
	
	static void shut() throws InterruptedException
	{
		a.low();
		b.low();
		c.low();
		d.low();
		e.low();
		f.low();
		g.low();		
	}
	
	static void shutdown () throws InterruptedException
	{
	    //Turnoff all the pins	    
		Thread.sleep(2000);
		cpin1.low();
		cpin2.low();
		cpin3.low();
		cpin4.low();
		a.low();
		b.low();
		c.low();
		d.low();
		e.low();
		f.low();
		g.low();
		h.low();				
	}
	
	static void trans(int num) throws InterruptedException
	{
		switch(num)
		{
			case 0:
				init();
				g.low();
				break;
			
			case 1:
				shut();
				b.high();
				c.high();
				break;
				
			case 2:
				init();
				c.low();
				f.low();
				break;
				
			case 3:
				init();
				e.low();
				f.low();
				break;
			
			case 4:
			    init();
				a.low();
				d.low();
				e.low();
				break;
			
			case 5:
				init();
				b.low();
				e.low();
				break;
				
			case 6:
				init();
				b.low();
				break;
				
			case 7:
				shut();
				a.high();
				b.high();
				c.high();
				break;
				
			case 8:
				init();
				break;
			
			case 9:
				init();
				e.low();
				break;				
		}		
	}
}
