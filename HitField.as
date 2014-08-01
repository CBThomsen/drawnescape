package {
	public class HitField extends Obj {

		private var _tut:Tutorial
		public function setTutorial(tut) {
			_tut = tut
		}
		public function hit() {
			_tut.setNum(Number(name.slice(3)))
		}
	}
}