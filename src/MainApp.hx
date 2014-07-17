package ;
import flash.display.Sprite;
import flash.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import pl.bigsoda.DisplayTest;
import pl.bigsoda.TestEvent;
import pl.bigsoda.TestType;

/**
 * ...
 * @author tkwiatek
 */
class MainApp extends Sprite
{

	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private var _timer:Timer = new Timer(3000);
	private var _dt:DisplayTest;
	private var _menu:Menu;
	
	private function onAddedToStage(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		_dt = new DisplayTest();
		addChild(_dt);
		_menu = new Menu();
		addChild(_menu);
		_menu.x = 10;
		_menu.y = 10;

		_menu.addEventListener(TestEvent.CLICK, onTestMenuClick);
		
		_dt.type = TestType.BRIGHTNESS_CONTRAST;
		_timer.addEventListener(TimerEvent.TIMER, onTimer);
		_timer.start();
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	
	private function onMouseMove(e:Event):Void 
	{
		_timer.reset();
		_timer.start();
		_menu.show();
	}
	
	private function onTimer(e:Event):Void 
	{
		_menu.hide();
	}
	private function onTestMenuClick(e:TestEvent):Void 
	{
		//trace(e.testType);
		_dt.type = e.testType;
	}
	
}