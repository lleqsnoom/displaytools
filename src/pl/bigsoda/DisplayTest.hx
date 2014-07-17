package pl.bigsoda ;
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.Constraints.Function;
import flash.geom.Matrix;
import flash.display.StageDisplayState;
import flash.display.Bitmap;
import motion.Actuate;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

/**
 * ...
 * @author tkwiatek
 */
class DisplayTest extends Sprite
{
	private var _tf:TextFormat;
	public function new() 
	{
		super();
		_tf = new TextFormat("_sans", 10, 0, null, null, null, null, null, TextFormatAlign.CENTER);
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		_tfPool = new Array<TextField>();
		//_timerArr = new Array<Timer>();
		_timer.addEventListener(TimerEvent.TIMER, onTimer);
	}
	
	private function onAddedToStage(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.addEventListener(Event.RESIZE, redraw);
		redraw();
	}
	
	public function removeTf():Void {
		for (i in 0..._tfPool.length) 
		{
			try { removeChild(_tfPool[i]); } catch (e:Error) { return; }
		}
	}
	public function redraw(e:Event = null):Void 
	{
			clear();

	 		//trace("redraw");
			removeTf();
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			switch(_type){
				case TestType.COLOR_SPECTRUM:
					redrawColorSpectrum();
				case TestType.BRIGHTNESS_CONTRAST:
					redrawBrightnessContrast();
				case TestType.MISCONVERGENCE_BW:
					redrawMisconvergence(false);
				case TestType.MOIRE:
					redrawMoire(1);
				case TestType.MOIRE2:
					redrawMoire(2);
				case TestType.MOIRE4:
					redrawMoire(4);
				case TestType.H_LINES_1:
					redrawLines(1, 'h');
				case TestType.H_LINES_2:
					redrawLines(2, 'h');
				case TestType.H_LINES_4:
					redrawLines(4, 'h');
				case TestType.V_LINES_1:
					redrawLines(1, 'v');
				case TestType.V_LINES_2:
					redrawLines(2, 'v');
				case TestType.V_LINES_4:
					redrawLines(4, 'v');
				case TestType.READABILITY:
					redrawReadability();
				case TestType.SCREEN_COLOR_WHITE:
					redrawScreenColor(0xffffff);
				case TestType.SCREEN_COLOR_BLACK:
					redrawScreenColor(0);
				case TestType.SCREEN_COLOR_RED:
					redrawScreenColor(0xff0000);
				case TestType.SCREEN_COLOR_GREEN:
					redrawScreenColor(0x00ff00);
				case TestType.SCREEN_COLOR_BLUE:
					redrawScreenColor(0x0000ff);
				case TestType.SCREEN_COLOR_CYAN:
					redrawScreenColor(0x00ffff);
				case TestType.SCREEN_COLOR_MAGENTA:
					redrawScreenColor(0xff00ff);
				case TestType.SCREEN_COLOR_YELLOW:
					redrawScreenColor(0xffff00);
				case TestType.GHOST_REMOVER:
					redrawGhostRemover();
				case TestType.MISCONVERGENCE:
					redrawMisconvergence(true);
				case TestType.FULLSCREEN:
					
				default:
					//redrawMisconvergence(true);
			}

			if (_type == TestType.GHOST_REMOVER) {
				startGhostRemover();
			}else {
				stopGhostRemover();
			}
	}
	
	private var w(get, null):Float;
	private var h(get, null):Float;
	
	
	
	
	function get_h():Float 
	{
		return stage.stageHeight;
	}
	
	function get_w():Float 
	{
		return stage.stageWidth;
	}
	
	private var _type:String = "";
	public var type(get, set):String;
	function get_type():String 
	{
		return _type;
	}
	
	function set_type(value:String):String 
	{	
		if (value != TestType.FULLSCREEN) _type = value;
		
		redraw();
		return _type;
	}
	
	/*
	private var _timerArr:Array<Timer>;
	
	private function setTimeout(fun:Dynamic, ms:Int,  arg:Dynamic = null):Int {
		var t:Timer = new Timer(ms);
		t.run = function():Void{
			fun(arg);
		}

		return _timerArr.push(t);
	}
	private function clearTimeout(id:Int):Void {
		_timerArr[id].stop();
	}
	*/

	private function redrawLines(thickness:Float, direction:String):Void {
		//var size:Int = Std.int(10*thickness);
		var size:Int = 32;
		var bmp:BitmapData = new BitmapData(size, size,false,0xffffff);
		var r:Rectangle = new Rectangle();
		r.width = direction=='h'?size:1*thickness;
		r.height = direction=='v'?size:1*thickness;
		bmp.lock();
		for (i in 0...size) {
			r.x = direction=='h'?0:(i * thickness*2);
			r.y = direction=='v'?0:(i * thickness*2);
			bmp.fillRect(r, 0);
			//trace(i);
		}
		bmp.unlock();
		graphics.beginBitmapFill(bmp,new Matrix(),true,false);
		graphics.drawRect(0, 0, w, h);
		graphics.endFill();
	}
	
	private function redrawMoire(pixelSize:Int = 1):Void {
		var size:Int = 32;
		var bmp:BitmapData = new BitmapData(size, size,false,0xffffff);
		var ca:Array<Int> = [0, 0xffffffff];
		var r:Rectangle = new Rectangle();
		r.width = pixelSize;
		r.height = pixelSize;
		bmp.lock();
		for (i in 0...Std.int(size/pixelSize)) {
			for (j in 0...Std.int(size/pixelSize)) 
			{
				r.x = i * pixelSize;
				r.y = j * pixelSize;
				bmp.fillRect(r, ca[(i + j) % ca.length]);
			}				
		}
		bmp.unlock();
		graphics.clear();
		graphics.beginBitmapFill(bmp);
		graphics.drawRect(0, 0, w, h);
		graphics.endFill();		
	}

	private var _timer:Timer = new Timer(100);
	private var _bmp:BitmapData;
	//private var t = new haxe.Timer(100);
	private function onTimer(e:TimerEvent):Void {
		redrawGhostRemover(_bmp);
	}
	
	function stopGhostRemover() 
	{
		//trace("stopGhostRemover");
		_timer.stop();
	}
	
	function startGhostRemover() 
	{
		//trace("startGhostRemover");
		var size:Int = 256;
		
		_bmp = openfl.Assets.getBitmapData("img/noise.png");
		_bmp.lock();
		_bmp.noise(Std.int(Math.random()*1000), 0, 255, 7, true);
		_bmp.unlock();
		
		_timer.start();
		//var t = new haxe.Timer(100); //run every 100ms
		//t.run = function(){ drawGhostRemover(bmp); }; //use this function
	}
	
	private var _ghostInterval:Int;
	private function redrawGhostRemover(bmpRef:BitmapData=null):Void {
		if (type != TestType.GHOST_REMOVER) {
			//if (_ghostInterval > 0) clearTimeout(_ghostInterval);
			return;
		}			
		var size:Int = 256;
		var bmp:BitmapData;
		if (bmpRef != null) {
			bmp = bmpRef;
		}else {
			bmp = openfl.Assets.getBitmapData("img/noise.png");
			bmp.lock();
			bmp.noise(Std.int(Math.random()*1000), 0, 255, 7, true);
			bmp.unlock();
		}



		var m:Matrix = new Matrix();
		m.tx = Std.int(Math.random()*size);
		m.ty = Std.int(Math.random()*size);

		graphics.clear();
		graphics.beginBitmapFill(bmp, m);
		graphics.drawRect(0, 0, w + size, h + size);
		graphics.endFill();
		
		//trace("redrawGhostRemover");

		//var t = new haxe.Timer(100); //run every 100ms
		//t.run = function(){ drawGhostRemover(bmp); }; //use this function

	}

	private function drawGhostRemover(bmpRef:BitmapData=null):Void {
		

		var size:Int = 256;

		x = -Std.int(Math.random()*size);
		y = -Std.int(Math.random()*size);
		
	}
	
	private function redrawMisconvergence(color:Bool, thickness:Int = 1):Void {
		var size:Int = 64;
		var ca:Array<Int> = color?[0xff0000, 0x00ff00, 0x0000ff]:[0xffffff];
		var c:Int;
		var tx:Int = 0;
		var ty:Int = 0;
		var i:Int = 0;
		while (tx < w+size) {
			while (ty < h+size) {
				i = Std.int(((tx + ty)/size) % ca.length);
				c = ca[i];
				graphics.beginFill(c);
				//graphics.lineStyle(thickness, c);
				//horizontal
				graphics.drawRect(tx, ty - size*.5, thickness , size);
				graphics.drawRect(tx - size*.5, ty, size, thickness);
//				graphics.drawRect(tx - size*.5, ty + size*.5, size, thickness);
				
				if(ty>h){
					graphics.drawRect(tx - size*.5, h-1, size, thickness);
				}

				if(tx>w){
					graphics.drawRect(w-1, ty - size*.5, thickness , size);
				}

				ty += size;
			}
			ty = 0;
			tx += size;				
		}
	}
	
	private function redrawScreenColor(color:UInt = 0xffffff):Void {
		graphics.beginFill(color);
		graphics.drawRect(0, 0, w, h);
		graphics.endFill();
	}
	
	private function redrawReadability():Void 
	{
		//graphics.beginBitmapFill(_radability);
		_bmp = openfl.Assets.getBitmapData("img/displaytools.png");

		graphics.clear();
		graphics.beginBitmapFill(_bmp);
		graphics.drawRect(0, 0, w + 256, h + 256);
		graphics.endFill();
		
	}
	
	
	private function redrawBrightnessContrast():Void 
	{
		var a:Array<UInt> = [0x000000, 0x080808, 0x0d0d0d, 0x1a1a1a, 0x333333, 0x4d4d4d, 0x666666, 0x808080, 0x999999, 0xb3b3b3, 0xcccccc, 0xe5e5e5, 0xffffff];
		var aa:Array<Int> = [0, 3, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
		var gap:Float = 10;
		var cw:Float = ((w - gap * (a.length + 1)) / a.length);
		var ch:Float =((h - 3 * gap) / 2);
		var px:Float = gap;
		var ti:UInt = 0;
		var t:TextField;
		var i:Int;
		for (i in 0...a.length) {
			graphics.beginFill(a[i]);
			graphics.drawRect(Std.int(px), Std.int(gap), Std.int(cw), Std.int(ch));
			graphics.endFill();
			t = addTf(aa[i] + "%", (aa[i] < 50)?0xffffff:0, ti);
			t.width = Std.int(cw);
			t.height = 20;
			t.x = Std.int(px);
			t.y = Std.int(gap + (ch - t.height) * .5);
			t.alpha = .5;
			addChild(t);				
			px += cw + gap;				
			ti++;
		}
		var gapb:Float = 30;
		var ab:Array<UInt> = [0x4d4d4d, 0x333333, 0x1a1a1a, 0x000000];
		var aw:Array<UInt> = [0xffffff, 0xe5e5e5, 0xcccccc, 0xb3b3b3];
		var r:Rectangle = new Rectangle();
		var mw:Float = 0;
		var sc:Float = 0;
		for (i in 0...ab.length) {
			graphics.beginFill(ab[i]);
			r.x = gapb;
			r.y = (gap + gapb + ch);
			r.width = (w / 2 - gapb * 1.5);
			r.height = h / 2 - gap * 2 - gapb;
			if (i == 0) mw = r.width < r.height?r.width:r.height;
			sc = mw / (ab.length + 3);
			graphics.drawRect(Std.int(r.x + i * sc), Std.int(r.y + i * sc), Std.int(r.width - i * sc * 2), Std.int(r.height - i * sc * 2));
			graphics.endFill();
		}
		for (i in 0...aw.length) {
			graphics.beginFill(aw[i]);
			r.x = gapb / 2 + (w / 2);
			r.y = (gap + gapb + ch);
			r.width = (w / 2 - gapb * 1.5);
			r.height = h / 2 - gap * 2 - gapb;				
			graphics.drawRect(Std.int(r.x + i * sc), Std.int(r.y + i * sc), Std.int(r.width - i * sc * 2), Std.int(r.height - i * sc * 2));
			graphics.endFill();
		}
		
	}
	
	private var _tfPool:Array<TextField>;
	var _colorSpectrum:Bitmap;
	
	private function addTf(text:String, color:UInt, index:Int):TextField {
		if (_tfPool[index] == null)_tfPool[index] = new TextField();			
		var t:TextField = _tfPool[index];
		t.text = text;
		t.setTextFormat(_tf);
		t.textColor = color;
		t.selectable = false;
		return t;
	}

	public function clear():Void
	{
		while(this.numChildren > 0){
			this.removeChildAt(this.numChildren - 1);
		}
		this.graphics.clear();
	}

	private function redrawColorSpectrum():Void {
		clear();
		removeChild(_colorSpectrum);
		_colorSpectrum = null;
		if(_colorSpectrum == null){
			_colorSpectrum = new Bitmap(openfl.Assets.getBitmapData("img/color_spectrum.png"),null, true);
		}

		addChild(_colorSpectrum);
		_colorSpectrum.width = w;
		_colorSpectrum.height = h;
	}
}