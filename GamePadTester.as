package  
{
	import com.iainlobb.Gamepad;
	import com.iainlobb.GamepadView;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@googlemail.com
	 */
	public class GamePadTester extends Sprite
	{
		private var gamePad1:Gamepad;
		private var gamePad2:Gamepad;
		private var character:MovieClip;
		private var car:MovieClip;
		private var gamePadView1:GamepadView;
		private var gamePadView2:GamepadView;
		
		public function GamePadTester() 
		{
			trace('Remember to "Disable Keyboard Shorcuts" in the stand-alone Flash player!');
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createGamepads();
			
			createGamepadViews();
			
			createCharacter();
			
			createCar();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function createGamepads():void
		{
			gamePad1 = new Gamepad(stage, true);
			gamePad1.useWASD();
			
			gamePad2 = new Gamepad(stage, false, 0.4);
		}
		
		private function createGamepadViews():void
		{
			gamePadView1 = new GamepadView();
			gamePadView1.init(gamePad1);
			gamePadView1.x = 170;
			gamePadView1.y = 330;
			addChild(gamePadView1);
			
			gamePadView2 = new GamepadView();
			gamePadView2.init(gamePad2, 0xFF6600);
			gamePadView2.x = 440;
			gamePadView2.y = 330;
			addChild(gamePadView2);
		}
		
		private function createCharacter():void
		{
			character = new MovieClip();
			character.graphics.beginFill(0x669900, 1);
			character.graphics.drawRect( -25, -25, 50, 50);
			character.graphics.endFill();
			character.x = 100;
			character.y = 200;
			addChild(character);
		}
		
		private function createCar():void
		{
			car = new MovieClip();
			car.graphics.beginFill(0xFF6600, 1);
			car.graphics.drawRect(-25,  -50, 50, 100);
			car.graphics.endFill();
			car.x = 300;
			car.y = 200;
			addChild(car);
		}
		
		private function onEnterFrame(event:Event):void
		{
			// Character (the square)
			
			character.x += gamePad1.x * 5;
			character.y += gamePad1.y * 5;
			
			// Car (the rectangle)
			
			// TANK CONTROLS:
			/*
			if (gamePad2.y <= 0)
			{
				car.rotation += gamePad2.x * 2;
			}
			else
			{
				car.rotation -= gamePad2.x * 2;
			}
			*/
			
			// CAR CONTROLS 
			car.rotation += gamePad2.x * -gamePad2.y * 2;
			
			var carAngle:Number = -car.rotation * (Math.PI / 180);
			
			car.x += Math.sin(carAngle) * gamePad2.y * 5;
			car.y += Math.cos(carAngle) * gamePad2.y * 5;
		}
		
	}

}