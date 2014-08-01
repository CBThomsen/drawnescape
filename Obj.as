package {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Obj extends MovieClip {
	
		public var cache:CachedSprite
		public var _container:Sprite
		public var _type:String
		public var _array:Array
		
		public function init(x,y,w,h,r,cont) {
			this.x = x
			this.y = y
			this.rotation = r
			this.width = w
			this.height = h
			_container = cont

			_container.addChild(this)
			
			/*cache = new CachedSprite(Object(this).constructor);
			_userData = cache.clip
			_container.addChild(_userData)*/
			this.cacheAsBitmap = true
		}
		/*public function getUserData() {
			return _userData
		}*/
		public function setArray(array) {
			_array = array
		}
		public function addFeaturesDependingOnType(type) {
			_type = type

			if(_type == "ground") {
				var w:int = this.width
				var h:int = this.height
				var obj = { point: new Point(x-w/2, y-h/2), userData:this, ground:true };
				var obj2 = { point: new Point(x+w/2, y-h/2), userData:this, ground:true};
				_array.push(new Array(obj, obj2))
			}
		}

	}
}