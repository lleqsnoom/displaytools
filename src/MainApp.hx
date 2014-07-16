package ;
import flash.display.Sprite;
import flash.events.Event;
import test.DisplayTest;
import test.TestEvent;

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
	}
	private function onTestMenuClick(e:TestEvent):Void 
	{
		//trace(e.testType);
		_dt.type = e.testType;
	}
	
}