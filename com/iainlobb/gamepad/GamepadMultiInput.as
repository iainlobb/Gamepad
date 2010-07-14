/*
Copyright (c) 2010 Iain Lobb - iainlobb@gmail.com

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
	public class GamepadMultiInput
	{
		protected var _isDown:Boolean;
		protected var _isPressed:Boolean;
		protected var _isReleased:Boolean;
		protected var _downTicks:int = -1;
		protected var _upTicks:int = -1;
		protected var isOr:Boolean;
		protected var inputs:Array;
		
		/*
		* Represents a virtual button that combines the input of 2 or more other buttons, e.g. up-left/north-west. End users shouldn't need to create these.
		* 
		*/
		public function GamepadMultiInput(inputs:Array, isOr:Boolean) 
		{
			this.inputs = inputs;
			this.isOr = isOr;
		}
		
		/*
		* Called by owner Gamepad. End users should not call this function.
		*/
		public function update():void
		{
			if (isOr)
			{
				_isDown = false;
			
				for each (var gamepadInput:GamepadInput in inputs)
				{
					if (gamepadInput.isDown)
					{
						_isDown = true;
						break;
					}
				}
			}
			else
			{
				_isDown = true;
			
				for each (var gamepadInput:GamepadInput in inputs)
				{
					if (!gamepadInput.isDown)
					{
						_isDown = false;
						break;
					}
				}
			}
			
			
			if (_isDown)
			{
				_isPressed = _downTicks == -1;
				_isReleased = false;
				_downTicks++;
				_upTicks = -1;
			}
			else
			{
				_isReleased = _upTicks == -1;
				_isPressed = false;
				_upTicks++;
				_downTicks = -1;
			}
		}
		
		/*
		 * Is this input currently held down. 
		 */
		public function get isDown():Boolean { return _isDown; }
		
		/*
		 * Was this input pressed this frame/step - use instead of listening to key down events.
		 */
		public function get isPressed():Boolean { return _isPressed; }
		
		/*
		 * Was this input released this frame/step - use instead of listening to key up events.
		 */
		public function get isReleased():Boolean { return _isReleased; }
		
		/*
		 * How long has the input been held down.
		 */
		public function get downTicks():int { return _downTicks; }
		
		/*
		 * How long since the input was last released.
		 */
		public function get upTicks():int { return _upTicks; }
		
	}
}