package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Physics extends Sprite {
		
		private var _ground:Point
		private var _ground2:Point
		private var _groundContainer:Sprite
		private var _frontContainer:Sprite
		private var _actor:MovieClip
		private var _lifeHandler:LifeHandler
		
		private var vy:Number = 0
		private var g:Number = 0.5
		private var maxv:Number = 20
		
		private var _factory:Factory
		private var _drawer:Drawer
		
		private var _objectArray:Array
		private var _levelWidth:int
		
		public function init(drawerRef, factory) {
			_hit = false
			vy = 0
			vx = 0
			angle = 0
			_drawer = drawerRef
			_factory = factory
			
			_levelWidth = _factory.getLevelWidth()
			_totalGroundMoved = 0
			_paused = false
		}
		
		public function getGroundSpeed() {
			return _groundSpeed
		}
		
		public function setGround(ground) {
			_groundContainer = ground
		}
		
		public function setFrontContainer(frontCont) {
			_frontContainer = frontCont
		}
		
		public function setStarsAndEnemies(oarray) {
			_objectArray = oarray
		}
		
		public function setLifeHandler(lifeHandler) {
			_lifeHandler = lifeHandler
		}
		
		public function setActor(actor) {
			_actor = actor
		}
		private var hits:int = 0
		
		public function getHits() {
			return hits
		}
		
		private var _ydistance:Number
		private var _xdistance:Number
		
		private var _groundBaseSpeed:Number = 6
		private var _groundSpeed:Number = _groundBaseSpeed
		
		private var _arrayNumber:int = 0
		
		private var dy:Number
		public var dx:Number
		public var yPlace:Number
		
		private var _grounded:Boolean
		private var lastGround:Object
		
		private var _topCollided:Boolean = false
		private var _userData:MovieClip
		
		public function checkCollision() {
			_grounded = false
			_topCollided = false
			lastGround = null
			_bestGround1 = null
			_bestGround2 = null
			hits = 0
			
			_drawer.graphics.clear()
			_drawer.graphics.lineStyle(5, 0x000000)
			
			for (var i:int = 0; i < _drawer.getArray().length; i++) {
				
				if (_drawer.getArray()[i].length != 0) {
					
					if (_drawer.oldArray != -1 && i == _drawer.oldArray) {
						_drawer.graphics.lineStyle(4, 0x000000, 0.35)
					} else {
						_drawer.graphics.lineStyle(4, 0x000000)
					}
					if(!_drawer.getArray()[i][0]["ground"]) {
						_drawer.graphics.moveTo(_drawer.getArray()[i][0]["point"].x, _drawer.getArray()[i][0]["point"].y)
					}
					
					for (var j:int = 0; j < _drawer.getArray()[i].length; j++) {
						
						_ground = _drawer.getArray()[i][j]["point"]
						_userData = _drawer.getArray()[i][j]["userData"]
						
						if(!_drawer.getArray()[i][j]["ground"]) {
						_drawer.graphics.lineTo(_ground.x, _ground.y)
						}
						
						//Tjekker om grounden er ude af billedet ellers flyt den
						if (_ground.x < -640) {
							if (_userData != null) {
								_groundContainer.removeChild(_userData)
								_userData = null
								_drawer.getArray()[i][j + 1]["userData"] = null
							}
							//_drawer.getArray()[i] = []
							_drawer.getArray()[i].splice(j, 2)
							break;
						} else {
							if (_drawer.getArray()[i][j]["ground"]) {
								if (_ground.x < _actor.x - 20 && !_userData.checkIfChecked() && !_userData.getHit()) {
									_lifeHandler.didNotHit()
									_userData.didNotHit()
								}
							}
							_ground.x -= _groundSpeed
							if (_userData != null) {
								_userData.x = _ground.x - _userData.width / 2
								_userData.y = _ground.y + _userData.height / 2
							}
						}
						
						if (_drawer.getArray()[i][j + 1] != null) {
							_ground2 = _drawer.getArray()[i][j + 1]["point"]
						} else {
							break;
						}
						if (_actor.x >= _ground.x && _actor.x <= _ground2.x || _actor.x <= _ground.x && _actor.x >= _ground2.x) {
							
							if (!checkForBestGround(_drawer.getArray()[i][j], _drawer.getArray()[i][j + 1])) { // Tjekker om linjen er walkable og sammenligner den med andre linjer i loopet
								//Hvis grounden ikke er walkable så tjek om karakteren rammer platformen fra bunden eller siden.
								if (_userData) {
									if (_actor.y - _actor.hit.height / 2 >= _ground.y && _actor.y - _actor.hit.height / 2 <= _ground.y + _userData.height) {
										//Hvis den rammer inden for en platform (side eller bund)
										_topCollided = true //Dræb hvis man kommer i klemme
										
										if (_actor.x + _actor.hit.width / 2 - _ground.x <= 25) { //Find ud af om man rammer fra siden og dræb 
											killActor()
										} else {
											if (vy < 0) {
												vy *= -0.01
											}
										}
									}
								}
							}
						}
					}
				} else {
					_drawer.freePosition = i
				}
			}
			if (_grounded) {
				if (_bestGround1["ground"]) {
					_bestGround1["userData"].hit()
					_lifeHandler.hit(_bestGround1)
					
				}
				angle = calculateRotation(_bestGround1["point"], _bestGround2["point"])
				yPlace = placeActor(_bestGround1["point"], _bestGround2["point"])
				
				lastAngle = angle
				vy = 0
				_actor.y = yPlace
				_actor.run.rotation = (angle * 180 / Math.PI)
				_actor.hit.x = Math.sin(angle) * _actor.run.width / 2
				_actor.setGrounded(true)
				
				if (_topCollided) {
					killActor()
				}
				
			} else {
				_actor.setGrounded(false)
			}
		}
		
		private var _bestGround1:Object
		private var _bestGround2:Object
		private var _curYPlace:Number
		private var _bestGroundYPlace:Number
		private var _groundIsWalkable:Boolean
		
		public function checkForBestGround(ground1, ground2):Boolean {
			
			_groundIsWalkable = false
			
			angle = calculateRotation(ground1["point"], ground2["point"])
			_curYPlace = placeActor(ground1["point"], ground2["point"])
			dy = Math.sqrt((_actor.y - yPlace) * (_actor.y - yPlace))
			
			if (dy <= vy + 1 || dy < 20) {
				_grounded = true
				hits += 1
				if (_bestGround1 != null) {
					angle = calculateRotation(_bestGround1["point"], _bestGround2["point"])
					_bestGroundYPlace = placeActor(_bestGround1["point"], _bestGround2["point"])
					if (_bestGround1["ground"] && !ground1["ground"]) {
						if (_curYPlace < _bestGroundYPlace) {
							_groundIsWalkable = true
							_bestGround1 = ground1
							_bestGround2 = ground2
						}
					} else if (!_bestGround1["ground"] && ground1["ground"]) {
						if (_bestGroundYPlace < _curYPlace) {
						} else {
							_groundIsWalkable = true
							_bestGround1 = ground1
							_bestGround2 = ground2
						}
					}
				} else {
					_groundIsWalkable = true
					_bestGround1 = ground1
					_bestGround2 = ground2
				}
			}
			return _groundIsWalkable
		}
		private var _hit:Boolean
		
		public function killActor() {
			if (!_hit) {
				var menu:Menu = Menu.getInstance()
				menu.setState(2)
				_hit = true
			}
		}
		private var angle:Number
		
		public function placeActor(point1, point2) {
			dx = _actor.x - point1.x
			yPlace = (point1.y) + Math.tan(angle) * (dx)
			
			return yPlace
		}
		
		var point2:Point
		
		public function calculateRotation(point1, point2) {
			var radians = Math.atan2(point2.y - point1.y, point2.x - point1.x)
			return radians
		}
		
		private var vx:Number
		private var accel:Number
		private var lastAngle:Number = 0
		
		public function doActorSpeed() {
			accel = 1 * Math.sin(lastAngle)
			if (accel < 0) {
				accel *= 0.15
			}
			if (vx < 0) {
				vx = 0
			}
			vx = vx + accel
		}
		private var _spliceb:Number = -1
		
		public function moveStarsAndEnemies() {
			for (var b:int = 0; b < _objectArray.length; b++) {
				if (_objectArray[b] != null) {
					_objectArray[b].x -= _groundSpeed
					if (_actor.x + _actor.hit.width / 2 >= _objectArray[b].x - _objectArray[b].width / 2 && _actor.x - _actor.hit.width / 2 <= _objectArray[b].x + _objectArray[b].width / 2) {
						if (_actor.y >= _objectArray[b].y - _objectArray[b].height / 2 && _actor.y - _actor.hit.height <= _objectArray[b].y + _objectArray[b].height / 2) {
							if (_objectArray[b].toString() == "[object Star]") {
								_objectArray[b].remove(_objectArray, b, _groundSpeed)
							} else if (_objectArray[b].toString() == "[object Enemy]") {
								_objectArray[b].hit()
							} else if (_objectArray[b].toString() == "[object HitField]") {
								_objectArray[b].hit()
							}
						}
					}
				} else {
					_spliceb = b
				}
			}
			if (_spliceb != -1) {
				_objectArray.splice(_spliceb, 1)
				_spliceb = -1
			}
		}
		private var _totalGroundMoved:int
		public function checkForNewSpawn() {
			_totalGroundMoved += _groundSpeed
			if (_totalGroundMoved >= _levelWidth) {
				_totalGroundMoved = 0
				_levelWidth = _factory.getLevelWidth()
				_factory.spawnNextLevelFrame()
				
				trace("DETTE ER DEN LEVELWIDHT DER SKAL NÅS: "+_levelWidth)
			}
		}
		
		public function getVX() {
			return vx
		}
		
		private var menu:Menu = Menu.getInstance()
		
		public function lose() {
			menu.setState(3)
		}
		private var _paused:Boolean = false
		public function pause() {
			_paused = true
			//removeEventListener(Event.ENTER_FRAME, update)
		}
		
		public function unPause() {
			_paused = false
			//addEventListener(Event.ENTER_FRAME, update)
		}
		
		public function update(e:Event) {
			if (!_actor.getGrounded()) {
				if (lastAngle != 0) {
					vy = ((vx * 0.2 + 10) * Math.sin(lastAngle))
					lastAngle = 0
				}
				vy = vy + g
			} else {
				vy = 0
			}
			if (_actor.y > 600) {
				lose()
			}
			vx *= 0.95
			_actor.y += vy
			if(!_paused) {
				_groundSpeed = _groundBaseSpeed //+vx
			} else {
				_groundSpeed = 0
			}
			
			checkCollision()
			moveStarsAndEnemies()
			doActorSpeed()
			checkForNewSpawn()
		}
	}
}