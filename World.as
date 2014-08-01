package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event
	import flash.events.TimerEvent
	import flash.utils.Timer
	import flash.text.TextField;
	import flash.utils.getDefinitionByName
	
	/**
	 * ...
	 * @author ...
	 */
	public class World extends Sprite {
		
		private var menu:Menu = Menu.getInstance()
		
		private var _actor:Actor = new Actor()
		private var _drawer:Drawer = new Drawer()
		private var _physics:Physics = new Physics()
		private var _lifeHandler:LifeHandler = new LifeHandler()
		private var _factory:Factory = new Factory()
		
		private var _spawn:Point
		
		private var _frontContainer:Sprite
		
		private var _text:TextField
		private var _text2:TextField
		
		private var _lvl:int = 1
		private var _objectArray:Array
		
		public function World(frontCont) {
			_frontContainer = frontCont
			
			_text = new TextField()
			_text.x = 20
			_text.width = 300
			_text.y = 30
			
			_text2 = new TextField()
			_text2.x = 20
			_text2.width = 300
			_text2.y = 100
			
			_frontContainer.addChild(_text)
			_frontContainer.addChild(_text2)
		}
		public function setTutorial(tut) {
			_factory.setTutorial(tut)
		}
		
		public function getPhysics() {
			return _physics
		}
		
		public function getDrawer() {
			return _drawer
		}
		
		public function getLevel() {
			return _lvl
		}
		
		public function getActor() {
			return _actor
		}
		
		private var _groundContainer:Sprite
		private var _star:Star
		private var _enemy:Enemy
		private var _starTimer:Timer
		private var _enemyTimer:Timer
		
		public function createLevel() {
			_drawer.init()
			_groundContainer = new Sprite()
			_frontContainer.addChild(_groundContainer)
			_frontContainer.addChild(_drawer.getDrawer())
			_frontContainer.addChild(_lifeHandler)
			_factory.setLevel(_lvl)
			_factory.setDrawer(_drawer)
			_factory.setContainers(_frontContainer, _groundContainer)
			
			spawnObjects()
			
			_actor = _actor.getActor(_factory.getSpawn())
			_frontContainer.addChild(_actor)
			
			_actor.unPause()
			_lifeHandler.reset()
			
			_physics.init(_drawer, _factory)
			
			_factory.spawnNextLevelFrame()
			_objectArray = _factory.getObjectArray()
			
			_physics.setGround(_groundContainer)
			_physics.setFrontContainer(_frontContainer)
			_physics.setActor(_actor)
			_physics.setStarsAndEnemies(_objectArray)
			_physics.setLifeHandler(_lifeHandler)
			
			addEventListener(Event.ENTER_FRAME, loop)
			_physics.addEventListener(Event.ENTER_FRAME, _physics.update)
		
		}
		public function spawnObjects() {
			_factory.spawnObjects()
		}
		private var _paused:Boolean = false
		
		public function pauseGame() {
			_physics.pause()
			_actor.pause()
			//_drawer.deactivate()
			
			_paused = true
		}
		
		public function unpauseGame() {
			_physics.unPause()
			_actor.unPause()
			//_drawer.activate()
			_paused = false
		}
		
		public function resetLevel() {
			_factory.removeObjects()
			removeEventListener(Event.ENTER_FRAME, _physics.update)
		}
		
		public function loop(e:Event) {
			_text.text = "Speed: " + ((Math.round(_physics.getVX() * 10) / 10) + 2.0) + " MPH"
			_text2.text = _lifeHandler.getHits() + " IKKE HITS:  " + _lifeHandler.getNotHits() + " OUT OF:  " + _lifeHandler.getTotalBlocks()
		}
	
	}

}