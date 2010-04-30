***Introducing Gamepad - http://github.com/iainlobb/Gamepad***

Gamepad is a free, open source project by me, Iain Lobb (iainlob@googlemail.com), with the aim of greatly simplifying keyboard input for Flash games. The idea was born out of 2 realisations - first, that since key.isDown was removed from ActionScript it has been more work for game developers to handle keyboard input, and second - that developers, me included, were not working with keyboard input at a sufficient level of abstraction. Trust me, if you make Flash games, you need this in your life.

***What does it do?***

Gamepad simulates an analog joystick input using the keyboard. Many times when we access key presses, what we are really doing is pretending that WASD, the arrow keys or some other combination are actually a D-pad or joystick with an X and Y axis, and 1 or 2 fire buttons. Gamepad handles the event capture, maths and other details of this for you, so you only have to think about how you want your game to respond to this input. A detailed explanation follows, but why not just download the source code and play around?

***A simple example***

First we create a gamepad. It needs a reference to the stage so it can capture keyboard events, and it needs to know whether it is simulating a circular movement space, like a thumb-stick, or a square one, like a flight-stick. This argument is called "isCircle" I'll get into this distinction later.

var gamepad:Gamepad = new Gamepad(stage, false);

Then in your update / enterFrame function, you simply adjust to the position of your character based on the "x" and "y" values of your gamepad. The "x" and "y" values are always between -1 and 1, so x = -1 would be mean the virtual D-pad is pushed all the way to the left, and x = 1 would mean it would be pushed all the way to the right. I have chosen to use y = -1 as up and y = 1 as down, so that it matches Flash's screen coordinate system.

character.x += gamepad.x * 5;
character.y += gamepad.y * 5;

And to access the fire buttons, we simply look at the "isDown" property of the "fire1" button.

if (gamepad.fire1.isDown) fire();

That's it! Your character will now happily walk around the screen using the arrow keys and fire when you press the CTRL key. As Gamepad also has easing by default, the character will also accelerate and decelerate smoothly!
 
***The "isCircle" property***

A common mistake that developers make in top-down perspective games, is to allow the player to move too fast diagonally. They say "If the up key is pressed, move up 5 pixels, and if the left key is pressed, move left 5 pixels, so if both are pressed move up 5 pixels and left 5 pixels". This is wrong! Pythagoras tells us that the speed of their character would now be the square root of five squared plus five squared, which is the square root of fifty, which is about seven. So now their character moves 5 pixels per frame horizontally or vertically, but 7 pixels per frame diagonally. Disaster. Once you know this you can handle it yourself, but Gamepad makes it easy by giving you the isCircle option on creation. When you create your gamepad, simply pass in true for the second argument:

var gamepad:Gamepad = new Gamepad(stage, true);

Now the "nub" of the virtual joystick is limited to a circular area, meaning if you hold the "down" and "right" key together, it will report values of roughly x=0.7 and y= 0.7, instead of x=1 and x=1, and movement speed will be equal in all directions. Typically you would use this option is arena shooters and Zelda-style adventure games, and you may want to use it in scrolling shmups, but that's a greyer area in terms of "realism", as your vehicle is already supposed to be moving at a high velocity.

***The "ease" property***

By default, gamepad will give you a nice easing motion. One advantage it brings is that the player can "tap" the keys to achieve the effect of a half press on an analog input such as the XBOX 360 thumb-stick. Often, though, you won't actually want to use this. You can easily turn it off by passing in 0, or pass in some other value for more/less responsiveness. Typically you'll want easing activated for simple games, but in more complex simulations you handle acceleration elsewhere, so you may want it deactivated. To deactivate easing:

var gamepad:Gamepad = new Gamepad(stage, false, 0);

***The "autoStep" property.***

Gamepad needs to update at the same rate as your game, so that the easing, and the "downTicks" and "upTicks" properties (which I'll cover later) always keep in sync with your game. If you are simply using Event.ENTER_FRAME for your update, you don't need to do anything, as this is the default. However, if you have some other system, you should pass in false for the autoStep property and manually call the public "step()" method every time you update.

I advocate using a frame-based tick, and using the "fix your timestep" methodology if you need to stay in sync with real time. This way your game is deterministic, you will have far fewer inconsistencies with collision detection, and you can safely use basic Euler calculations for acceleration. However, I understand that some developers, and some game engines, such as Flixel, use a deltaTime based approach. If you are using a time-based approach, you should use the "fix your timestep" principle with gamepad, by calling the "step()" function an appropriate number of times each update, based on how much time has passed since the user started the game.

***The GamepadInput class.***

Each Gamepad instance has a set of GamepadInput objects that represent individual "buttons" on a virtual joypad. These are up, down, left, right, fire1 and fire2. However, these do not map one-to-one with keys on the keyboard - one GamepadInput can be linked to one, two or more keys, so that you can easily provide simultaneous alternate control schemes. The classic example would be having both WASD and the arrow keys control your character, so that players can use whichever scheme they prefer without having to set any menu options.

For setting up keys, GamepadInput has the "mapKey" function. It takes two arguments: "keyCode" - an integer representing the key, for which you should use the constants in the handy "com.cheezeworld.utils.KeyCode" class - and "replaceAll" which specifies whether to overwrite existing mappings. If you want to have multiple keys mapped to the same input, pass in false.
 
In many cases, you will never need to call the "mapKey" function, as there are presets for the most popular configurations in the Gamepad class. These are the functions "useArrows", "useWASD", "useIJKL", and "useZQSD" (which is for the French "AZERTY" keyboard layout, where WASD doesn't work). All of these methods take a "replaceExisting" argument which specifies whether you want duplicate mappings, as discussed earlier.
 
Unfortunately, the keys developers use for fire buttons don't seem to be as standardised, but I have done my best, by providing the methods: "useChevrons", "useGH", "useZX", "useXY" (for German QWERTZ keyboard) and "useControlSpace". These are all taken from popular Flash games, for example Nitrome's "Double Edged" which handles 2 players by giving one player WASD for movement and GH for attacking, and the other player arrow keys for movement and chevrons, "<" and" >" for attacking. Gampad's default: Arrow keys, CONTROL and SPACEBAR should be fairly safe for all players, but there are many, many issues around international keyboards, so it may be advisable to allow the player to set their own keys.

Once you have your inputs set up, you can get information about their state: "isDown" simply tells you if a key is being held down, "isPressed" tells you if a key was pressed this frame/tick/update, and should be used instead of listening for KEY_DOWN events, "isReleased" tells you if the key was released this frame/tick/update, and should be used instead of the KEY_UP event, and "upTicks" and "downTicks" tell you how long the key has been held or released for. Basically, "isDown" is your go-to, but the others are there when you need more info.  Generally, you should use the x and y properties of Gamepad for movement, but sometimes you may want to access the D-pad as "buttons" instead, for example using "up" for jump.

***The GamepadMulitInput class.***

There are also a further set of "buttons" represented by GamePadMultiInput objects. These are special as they aggregate the inputs of multiple other "buttons". These are "upLeft", "downLeft", "upRight" and "downRight", which let you treat these combined directions as if they were individual inputs on an 8-way controller, and "anyDirection", which lets you know whether the player is pressing in any direction on the D-pad.
The angle, rotation and magnitude properties.

You may need these additional properties from time to time: "angle" gives you the direction in which the stick is pointed as radians, "rotation" is the same value but expressed in degrees and "magnitude" is the scalar distance of the "nub" from the origin, ignoring the angle. For example, if you set the rotation of a character MovieClip to negative the rotation property of your gamepad, your character will face in the right direction when they move!

***The GamepadView class***

If you want to visually see what your gamepad is doing, simply create an instance of the handy GamepadView class, and initialise it with a reference to your gamepad and optionally a colour.
var gamepadView:GamepadView = new GamepadView();
gamepadView.init(gamepad, 0xFF6600);
addChild(gamepadView);

***GamePadTester and PlatformGamePadTester***

In with the source code, you will find two visual "tester" classes. It's not quite test-driven development, but these are the classes I use to ensure all the functionality of Gamepad is working - they're also great documentation for Gamepad's APIs, or could even be the starting point for your own game! If you're using the Flash IDE simply open GamepadTester.fla or PlatformGamePadTester.fla and publish. If you're using the Flex compiler you'll need to create a new project and set the "always compile" / document class to com.iainlobb.gamepadtesters.GamePadTester.as or com.iainlobb.gamepadtesters.PlatformGamePadTester.as.

GamePadTester shows the basics of doing car-style movement and top-down character movement. It also demonstrates duplicate controls, with both WASD and IJKL controlling the character. PlatformGamePadTester shows the basics of a two player platform game, including variable height jumps (although in the end it transpired that these are mostly handled outside of the gamepad class). It also shows how you can create two instances of the same character class with different control schemes, without a single "if" statement or use of polymorphism. Composition FTW!

***Final thoughts***

Well done, you have made it through all the Gamepad documentation! Please start using it and submit feedback to my blog, or on github. I’ve had versions of this class kicking around for almost 2 years, but I had no idea how much work it would be to actually pull it all together, test and document it to a state where I was happy to release it as an open source project. I have insane new levels of respect for anyone else out there running an open source library. The license is MIT, which basically means you can do whatever you like with it, as long as you don’t blame me when it goes wrong. I’d appreciate it if you didn’t change the package names, and removing the copyright notice is forbidden. There’s a sweet gamepad logo that you can add to your game if you like, but it’s by no means compulsorily, and if you want to hit up the donate button on github, I’m not going to stop you. Enjoy!
 

