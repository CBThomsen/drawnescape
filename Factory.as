package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author ...
	 */
	public class Factory {
		
		private var _lvl:int
		private var _offset:int
		private var _levelFrame:int
		private var _drawer:Drawer
		public function setDrawer(drawer) {
			_drawer = drawer
		}
		public function setLevel(lvl) {
			_lvl = lvl
			_levelFrame = 1
			_offset = 0
		}
		private var _frontContainer:Sprite
		private var _groundContainer:Sprite
		public function setContainers(frontCont, groundCont) {
			_frontContainer = frontCont
			_groundContainer = groundCont
		}
		private var _editor:MovieClip
		private var _objectArray:Array = new Array()
		
		public function getObjectArray() {
			return _objectArray;
		}
		private var _spawn:Point
		public function getSpawn() {
			return _spawn
		}
		public function getLevelWidth() {
			return _levelWidth;
		}
		private var _tut:Tutorial
		public function setTutorial(tut) {
			_tut = tut
		}
		public function spawnNextLevelFrame() {
			_levelFrame += 1
			_offset = _levelWidth
			spawnObjects()
		}
		private var _levelWidth:int
		public function spawnObjects() {
			_editor = new (getDefinitionByName("level" + _lvl) as Class);
			_editor.gotoAndStop(_levelFrame)
			_editor.x = _offset
			_levelWidth = _editor.width
			
			trace("LEVELWIDTH FRA: "+_levelFrame+" ER: "+_levelWidth)
			
			var _cont:Sprite
			
			for (var i:int = 0; i < _editor.numChildren; i++) {
				with (_editor.getChildAt(i)) {
					_cont = _frontContainer
					if (name == "ground") {
						_cont = _groundContainer
						_obj = createGround(_editor.getChildAt(i))
						continue;
					} else if (name.slice(0, 5) == "enemy") {
						_obj = new Enemy()
						_obj.setType(name.slice(6))
						_objectArray.push(_obj)
					} else if (name == "star") {
						_obj = new Star()
						_objectArray.push(_obj)
					} else if (name == "spawn") {
						_spawn = new Point(x, y)
						continue;
					} else if (name.slice(0, 3) == "hit") {
						_obj = new HitField()
						_obj.setTutorial(_tut)
						_objectArray.push(_obj)
					} else {
						continue
					}
					_obj.name = name
					_obj.init(x+_offset, y, width, height, rotation, _cont)
					_obj.addFeaturesDependingOnType(name)
				}
			}
		}
		
		private var groundW:int = 40
		public function createGround(ground) {
			
			var tempGround:Ground
			var X:int = ground.x+_offset
			var Y:int = ground.y
			var H:int = ground.height
			var W:int = ground.width
			var R:int = ground.rotation
			var Name:String = ground.name
			groundW = W
			
			for (var j:int = 0; j < W / groundW; j++) {
				tempGround = new Ground()
				tempGround.setArray(_drawer.getArray())
				tempGround.name = Name
				tempGround.init(X - W / 2 + j * groundW + groundW / 2, Y, groundW, H, R, _groundContainer)
				tempGround.addFeaturesDependingOnType(Name)
			}
		}
		public function removeObjects() {
			for (var i:int = 0; i < _objectArray.length; i++) {
				if ("getDestroyed" in _objectArray[i]) { //Tjekker om den er en stjerne, og smadrer den ikke hvis den er i gang med at fade
					if (!_objectArray[i].getDestroyed()) {
						_frontContainer.removeChild(_objectArray[i])
					}
				} else {
					_frontContainer.removeChild(_objectArray[i])
				}
			}
			for (var j:int = 0; j < _drawer.getArray().length; j++) {
				for (var k:int = 0; k < _drawer.getArray()[j].length; k++) {
					if (_drawer.getArray()[j][k]["userData"] != null) {
						_groundContainer.removeChild(_drawer.getArray()[j][k]["userData"])
						_drawer.getArray()[j][k]["userData"] = null
						_drawer.getArray()[j][k + 1]["userData"] = null
					}
				}
			}
			_objectArray = []
		}
	}

}