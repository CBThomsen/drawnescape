package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event
	import flash.events.EventDispatcher
	import flash.events.MouseEvent	
	/**
	 * ...
	 * @author Christian
	 */
	public class Menu extends EventDispatcher {
		
		private var _menu
		private var _stateNumber:int = 0
		private var _oldStateNumber:int
		private var _oldMenu
		
		private static var _instance:Menu
		
		public static function getInstance():Menu {
			if (Menu._instance == null) {
				Menu._instance = new Menu()
			}
			return Menu._instance
		}
		
		public function getMenu(state:String):MovieClip {
			if (state == "new") {
				if (getState() == 0) { // The game menu
					_menu = new menu1()
					_menu.button.addEventListener(MouseEvent.CLICK, mouseClick)
				}
				if (getState() == 1) { // The game (emtpy menu)
					_menu = new menu2()
					_menu.button.addEventListener(MouseEvent.CLICK, resetClick)
				}
				if (getState() == 2) { // The you lost menu
					_menu = new menu3()
					_menu.button.addEventListener(MouseEvent.CLICK, resetClick)
				}
				if (getState() == 3) { // The game again after you reset
					_menu = new menu2()
					_menu.button.addEventListener(MouseEvent.CLICK, resetClick)
				}
			}
			return _menu
		
		}
		
		public function getState():int {
			return _stateNumber
		}
		
		public function setState(value:int) {
			_oldStateNumber = _stateNumber
			_stateNumber = value
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function mouseClick(e:MouseEvent) {
			setState(1)
		}
		public function resetClick(e:MouseEvent) {
			setState(3)
		}
	
	}

}