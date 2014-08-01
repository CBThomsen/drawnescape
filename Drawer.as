package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Drawer extends Sprite {
		
		private var _drawing:Boolean
		
		private var _startX:Number
		private var _startY:Number
		
		private var _masterArray:Array = new Array()
		private var _array:Array = new Array()
		
		public function getDrawer() {
			return this;
		}
		
		public function init() {
			_drawing = false
			freePosition = -1
			oldArray = -1
			_masterArray = new Array()
			graphics.clear()
			addEventListener(Event.ADDED_TO_STAGE, addEvents)
			if (deactivated) {
				activate()
			}
		}
		
		public function addEvents(e:Event) {
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, down)
			stage.addEventListener(MouseEvent.MOUSE_UP, up)
			
			stage.addEventListener(Event.ENTER_FRAME, drawUp)
		
		}
		
		private var deactivated:Boolean = false
		
		public function activate() {
			deactivated = false
			stage.addEventListener(MouseEvent.MOUSE_DOWN, down)
			stage.addEventListener(MouseEvent.MOUSE_UP, up)
			
			//stage.addEventListener(Event.ENTER_FRAME, drawUp)
		}
		
		public function deactivate() {
			deactivated = true
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, down)
			stage.removeEventListener(MouseEvent.MOUSE_UP, up)
			
		//	stage.removeEventListener(Event.ENTER_FRAME, drawUp)
		}
		
		public var oldArray:Number = -1
		
		public function drawUp(e:Event) {
			
		/*	graphics.clear()
			graphics.lineStyle(5, 0x000000)
			
			for (var i:int = 0; i < getArray().length; i++) {
				
				if (getArray()[i].length != 0) {
					
					if (oldArray != -1 && i == oldArray) {
						graphics.lineStyle(5, 0x000000, 0.35)
					} else {
						graphics.lineStyle(5, 0x000000)
					}
					
					graphics.moveTo(getArray()[i][0]["point"].x, getArray()[i][0]["point"].y)
					for (var j:int = 0; j < getArray()[i].length; j++) {
						graphics.lineTo(getArray()[i][j]["point"].x, getArray()[i][j]["point"].y)
					}
				} else {
					freePosition = i
				}
			}
		*/
		}
		
		public function getDrawing() {
			return _drawing
		}
		
		public function down(e:MouseEvent) {
			if (!_drawing) {
				for (var j:int = 0; j < getArray().length; j++) {
					if (getArray()[j].length != 0) {
						if (getArray()[j][0]["ground"] != true) {
							oldArray = j
						}
					}
				}
				_drawing = true
				_startX = mouseX
				_startY = mouseY
				_array = new Array()
				var obj = {point: new Point(_startX, _startY), userData: null, ground: false};
				_array.push(obj)
				if (freePosition != -1) {
					_masterArray[freePosition] = _array
					freePosition = -1
				} else {
					_masterArray.push(_array)
				}
				addEventListener(Event.ENTER_FRAME, drawing)
			} else {
				trace("_drawing er ttrue")
			}
		}
		
		public function getArray() {
			return _masterArray
		}
		public var freePosition:Number
		
		public function up(e:MouseEvent) {
			removeEventListener(Event.ENTER_FRAME, drawing)
			_drawing = false
			if (oldArray != -1) {
				getArray()[oldArray] = []
				oldArray = -1
			}
			if (_array[1] != null) {
				if (_array[0]["point"].x > _array[1]["point"].x) {
					_array.reverse()
				}
			}
		}
		private var dx:Number
		private var dy:Number
		
		public function drawing(e:Event) {
			dx = _startX - mouseX
			dy = _startY - mouseY
			if (dx < 5) { // && dy < 50) {
				var xLength = Math.sqrt(dx * dx)
				var yLength = Math.sqrt(dy * dy)
				if (xLength + yLength > 5) {
					_startX = _startX - dx
					_startY = _startY - dy
					var obj = {point: new Point(_startX, _startY), userData: null, ground: false};
					_array.push(obj)
				}
					//	} else {
			}
		}
	}

}