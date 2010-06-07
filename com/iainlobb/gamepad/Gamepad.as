/*
Copyright (c) 2010 Iain Lobb

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

package com.iainlobb.gamepad
{
	import com.cheezeworld.utils.KeyCode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	
	public class Gamepad
	{
		// INPUTS:
			
		protected var _up:GamepadInput;
		protected var _down:GamepadInput;
		protected var _left:GamepadInput;
		protected var _right:GamepadInput;
		protected var _fire1:GamepadInput;
		protected var _fire2:GamepadInput;
		protected var _inputs:Array;
		
		// MULTI-INPUTS (combines 2 or more inputs into 1, e.g. _upLeft requires both up and left to be pressed)
		
		protected var _upLeft:GamepadMultiInput;
		protected var _downLeft:GamepadMultiInput;
		protected var _upRight:GamepadMultiInput;
		protected var _downRight:GamepadMultiInput;
		protected var _anyDirection:GamepadMultiInput;
		protected var _multiInputs:Array;
		
		// THE "STICK"
		
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _targetX:Number = 0;
		protected var _targetY:Number = 0;
		protected var _angle:Number = 0;
		//protected var _targetAngle:Number = 0;
		protected var _rotation:Number = 0;
		protected var _magnitude:Number = 0;
		
		public var isCircle:Boolean;
		public var autoStep:Boolean;
		public var ease:Number;
		
		public function Gamepad(stage:Stage, isCircle:Boolean, ease:Number = 0.2, autoStep:Boolean = true)
		{
			trace('Remember to hit "Control > Disable Keyboard Shorcuts" in the Flash IDE & stand-alone Flash player!');
			
			this.isCircle = isCircle;
			this.ease = ease;
			
			_up = new GamepadInput();
			_down = new GamepadInput();
			_left = new GamepadInput();
			_right = new GamepadInput();
			_fire1 = new GamepadInput();
			_fire2 = new GamepadInput();
			
			_inputs = [_up, _down, _left, _right, _fire1, _fire2];
			
			_upLeft = new GamepadMultiInput([_up, _left], false);
			_upRight = new GamepadMultiInput([_up, _right], false);
			_downLeft = new GamepadMultiInput([_down, _left], false);
			_downRight = new GamepadMultiInput([_down, _right], false);
			_anyDirection = new GamepadMultiInput([_up, _down, _left, _right], true);
			
			_multiInputs = [_upLeft, _upRight, _downLeft, _downRight, _anyDirection];
			
			useArrows();
			useControlSpace();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
			
			if (autoStep)
			{
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
		}
		
		// DIRECTION PRESETS
		
		public function mapDirection(up:int, down:int, left:int, right:int, replaceExisting:Boolean = false):void
		{
			_up.mapKey(up, replaceExisting);
			_down.mapKey(down, replaceExisting);
			_left.mapKey(left, replaceExisting);
			_right.mapKey(right, replaceExisting);
		}
		
		public function useArrows(replaceExisting:Boolean = false):void
		{
			mapDirection(Keyboard.UP, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, replaceExisting);
		}
		
		public function useWASD(replaceExisting:Boolean = false):void
		{
			mapDirection(KeyCode.W, KeyCode.S, KeyCode.A, KeyCode.D, replaceExisting);
		}
		
		public function useIJKL(replaceExisting:Boolean = false):void
		{
			mapDirection(KeyCode.I, KeyCode.K, KeyCode.J, KeyCode.L, replaceExisting);
		}
		
		public function useZQSD(replaceExisting:Boolean = false):void
		{
			mapDirection(KeyCode.Z, KeyCode.S, KeyCode.Q, KeyCode.D, replaceExisting);
		}
		
		// FIRE BUTTON PRESETS
		
		public function mapFireButtons(fire1:int, fire2:int, replaceExisting:Boolean = false):void
		{
			_fire1.mapKey(fire1, replaceExisting);
			_fire2.mapKey(fire2, replaceExisting);
		}
		
		public function useChevrons(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.LESS_THAN, KeyCode.GREATER_THAN, replaceExisting);
		}
		
		public function useGH(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.G, KeyCode.H, replaceExisting);
		}
		
		public function useZX(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.Z, KeyCode.X, replaceExisting);
		}
		
		public function useYX(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.Y, KeyCode.X, replaceExisting);
		}
		
		public function useControlSpace(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.CONTROL, KeyCode.SPACEBAR, replaceExisting);
		}
		
		// UPDATE:
		
		public function step():void
		{
			_x += (_targetX - _x) * ease;
			_y += (_targetY - _y) * ease;
			
			_magnitude = Math.sqrt((_x * _x) + (_y * _y));
			
			_angle = Math.atan2(_x, _y);
			
			_rotation = _angle * 57.29577951308232;
			
			for each (var gamepadInput:GamepadInput in _inputs) gamepadInput.update();
		}
		
		// GETTERS:
		
		public function get angle():Number { return _angle; }
		
		public function get x():Number { return _x; }
		
		public function get y():Number { return _y; }
		
		public function get up():GamepadInput { return _up; }
		
		public function get down():GamepadInput { return _down; }
		
		public function get left():GamepadInput { return _left; }
		
		public function get right():GamepadInput { return _right; }
		
		public function get upLeft():GamepadMultiInput { return _upLeft; }
		
		public function get downLeft():GamepadMultiInput { return _downLeft; }
		
		public function get upRight():GamepadMultiInput { return _upRight; }
		
		public function get downRight():GamepadMultiInput { return _downRight; }
		
		public function get fire1():GamepadInput { return _fire1; }
		
		public function get fire2():GamepadInput { return _fire2; }
		
		public function get anyDirection():GamepadMultiInput { return _anyDirection; }
		
		public function get magnitude():Number { return _magnitude; }
		
		public function get rotation():Number { return _rotation; }
		
		// PROTECTED METHODS:
		
		protected function onEnterFrame(event:Event):void
		{
			step();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			for each (var gamepadInput:GamepadInput in _inputs) gamepadInput.keyDown(event.keyCode);
			
			updateState();
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			for each (var gamepadInput:GamepadInput in _inputs) gamepadInput.keyUp(event.keyCode);
			
			updateState();
		}
		
		protected function updateState():void
		{
			for each (var gamepadMultiInput:GamepadMultiInput in _multiInputs) gamepadMultiInput.update();
			
			if (_up.isDown)
			{
				_targetY = -1;
			}
			else if (_down.isDown)
			{
				_targetY = 1;
			}
			else
			{
				_targetY = 0;
			}
			
			if (_left.isDown)
			{
				_targetX = -1;
			}
			else if (_right.isDown)
			{
				_targetX = 1;
			}
			else
			{
				_targetX = 0;
			}
			
			var _targetAngle:Number = Math.atan2(_targetX, _targetY);
			
			//_rotation = _angle * 57.29577951308232;
			
			if (isCircle && _anyDirection.isDown)
			{
				_targetX = Math.sin(_targetAngle);
				_targetY = Math.cos(_targetAngle);
			}
		}
	}
}