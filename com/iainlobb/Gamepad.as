package com.iainlobb 
{
	import com.cheezeworld.utils.KeyCode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	
	public class Gamepad extends EventDispatcher
	{
		// STATE:
			
		protected var _up:Boolean;
		protected var _down:Boolean;
		protected var _left:Boolean;
		protected var _right:Boolean;
		protected var _upLeft:Boolean;
		protected var _downLeft:Boolean;
		protected var _upRight:Boolean;
		protected var _downRight:Boolean;
		protected var _fire1:Boolean;
		protected var _fire2:Boolean;
		protected var _any:Boolean;
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _targetX:Number = 0;
		protected var _targetY:Number = 0;
		protected var _angle:Number;
		protected var _rotation:Number;
		
		// CONFIGURATION:
		
		public var leftKey:uint = Keyboard.LEFT;
		public var rightKey:uint = Keyboard.RIGHT;
		public var downKey:uint = Keyboard.DOWN;
		public var upKey:uint = Keyboard.UP;
		public var fire1Key:uint = Keyboard.SPACE;
		public var fire2Key:uint = Keyboard.ENTER;
		
		public var isCircle:Boolean;
		public var autoStep:Boolean;
		public var ease:Number;
		
		public function Gamepad(stage:Stage, isCircle:Boolean, ease:Number = 0.2, autoStep:Boolean = true)
		{
			this.isCircle = isCircle;
			this.ease = ease;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
			
			if (autoStep)
			{
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
		}
		
		public function useArrows():void
		{
			leftKey = Keyboard.LEFT;
			rightKey = Keyboard.RIGHT;
			downKey = Keyboard.DOWN;
			upKey = Keyboard.UP;
		}
		
		public function useWASD():void
		{
			leftKey = KeyCode.A;
			rightKey = KeyCode.D;
			downKey = KeyCode.S;
			upKey = KeyCode.W;
		}
		
		public function step():void
		{
			_x += (_targetX - _x) * ease;
			_y += (_targetY - _y) * ease;
		}
		
		protected function onEnterFrame(event:Event):void
		{
			step();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case upKey:
					_up = true;
					break;
				case downKey:
					_down = true;
					break;
				case leftKey:
					_left = true;
					break;
				case rightKey:
					_right = true;
					break;
				case fire1Key:
					_fire1 = true;
					break;
				case fire2Key:
					_fire2 = true;
					break;
				default:
					// Not a game key
					break;
			}
			
			updateState();
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode) 
			{
				case upKey:
					_up = false;
					break;
				case downKey:
					_down = false;
					break;
				case leftKey:
					_left = false;
					break;
				case rightKey:
					_right = false;
					break;
				case fire1Key:
					_fire1 = false;
					break;
				case fire2Key:
					_fire2 = false;
					break;
				default:
					// Not a game key
				break;
			}
			
			updateState();
		}
		
		protected function updateState():void
		{
			_upLeft = _up && _left;
			_upRight = _up && _right;
			_downLeft = _down && _left;
			_downRight = _down && _right;
			
			_any = _up || _down || _right || _left;
			
			if (_up)
			{
				_targetY = -1;
			}
			else if (_down)
			{
				_targetY = 1;
			}
			else
			{
				_targetY = 0;
			}
			
			if (_left)
			{
				_targetX = -1;
			}
			else if (_right)
			{
				_targetX = 1;
			}
			else
			{
				_targetX = 0;
			}
			
			_angle = Math.atan2(_targetX, _targetY);
			
			_rotation = _angle * 57.29577951308232;
			
			if (isCircle && _any)
			{
				_targetX = Math.sin(angle);
				_targetY = Math.cos(angle);
			}
			
			step();
		}
		
		public function get angle():Number { return _angle; }
		
		public function get x():Number { return _x; }
		
		public function get y():Number { return _y; }
		
		public function get up():Boolean { return _up; }
		
		public function get down():Boolean { return _down; }
		
		public function get left():Boolean { return _left; }
		
		public function get right():Boolean { return _right; }
		
		public function get upLeft():Boolean { return _upLeft; }
		
		public function get downLeft():Boolean { return _downLeft; }
		
		public function get upRight():Boolean { return _upRight; }
		
		public function get downRight():Boolean { return _downRight; }
		
		public function get fire1():Boolean { return _fire1; }
		
		public function get fire2():Boolean { return _fire2; }
		
		public function get any():Boolean { return _any; }
		
	}
}