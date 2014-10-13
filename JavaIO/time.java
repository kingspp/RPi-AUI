/*
Created on Oct 11, 2014

@author: Prathyush

The scope of the project is to use Java Programming to control the GPIO of the Raspberry Pi
In this simple program, Four Seven Segment Displays are used to display the time.
cpin is used as the contol pin for each display
a-h are the different segments of the display
*/
import java.util.Date;
import java.util.concurrent.Callable;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import com.pi4j.io.gpio.GpioController;
import com.pi4j.io.gpio.GpioFactory;
import com.pi4j.io.gpio.GpioPinDigitalOutput;
import com.pi4j.io.gpio.GpioPinDigitalInput;
import com.pi4j.io.gpio.PinState;
import com.pi4j.io.gpio.RaspiPin;
import com.pi4j.io.gpio.PinPullResistance;
import com.pi4j.io.gpio.RaspiPin;
import com.pi4j.io.gpio.event.GpioPinDigitalStateChangeEvent;
import com.pi4j.io.gpio.event.GpioPinListenerDigital;
import com.pi4j.io.gpio.trigger.GpioCallbackTrigger;

public class time 
{
	static int s=0;
 	//Create a GPIO Instance
	static final GpioController gpio = GpioFactory.getInstance();
        
	// Turn high the control pins of the SSD
	static final GpioPinDigitalOutput cpin1 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_01, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput cpin2 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_02, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput cpin3 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_03, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput cpin4 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_04, "MyLED", PinState.HIGH);
		
	// Turn high the each pin of SSD
	static final GpioPinDigitalOutput a = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_05, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput b = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_06, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput c = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_07, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput d = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_08, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput e = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_09, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput f = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_10, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput g = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_11, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput h = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_12, "MyLED", PinState.HIGH);
	
	//Date Declarations
	////DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	static final DateFormat hour = new SimpleDateFormat("HH");
	static final DateFormat min = new SimpleDateFormat("mm");
	static final DateFormat day = new SimpleDateFormat("dd");
	static final DateFormat mon = new SimpleDateFormat("MM");
    static final Date date = new Date();
	
	//Add a pin to listen to a button click
	static final GpioPinDigitalInput myButton = gpio.provisionDigitalInputPin(RaspiPin.GPIO_00, PinPullResistance.PULL_DOWN);

	public static void main(String args[]) throws InterruptedException
	{			
		Thread.sleep(1200);		 
		shutdown();	
		
		


		
		
		// create and register gpio pin listener
        myButton.addListener(new GpioPinListenerDigital() {
            @Override
            public void handleGpioPinDigitalStateChangeEvent(GpioPinDigitalStateChangeEvent event)  {
                // display pin state on console
                System.out.println(" --> GPIO PIN STATE CHANGE: " + event.getPin() + " = " + event.getState());
				s++;
				while(true)
				{
				try{
					
					if(s%2==0){
						dt();
				myButton.addTrigger(new GpioCallbackTrigger(new Callable<Void>() {
				public Void call() throws Exception {
                shutdown();
                return null;
				}
			}));
						}
					else
						tm();}
				catch(Exception ex){}			
		
				
				}
				
            }            
        });
		
		
		
		//Used to check the correctness of each Seven Segment Display
		/*
		cpin3.high();		
		for(int i=0;i<10;i++){		
		trans(i);		
		Thread.sleep(1000);
		}		
		cpin3.low();
		*/		
		for (;;) {
            Thread.sleep(500);
        }
		//shutdown();  
		//gpio.shutdown();		
	}	
	

	
	static void tm()  throws InterruptedException
	{
		int hr = Integer.parseInt(hour.format(date));
		if(hr>12)
		hr=hr-12;
		int mm = Integer.parseInt(min.format(date));
		
		//minutes
		int m1=mm%10;
		int m2=mm/10;		
		
		//hour
		int h1=hr%10;
		int h2=hr/10;
		
		//print the time
		System.out.print("Time: ");
		System.out.print(h2);
		System.out.print(h1);
		System.out.print(":");
		System.out.print(m2);
		System.out.print(m1);
		System.out.println("");
		
		//Display time on 4 Seven Segment Display
		
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
	
	static void dt() throws InterruptedException
	{
		int dd = Integer.parseInt(day.format(date));
		int MM = Integer.parseInt(mon.format(date));
		
		//day
		int d1=dd%10;
		int d2=dd/10;
		
		//mon
		int M1=MM%10;
		int M2=MM/10;
		
		//print Date
		System.out.print("Date: ");
		System.out.print(d2);
		System.out.print(d1);
		System.out.print(":");
		System.out.print(M2);
		System.out.print(M1);
		System.out.print("");
		
		//Display time on 4 Seven Segment Display
		//for(int i=0;i<10;i++)
		{
		cpin4.high();
		trans(d2);		
		Thread.sleep(5);
		cpin4.low();
		cpin3.high();
		trans(d1);
		h.high();
		Thread.sleep(5);
		h.low();
		cpin3.low();
		cpin2.high();
		trans(M2);
		Thread.sleep(5);
		cpin2.low();
		cpin1.high();
		trans(M1);
		Thread.sleep(5);
		cpin1.low();
		}			
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
