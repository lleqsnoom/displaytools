package ;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Mouse;
import test.TestEvent;
import test.TestType;
import flash.display.StageDisplayState;

/**
 * ...
 * @author tkwiatek
 */
class Menu extends Sprite
{
	
	private var _buttonsParams:Array<Dynamic>;
	
	private var _bgColor:UInt = 0x222222;
	private var _buttonColor:UInt = 0xffffff;
	private var _activeColor:UInt = 0x04b1f2;
	private var _textColor:UInt = 0x999999;
	private var _textActiveColor:UInt = 0x222222;
	private var _mouseOver:Bool = false;
	private var _buttons:Array<Sprite>;

	public function new() 
	{
		super();
		_buttonsParams = [
			{
				label: "Fullscreen",
				type: TestType.FULLSCREEN
			},
			{
				label: "Brightness/Contrast",
				type: TestType.BRIGHTNESS_CONTRAST
			},
			{
				label: "Color Spectrum",
				type: TestType.COLOR_SPECTRUM
			},
			{
				label: "Misconvergence",
				type: TestType.MISCONVERGENCE
			},
			{
				label: "Misconvergence White",
				type: TestType.MISCONVERGENCE_BW
			},
			{
				label: "Moire 1x1",
				type: TestType.MOIRE
			},
			{
				label: "Moire 2x2",
				type: TestType.MOIRE2
			},
			{
				label: "Moire 4x4",
				type: TestType.MOIRE4
			},
			{
				label: "H Lines x1",
				type: TestType.H_LINES_1
			},
			{
				label: "H Lines x2",
				type: TestType.H_LINES_2
			},
			{
				label: "H Lines x4",
				type: TestType.H_LINES_4
			},
			{
				label: "V Lines x1",
				type: TestType.V_LINES_1
			},
			{
				label: "V Lines x2",
				type: TestType.V_LINES_2
			},
			{
				label: "V Lines x4",
				type: TestType.V_LINES_4
			},
			{
				label: "Readability",
				type: TestType.READABILITY
			},
			{
				label: "Color Black",
				type: TestType.SCREEN_COLOR_BLACK
			},
			{
				label: "Color White",
				type: TestType.SCREEN_COLOR_WHITE
			},
			{
				label: "Color Red",
				type: TestType.SCREEN_COLOR_RED
			},
			{
				label: "Color Green",
				type: TestType.SCREEN_COLOR_GREEN
			},
			{
				label: "Color Blue",
				type: TestType.SCREEN_COLOR_BLUE
			},
			{
				label: "Color Cyan",
				type: TestType.SCREEN_COLOR_CYAN
			},
			{
				label: "Color Magenta",
				type: TestType.SCREEN_COLOR_MAGENTA
			},
			{
				label: "Color Yellow",
				type: TestType.SCREEN_COLOR_YELLOW
			},
			{
				label: "Ghost Remover",
				type: TestType.GHOST_REMOVER
			}
		];
		
		
		
		_buttons = new Array<Sprite>();
		for (i in 0..._buttonsParams.length) 
		{
			createButton(_buttonsParams[i].label, _buttonsParams[i].type, i);
		}
		graphics.clear();
		graphics.beginFill(_bgColor, .95);
		graphics.drawRect( -1, -1, 122, _buttonsParams.length * 20 + 20);
		graphics.endFill();
		addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		show();
	}
	
	
	private function onMouseOver(e:MouseEvent):Void 
	{
		_mouseOver = true;
	}		
	private function onMouseOut(e:MouseEvent):Void 
	{
		_mouseOver = false;
	}
	


	private function createButton(label:String, type:String, i:UInt):Void {
		var s:Sprite = new Sprite();
		_buttons.push(s);
		var tf:TextField = new TextField();
		var f:TextFormat = new TextFormat("_sans", 11, _textColor,i==0?true:null);
		tf.defaultTextFormat = f;
		tf.text = label;
		tf.width = 120;
		tf.height = 19;
		tf.selectable = false;
		addChild(s);
		s.addChild(tf);
		s.graphics.clear();
		s.graphics.beginFill(_buttonColor, .08);
		s.graphics.drawRect(0, 0, 120, 19);
		s.graphics.endFill();
		s.y = i * 20;
		s.name = type;
		s.addEventListener(MouseEvent.CLICK, onMenuClick);
		s.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
		s.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);
		
		s.mouseChildren = true;
		s.mouseEnabled = true;
		s.buttonMode = true;
		s.useHandCursor = true;
	}

	private function onBtnOut(e:MouseEvent):Void 
	{	
		var s:Sprite = cast(e.currentTarget, Sprite);
		s.graphics.clear();
		s.graphics.beginFill(_buttonColor, .08);
		s.graphics.drawRect(0, 0, 120, 19);
		s.graphics.endFill();
		var tf:TextField = cast(s.getChildAt(0), TextField);
		var f:TextFormat = tf.getTextFormat();
		f.color = _textColor;
		tf.setTextFormat(f);
	}

	private function onBtnOver(e:MouseEvent):Void 
	{	
		var s:Sprite = cast(e.currentTarget, Sprite);
		s.graphics.clear();
		s.graphics.beginFill(_activeColor, 1);
		s.graphics.drawRect(0, 0, 120, 19);
		s.graphics.endFill();
		var tf:TextField = cast(s.getChildAt(0), TextField);
		var f:TextFormat = tf.getTextFormat();
		f.color = _textActiveColor;
		tf.setTextFormat(f);
	}
	
	private function onMenuClick(e:MouseEvent):Void {
		var evt:TestEvent = new TestEvent(TestEvent.CLICK);
		
		#if js
			evt.testType = e.currentTarget.__name;
		#else
			evt.testType = e.currentTarget.name;
		#end
		
		//untyped __js__("console.log")(e);
		//trace(e.currentTarget.name);
		//untyped __js__("console.log")(e.currentTarget);
		//trace(e.currentTarget);
		//trace(e.target);
		dispatchEvent(evt);


		if(evt.testType == TestType.FULLSCREEN) stage.displayState = stage.displayState == StageDisplayState.FULL_SCREEN ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN;
	}

	public function show():Void {
		visible = true;
		//if (alpha >= 1) {
			alpha = 1; 
			Mouse.show();
			return;
		//}
		//alpha += .02;
		//setTimeout(show, 10);
	}

	public function hide():Void {	
		if (_mouseOver) return;
		//if (alpha <= 0) {
			alpha = 0; 
			visible = false;
			Mouse.hide();
			return;
		//}
		//alpha -= .02;
		//setTimeout(hide, 10);
	}
	
}