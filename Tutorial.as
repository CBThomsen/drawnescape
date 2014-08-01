package {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;   
	import flash.filters.BitmapFilterQuality
	import flash.filters.GlowFilter;

	
	/**
	 * ...
	 * @author ...
	 */
	public class Tutorial {
		
		private var _drawer:Drawer
		private var _physics:Physics
		private var _world:World
		private var _level:int
		private var _overlayCont:Sprite
		private var _hit:Boolean = true
		private var _num:Number = 0
		private var _highestNum:Number = 0
		
		private var _container:MovieClip
		private var _txt:TextField
		private var _tempTxt:String
		
		private var obj:MovieClip
		
		public function Tutorial(overlayCont, world, physics, drawer) {
		_world = world
		_drawer = drawer
		_physics = physics
		_overlayCont =overlayCont
		
		createWriteBox()
		}
		public function createWriteBox() {
			_container = new MovieClip()
			_overlayCont.addChild(_container)
			_container.x = 20
			_container.y = 60
			
			var font:Font = new MainFont()
			//var font:Font = new Font1()
			
			_txt = new TextField()
			_txt.width = 600
			_txt.height = 75
			_txt.multiline = true
			_txt.wordWrap = true
			_txt.textColor = 0x555555
			_txt.selectable = false
			var _format = new TextFormat()
			_format.size = 22
			_format.font = "American Captain"
			//_format.font = "HVD Bodedo"
			_format.align = "center"
			//var outline:GlowFilter=new GlowFilter(0xdddddd,1.0,2.0,2.0,10);
			//outline.quality=BitmapFilterQuality.MEDIUM;
			//_txt.filters=[outline];
			
			_txt.defaultTextFormat = _format
			_container.addChild(_txt)
			}
		public function init() {
			_num = 0
			_highestNum = 0
			_level = _world.getLevel()
			if (obj != null)  { 
				_overlayCont.removeChild(obj)
				obj = null
			}
			writeText("")
			doLvl()
		}
		public function writeText(txt, faded:Boolean = false) {
			if (txt == "") {
				_txt.text = txt
			}
			if (txt != "" && !faded) {
				_container.alpha = 1
				_container.addEventListener(Event.ENTER_FRAME, fadeOut)
				_tempTxt = txt
			}
			if (faded) {
				_txt.text = txt
				_container.addEventListener(Event.ENTER_FRAME, fadeIn)
				_container.alpha = 0
			}
		}
		public function fadeOut(e:Event) {
			_container.alpha -= 0.25
			if (_container.alpha < 0) {
				_container.removeEventListener(Event.ENTER_FRAME, fadeOut)
				writeText(_tempTxt, true)
			}
		}
		public function fadeIn(e:Event) {
			_container.alpha += 0.1
			if (_container.alpha > 1) {
				_container.removeEventListener(Event.ENTER_FRAME, fadeIn)
			}
			
		}
		public function setNum(num) {
			_num = num	
			_hit = true
			check()
		}		
		public function doLvl() {
			if (_level == 1) {
				doLvl1()
			}
			if (_level == 2) {
				doLvl2()
			}
			if (_level == 3) {
				doLvl3()
			}
			if (_level == 4) {
				doLvl4()
			}
			if (_level == 5) {
				doLvl5()
			}
			if (_level == 6) {
				doLvl6()
			}if (_level == 7) {
				doLvl7()
			}if (_level == 8) {
				doLvl8()
			}if (_level == 9) {
				doLvl9()
			}if (_level == 10) {
				doLvl10()
			}if (_level == 11) {
				doLvl11()
			}if (_level == 12) {
				doLvl12()
			}
			if (_level == 21) {
				doLvl21()
			}
		}
		public function doLvl1() {
			if(_num == 0) {
				writeText("")
			} else if (_num == 1) {
				_world.pauseGame()
				writeText("Draw a line with your finger to get from one side to the other!")
				spawnHelp(_level)
			} else if (_num == 2) {
				writeText("")
			} else if (_num == 3) {
				writeText("")
			}
			
		}
		public function doLvl2() {
		if (_num == 0) {
			writeText("Use your mouse to drag the green box. Use it to create a shadow that can help you get to the door.")
			spawnHelp(2)
		}
		if (_num == 1) {
			_overlayCont.removeChild(obj)
			obj = null
			writeText("Perfect!")
		}
		}
		
		public function doLvl3() {
			if (_num == 0) {
				writeText("Use your mouse to drag the green lamp. Again use it to create a shadow that can help you get to the door.")
				spawnHelp(3)
			}
			if (_num == 1) {
				_overlayCont.removeChild(obj)
				obj = null
				writeText("That'll do it! Now let's move on...")
			}
		}
			
		public function doLvl4() {
			if (_num == 0) {
				writeText("So far so good. Will the doors lead you anywhere?")
			}
		}
		public function doLvl5() {
			if (_num == 0) {
				writeText("Green lamp means you can move it. Move it to get to the door.")
			}
			if (_num == 1) {
				writeText("You made it!")
				}
		}public function doLvl6() {
			if (_num == 0) {
				writeText("You can move the box mid air or while standing on it. Get to the other side and hit the switch.")
			}
			if (_num == 1) {
				writeText("Great! Now get to that door. You like doors.")
				}
		}	
		public function doLvl7() {
				if (_num == 0) {
				writeText("Shadows also work as planes. Wonderful isn't it.")
			}
			if (_num == 1) {
				writeText("")
				}
		}
		public function doLvl8() {
			if (_num == 0) {
				writeText("You can't get to the door just yet. Get to the switches and see what happens.")
			}
			if (_num == 1) {
				writeText("")
				}
		}
		public function doLvl9() {
				if (_num == 0) {
				writeText("")
			}
			if (_num == 1) {
				writeText("")
				}
		}
		public function doLvl10() {
			if (_num == 0) {
				writeText("When you move a shadow time freezes. This means you can position shadows while mid-air. Hint hint!")
			}
			if (_num == 1) {
				writeText("")
				}
		}
		public function doLvl11() {
				if (_num == 0) {
				writeText("")
			}
			if (_num == 1) {
				writeText("")	}
		}
		public function doLvl12() {
				if (_num == 0) {
				writeText("Only way to reach the exit is to move the shadow while mid-air. Feels like cheating doesn't it?")
			}
			if (_num == 1) {
				writeText("")
				}
		}
		public function doLvl21() {
				if (_num == 0) {
				writeText("All of a sudden the doors disappeared.")
			}
			if (_num == 1) {
				writeText("Only way to get out of this limbo will be to kill yourself. Once and for all.")
				}
				if (_num == 2) {
					writeText("")
				}
		}
		public function spawnHelp(level) {
			if (obj != null)  { 
				_overlayCont.removeChild(obj)
				obj = null
			}
			if (level == 1) {
				obj = new Tut1_helper()
				obj.x = 0
				obj.y = 0
				_overlayCont.addChild(obj)
				_startedDrawing = false
				_overlayCont.addEventListener(Event.ENTER_FRAME, checkForCompleteTutorial)
			}
			if (level == 3) {
			//	obj = new Tut3_helper
				obj.x = 361
				obj.y = 144
			_overlayCont.addChild(obj)
			}
		}
		private var _startedDrawing:Boolean
		private var _endedDrawing:Boolean
		private var _startedDrawingAtX:int
		public function checkForCompleteTutorial(e:Event) {
			if(_drawer.getDrawing() && !_startedDrawing) {
				_startedDrawingAtX = _overlayCont.mouseX
				_startedDrawing = true
			}
			if(!_drawer.getDrawing() && _startedDrawing) {
				//trace(_overlayCont.mouseX)
			//	if(_startedDrawingAtX < 230 && _overlayCont.mouseX > 490) {
					_world.unpauseGame()
					_overlayCont.removeEventListener(Event.ENTER_FRAME, checkForCompleteTutorial)
			}
			
		}
		
		public function check() {
			if (_hit) {
				if(_highestNum == _num-1) {
				_highestNum = _num
				doLvl()
				_hit = false
				}
			}
		}
	
	}

}