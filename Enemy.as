package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Enemy extends Obj {
		
		private var _hit:Boolean = false

		public function Enemy() {
		}
		private var _etype:String
		public function setType(etype) {
			_etype = etype
			if(_etype == "ground") {
				gotoAndStop(1)
			} else if(_etype == "spike") {
				gotoAndStop(2)
			}
		}
		public function hit() {
			if(!_hit) {
				var menu:Menu = Menu.getInstance()
				menu.setState(2)
				_hit = true
			}
		}
	}
}