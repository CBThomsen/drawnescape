package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event
	/**
	 * ...
	 * @author ...
	 */
	public class Star extends Obj {

		private var _num:int
		private var _speed:Number

		public function Star() {
		}
		private var _destroyed:Boolean
		public function getDestroyed() {
			return _destroyed
		}
		public function remove(array, num, speed) {
			_array = array
			_speed = speed
			_num = num
			_array[_num] = null
			_destroyed = true
			this.play()
			addEventListener(Event.ENTER_FRAME, checkFrame)
		}
		public function checkFrame(e:Event) {
			this.x -= _speed
			if(this.currentFrame >= 15) {
				_container.removeChild(this)
				removeEventListener(Event.ENTER_FRAME, checkFrame)
			}
		}

	}
}