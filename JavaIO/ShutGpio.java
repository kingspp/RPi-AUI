import com.pi4j.io.gpio.GpioController;
import com.pi4j.io.gpio.GpioFactory;
import com.pi4j.io.gpio.GpioPinDigitalOutput;
import com.pi4j.io.gpio.GpioPinDigitalInput;
import com.pi4j.io.gpio.PinState;
import com.pi4j.io.gpio.RaspiPin;


public class ShutGpio{
	public static  void main (String args[])
	{
		System.out.println("Shutting Down GPIO Pins. Bye!");
		final GpioController gpio = GpioFactory.getInstance();		
		final GpioPinDigitalOutput p0 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_00, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p1 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_01, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p2 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_02, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p3 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_03, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p4 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_04, "MyLED", PinState.LOW);		
		final GpioPinDigitalOutput p5 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_05, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p6 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_06, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p7 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_07, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p8 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_08, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p9 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_09, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p10 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_10, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p11 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_11, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p12 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_12, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p13 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_13, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p14 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_14, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p15 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_15, "MyLED", PinState.LOW);
		final GpioPinDigitalOutput p16 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_16, "MyLED", PinState.LOW);
		gpio.shutdown();
	}
}