package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent

	/**
	 * ...
	 * @author ...
	 */
	public class Actor extends MovieClip {
		
		private var _grounded:Boolean
		
		public function Actor () {
			addEventListener(Event.ADDED_TO_STAGE, addEvents)
		}
		public function addEvents(e:Event) {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKey)
			stage..addEventListener(KeyboardEvent.KEY_UP, checkKeyUp)
			addEventListener(Event.ENTER_FRAME, loop)
		}
		private var left:Boolean
		private var right:Boolean
		private var up:Boolean
		private var down:Boolean
		
		private var _world:World
		public function setWorld(world) {
			_world = world
		}

		public function checkKey(e:KeyboardEvent) {
			if (e.keyCode.toString() == "37" || e.keyCode.toString() == "65") {
				left = true
			}
			if (e.keyCode.toString() == "39"|| e.keyCode.toString() =="68") {
				right = true
			}
			if (e.keyCode.toString() == "38"|| e.keyCode.toString() =="87" || e.keyCode.toString() == "32") {
				up = true
			}
			if (e.keyCode.toString() == "40") {
				down = true
			}
		}
		
		public function checkKeyUp(e:KeyboardEvent) {
			//isPlayerGrounded()
			if (e.keyCode.toString() == "37" || e.keyCode.toString() == "65") {
				left = false
			}
			if (e.keyCode.toString() == "39"|| e.keyCode.toString() =="68") {
				right = false
			}
			if (e.keyCode.toString() == "38"|| e.keyCode.toString() =="87" || e.keyCode.toString() == "32") {
				up = false
			}
			if (e.keyCode.toString() == "40") {
				down = false
			}
		}
		public function loop(e:Event) {
			if (left) {
				this.x -= 5
			}
			if (right) {
				this.x += 5
			}
			if (up) { 
				_world.unpauseGame()

				//this.y -=5
			}
			if (down) {
				this.y +=5
			}
		}
		public function pause() {
			this.run.stop();
		}
		public function unPause() {
			this.run.play();
		}
		
		public function getActor(spawn) {
			_grounded = false
			this.x = spawn.x
			this.y = spawn.y
			
			return this
		}
		public function getGrounded() {
			return _grounded
		}
		public function setGrounded(bool) {
			_grounded = bool
		}
		
	
	}

}