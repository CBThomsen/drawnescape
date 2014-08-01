package {
	import flash.display.Sprite;
	import flash.geom.Point

	
	/**
	 * ...
	 * @author ...
	 */
	public class Ground extends Obj {
		
		private var _hit:Boolean = false
		public function hit() {
			if(!_hit) {
				_hit = true
				gotoAndStop(2)
			}
		}
		private var _checked:Boolean = false
		public function getHit() {
				_checked = true
				return _hit
		}
		public function checkIfChecked() {
			return _checked
		}
		public function didNotHit() {
				gotoAndStop(3)
		}
	}

}