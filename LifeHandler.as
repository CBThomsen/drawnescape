package {
	import flash.display.MovieClip;
	public class LifeHandler extends MovieClip {
		
		private var _lives:int = 3
		public function LifeHandler() {

		}
		private var _lastGround:Object
		public function reset() {
			_lives = 3
			_notHitBlocks = 0
			_hitBlocks = 0
			_totalBlocks = 0
			_lastGround = null
			gotoAndStop(1)
		}
		public function getHits() {
			return _hitBlocks;
		}
		public function getNotHits() {
			return _notHitBlocks
		}
		public function getTotalBlocks() {
			return _totalBlocks
		}

		private var _notHitBlocks:int
		private var _hitBlocks:int
		private var _totalBlocks:int
		public function didNotHit() {
				_notHitBlocks += 1
				_totalBlocks += 1
		}
		public function hit(ground) {
			if(ground != _lastGround) {
				_hitBlocks += 1
				_totalBlocks += 1
				_lastGround = ground
			}
		}
	}
}