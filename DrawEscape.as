package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event
	/**
	 * ...
	 * @author Christian
	 * 3 MAJ
	 */
	public class DrawEscape extends MovieClip {
		
		private var _frontContainer:Sprite = new Sprite()
		private var _tutorialContainer:Sprite = new Sprite()

		private var menu:Menu = Menu.getInstance()
		private var _world:World = new World(_frontContainer)
		private var _tutorial:Tutorial = new Tutorial(_tutorialContainer, _world, _world.getPhysics(), _world.getDrawer())
		
		public function DrawEscape() {
			_world.setTutorial(_tutorial)
			addChild(menu.getMenu("new"))
			menu.addEventListener(Event.CHANGE, showMenu)
		}
		public function showMenu(event = null) {
			removeChild(menu.getMenu("old"))
			addChild(menu.getMenu("new"))
			trace(menu.getState())
			if (menu.getState() == 1) { //First game
				startGame() 
			} else if (menu.getState() == 2) { //Lose
				pauseGame()
			} else if (menu.getState() == 3) { //Every game after reset
				// Do you reset stuff
				resetGame()
				startGame()
			}
		}
		public function pauseGame() {
			_world.pauseGame()
		}
		public function startGame() {
			_world.createLevel()
			_tutorial.init()
			_world.getActor().setWorld(_world)
			addChild(_frontContainer)
			addChild(_tutorialContainer)
		}
		public function resetGame() {
			_world.resetLevel()
		}
		
	}

}