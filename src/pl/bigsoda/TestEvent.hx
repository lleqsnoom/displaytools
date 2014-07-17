package pl.bigsoda ;
import flash.events.Event;

/**
 * ...
 * @author tkwiatek
 */
class TestEvent extends Event
{

		public function new(type:String, bubbles:Bool=false, cancelable:Bool=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TestEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return ["TestEvent", "type", "bubbles", "cancelable", "eventPhase"].join(","); 
		}
		
		public var testType:String;
		static public inline var CLICK:String = "onTestMenuClick";
	
}