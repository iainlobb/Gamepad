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
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@googlemail.com
	 */
	public class GamepadMultiInput
	{
		public var isDown:Boolean;
		public var isPressed:Boolean;
		public var isReleased:Boolean;
		public var downTicks:int = -1;
		public var upTicks:int = -1;
		public var inputs:Array;
		public var isOr:Boolean;
		
		public function GamepadMultiInput(inputs:Array, isOr:Boolean) 
		{
			this.inputs = inputs;
			this.isOr = isOr;
		}
		
		public function update():void
		{
			if (isOr)
			{
				isDown = false;
			
				for each (var gamepadInput:GamepadInput in inputs)
				{
					if (gamepadInput.isDown)
					{
						isDown = true;
						break;
					}
				}
			}
			else
			{
				isDown = true;
			
				for each (var gamepadInput:GamepadInput in inputs)
				{
					if (!gamepadInput.isDown)
					{
						isDown = false;
						break;
					}
				}
			}
			
			
			if (isDown)
			{
				isPressed = downTicks == -1;
				isReleased = false;
				downTicks++;
				upTicks = -1;
			}
			else
			{
				isReleased = upTicks == -1;
				isPressed = false;
				upTicks++;
				downTicks = -1;
			}
		}
		
	}
}