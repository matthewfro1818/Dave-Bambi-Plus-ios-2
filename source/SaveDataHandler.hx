package;

import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

/**
 * handles save data initialization 
*/
class SaveDataHandler
{
    public static function initSave()
    {
        if (FlxG.save.data.antialiasing == null)
			FlxG.save.data.antialiasing = true;

		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

	    if (FlxG.save.data.fpsRain == null)
		   FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.blurNotes == null)
			FlxG.save.data.blurNotes = false;

		if (FlxG.save.data.micedUpSus == null)
			FlxG.save.data.micedUpSus = true;

		if (FlxG.save.data.judgementCounter == null)
			FlxG.save.data.judgementCounter = true;

		if (FlxG.save.data.showCombo == null)
			FlxG.save.data.showCombo = true;

		if (FlxG.save.data.hideHud == null)
			FlxG.save.data.hideHud = false;

		if (FlxG.save.data.ratingSystemNum == null)
			FlxG.save.data.ratingSystemNum = 0;

		if (FlxG.save.data.mirror == null)
			FlxG.save.data.mirror = false;

		if (FlxG.save.data.colorBars == null)
			FlxG.save.data.colorBars = true;

	    if (FlxG.save.data.fpsCap == null)
		   FlxG.save.data.fpsCap = 120;

	    if (FlxG.save.data.fpsCap < 60)
		   FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine
		
		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.eyesores == null)
			FlxG.save.data.eyesores = true;

		if (FlxG.save.data.hitVolume == null)
			FlxG.save.data.hitVolume = 0.5;

		if (FlxG.save.data.missSounds == null)
			FlxG.save.data.missSounds = true;

		if (FlxG.save.data.waving == null)
			FlxG.save.data.waving = true;

		if (FlxG.save.data.shaders == null)
			FlxG.save.data.shaders = true;

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.newInput != null && FlxG.save.data.lastversion == null)
			FlxG.save.data.lastversion = "pre-beta2";
		
		if (FlxG.save.data.newInput == null && FlxG.save.data.lastversion == null)
			FlxG.save.data.lastversion = "beta2";
		
		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = true;
		
		if (FlxG.save.data.noteCamera == null)
			FlxG.save.data.noteCamera = true;
		
		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.selfAwareness == null)
			FlxG.save.data.selfAwareness = true;
		
		if (FlxG.save.data.wasInCharSelect == null)
			FlxG.save.data.wasInCharSelect = false;

		if (FlxG.save.data.charactersUnlocked == null)
			FlxG.save.data.charactersUnlocked = ['bf', 'bf-pixel'];

		if (FlxG.save.data.disableFps == null)
			FlxG.save.data.disableFps = false;

		if (FlxG.save.data.optimize == null)
			FlxG.save.data.optimize = false;

		if (FlxG.save.data.gpuRender == null)
		{
			#if html5
			FlxG.save.data.gpuRender = false;
			#else
			FlxG.save.data.gpuRender = true;
			#end
		}
		
		if (FlxG.save.data.masterWeekUnlocked == null)
			FlxG.save.data.masterWeekUnlocked = false;

		if (FlxG.save.data.enteredTerminalCheatingState == null)
			FlxG.save.data.enteredTerminalCheatingState = false;
			
		if (FlxG.save.data.hasSeenCreditsMenu == null)
			FlxG.save.data.hasSeenCreditsMenu = false;
		
		if (FlxG.save.data.songBarOption == null)
			FlxG.save.data.songBarOption = 'ShowTime';

		if (FlxG.save.data.ColorBlindType == null)
			FlxG.save.data.ColorBlindType = 'None';

		if (FlxG.save.data.iconBounceType == null)
			FlxG.save.data.iconBounceType = 'Dave and Bambi Plus';

		if (FlxG.save.data.doubleGhost == null)
			FlxG.save.data.doubleGhost = true;

		if (FlxG.save.data.ColorBlindTypeNum == null)
			FlxG.save.data.ColorBlindTypeNum = false;

		if (FlxG.save.data.lowQuality == null)
			FlxG.save.data.lowQuality = 0;

		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		if (FlxG.save.data.hitSound == null)
			FlxG.save.data.hitSound = 0;

		if (FlxG.save.data.shitMs == null)
			FlxG.save.data.shitMs = 160.0;

		if (FlxG.save.data.badMs == null)
			FlxG.save.data.badMs = 135.0;

		if (FlxG.save.data.goodMs == null)
			FlxG.save.data.goodMs = 90.0;

		if (FlxG.save.data.sickMs == null)
			FlxG.save.data.sickMs = 45.0;

		(cast(Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
    }

	public static function resetModifiers():Void
		{
			FlxG.save.data.hgain = 1;
			FlxG.save.data.hloss = 1;
			FlxG.save.data.hdrain = false;
			FlxG.save.data.sustains = true;
			FlxG.save.data.noMisses = false;
			FlxG.save.data.modcharts = true;
			FlxG.save.data.practice = false;
			FlxG.save.data.opponent = false;
			FlxG.save.data.mirror = false;
		}
}