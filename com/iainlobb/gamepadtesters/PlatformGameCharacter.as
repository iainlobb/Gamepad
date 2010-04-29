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

package com.iainlobb.gamepadtesters
{
	import com.iainlobb.gamepad.Gamepad;
	import flash.display.MovieClip;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@googlemail.com
	 */
	public class PlatformGameCharacter extends MovieClip
	{
		public var gamePad:Gamepad;
		public var speedX:Number = 0;
		public var speedY:Number = 0;
		public var gravity:Number = 0.6;
		public var grounded:Boolean;
		public var maxSpeed:Number = 10;
		public var airAcceleration:Number = 0.5;
		private var ticksInAir:int;
		private var downwardGravity:Number = 1;
		
		public function PlatformGameCharacter(colour:int, stage:Stage) 
		{
			graphics.beginFill(colour, 1);
			graphics.drawRect( -25, -25, 50, 50);
			graphics.endFill();
			
			gamePad = new Gamepad(stage, false, 1);
		}
		
		public function update():void
		{
			if (grounded)
			{
				speedX += gamePad.x;
			}
			else
			{
				speedX += gamePad.x * airAcceleration;
			}
			
			speedX *= 0.9;
			
			if (speedX > maxSpeed) speedX = maxSpeed;
			if (speedX < -maxSpeed) speedX = -maxSpeed;
			
			x += speedX;
			y += speedY;
			
			if (y > 250)
			{
				y = 250;
				grounded = true;
				speedY = 0;
			}
			
			if (grounded)
			{
				ticksInAir = 0;
			}
			else
			{
				ticksInAir++;
			}
			
			// Alternate version for non-repeating jumps:
			//if ((grounded && gamePad.up.isPressed) || (!grounded && ticksInAir < 8 && gamePad.up.isDown))
			
			if ((grounded || ticksInAir < 8) && gamePad.up.isDown)
			{
				speedY -= 2;
				grounded = false;
			}
			
			if (speedY > 0)
			{
				speedY += downwardGravity;
			}
			else
			{
				speedY += gravity;
			}
		}
	}
}