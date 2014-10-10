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
        
    // Turn on the control pins of the SSD
    static final GpioPinDigitalOutput cpin1 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_01, "MyLED", PinState.HIGH);
    static final GpioPinDigitalOutput cpin2 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_02, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput cpin3 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_03, "MyLED", PinState.HIGH);
	static final GpioPinDigitalOutput cpin4 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_04, "MyLED", PinState.HIGH);
		
	// Tun on the each pin of SSD
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
		int mn = Integer.parseInt(min.format(date));		
		System.out.println(hr);
		System.out.println(mn);
		Thread.sleep(1200);		 
		shutdown();		
		
		cpin1.high();		
		trans(0);
		Thread.sleep(3000);
		
		
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
		h.high();
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
		h.low();		
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
		//gpio.shutdown();		
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
				g.low();
				break;
		}
		
	}
}
