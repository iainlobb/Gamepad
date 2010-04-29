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
	import com.cheezeworld.utils.KeyCode;
	import com.iainlobb.gamepad.Gamepad;
	import com.iainlobb.gamepad.GamepadView;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@googlemail.com
	 */
	public class PlatformGamePadTester extends Sprite
	{
		private var character1:PlatformGameCharacter;
		private var character2:PlatformGameCharacter;
		private var gamePadView1:GamepadView;
		private var gamePadView2:GamepadView;
		
		public function PlatformGamePadTester() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createCharacters();
			
			createGamepadViews();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function createCharacters():void
		{
			character1 = new PlatformGameCharacter(0x669900, stage);
			character1.x = 100;
			character1.y = 200;
			character1.gamePad.useWASD(true);
			addChild(character1);
			
			character2 = new PlatformGameCharacter(0xFF6600, stage);
			character2.x = 300;
			character2.y = 200;
			addChild(character2);
		}
		
		private function createGamepadViews():void
		{
			gamePadView1 = new GamepadView();
			gamePadView1.init(character1.gamePad);
			gamePadView1.x = 170;
			gamePadView1.y = 330;
			addChild(gamePadView1);
			
			gamePadView2 = new GamepadView();
			gamePadView2.init(character2.gamePad, 0xFF6600);
			gamePadView2.x = 440;
			gamePadView2.y = 330;
			
			addChild(gamePadView2);
		}
		
		private function onEnterFrame(event:Event):void
		{
			character1.update();
			character2.update();
		}
	}
}