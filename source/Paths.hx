package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import flixel.graphics.FlxGraphic;
import openfl.system.System;
import openfl.media.Sound;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
#if not web
import sys.FileSystem;
import sys.io.File;
#end
#if sys import sys.FileSystem; #end

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function isLocale():Bool
	{
		if (LanguageManager.save.data.language != 'en-US')
		{
			return true;
		}
		return false;
	}

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	// stolen from forever lmao -mcagabe19 on LE github
	#if not web
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedTextures:Map<String, Texture> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];

        public static function excludeAsset(key:String)
	{
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

        public static var dumpExclusions:Array<String> = [
                'assets/preload/music/freakyNightMenu.$SOUND_EXT',
		'assets/preload/music/freakyMenu.$SOUND_EXT',
                'assets/preload/music/optionsMenu.$SOUND_EXT',
		'assets/shared/music/breakfast.$SOUND_EXT',
	];

	public static function clearUnusedMemory()
	{
		var counter:Int = 0;
		for (key in currentTrackedAssets.keys())
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key))
			{
				var obj = currentTrackedAssets.get(key);
				if (obj != null)
				{
					var isTexture:Bool = currentTrackedTextures.exists(key);
					if (isTexture)
					{
						var texture = currentTrackedTextures.get(key);
						texture.dispose();
						texture = null;
						currentTrackedTextures.remove(key);
					}
					@:privateAccess
					if (openfl.Assets.cache.hasBitmapData(key))
					{
						openfl.Assets.cache.removeBitmapData(key);
						FlxG.bitmap._cache.remove(key);
					}
					trace('removed $key, ' + (isTexture ? 'is a texture' : 'is not a texture'));
					obj.destroy();
					currentTrackedAssets.remove(key);
					counter++;
				}
			}
		}
		trace('removed $counter assets');
		System.gc();
	}

	public static var localTrackedAssets:Array<String> = [];

	public static function clearStoredMemory(?cleanUnused:Bool = false)
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key))
			{
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		for (key in currentTrackedSounds.keys())
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null)
			{
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		localTrackedAssets = [];
	}

	public static function returnGraphic(key:String, ?library:String, ?textureCompression:Bool = false)
	{
		var path = getPath('images/$key.png', IMAGE, library); 
                if (FileSystem.exists(path))
		{
			if (!currentTrackedAssets.exists(key))
			{
				var bitmap = BitmapData.fromFile(path);
				var newGraphic:FlxGraphic;
				if (textureCompression)
				{
					var texture = FlxG.stage.context3D.createTexture(bitmap.width, bitmap.height, BGRA, true, 0);
					texture.uploadFromBitmapData(bitmap);
					currentTrackedTextures.set(key, texture);
					bitmap.dispose();
					bitmap.disposeImage();
					bitmap = null;
					trace('new texture $key, bitmap is $bitmap');
					newGraphic = FlxGraphic.fromBitmapData(BitmapData.fromTexture(texture), false, key, false);
				}
				else
				{
					newGraphic = FlxGraphic.fromBitmapData(bitmap, false, key, false);
					trace('new bitmap $key, not textured');
				}
				currentTrackedAssets.set(key, newGraphic);
			}
			localTrackedAssets.push(key);
			return currentTrackedAssets.get(key);
		}
		trace('oh no ' + key + ' is returning null NOOOO');
		return null;
	}
	#end
    // end stole code

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}
	inline static public function getDirectory(directoryName:String, ?library:String)
	{
		return getPath('images/$directoryName', IMAGE, library);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}
 
	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		var defaultReturnPath = getPath(file, type, library);
		if (isLocale())
		{
			var langaugeReturnPath = getPath('locale/${LanguageManager.save.data.language}/' + file, type, library);
			if (FileSystem.exists(langaugeReturnPath))
			{
				return langaugeReturnPath;
			}
			else
			{
				return defaultReturnPath;
			}
		}
		else
		{
			return defaultReturnPath;
		}
	}

	inline static public function txt(key:String, ?library:String)
	{
		var defaultReturnPath = getPath('data/$key.txt', TEXT, library);
		if (isLocale())
		{
			var langaugeReturnPath = getPath('locale/${LanguageManager.save.data.language}/data/$key.txt', TEXT, library);
			if (FileSystem.exists(langaugeReturnPath))
			{
				return langaugeReturnPath;
			}
			else
			{
				return defaultReturnPath;
			}
		}
		else
		{
			return defaultReturnPath;
		}
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function data(key:String, ?library:String)
	{
		return getPath('data/$key', TEXT, library);
	}
	
	inline static public function executable(key:String, ?library:String)
	{
		return getPath('executables/$key', BINARY, library);
	}

	inline static public function chart(key:String, ?library:String)
	{
		return getPath('data/charts/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String, addon:String = "")
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices${addon}.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function externmusic(song:String)
	{
		return 'songs:assets/songs/extern/${song.toLowerCase()}.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		var defaultReturnPath = getPath('images/$key.png', IMAGE, library);
		if (isLocale())
		{
			var langaugeReturnPath = getPath('locale/${LanguageManager.save.data.language}/images/$key.png', IMAGE, library);
			if (FileSystem.exists(langaugeReturnPath))
			{
				return langaugeReturnPath;
			}
			else
			{
				return defaultReturnPath;
			}
		}
		else
		{
			return defaultReturnPath;
		}
	}

	/*
		WARNING!!
		DO NOT USE splashImage, splashFile or getSplashSparrowAtlas for searching stuff in paths!!!!!
		I'm only using these for FlxSplash since the languages haven't loaded yet!
	*/

	inline static public function splashImage(key:String, ?library:String, ?ext:String = 'png')
	{
		var defaultReturnPath = getPath('images/$key.$ext', IMAGE, library);
		return defaultReturnPath;
	}

	inline static public function splashFile(file:String, type:AssetType = TEXT, ?library:String)
	{
		var defaultReturnPath = getPath(file, type, library);
		return defaultReturnPath;
	}

	inline static public function getSplashSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(splashImage(key, library), splashFile('images/$key.xml', library));
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}
	static public function langaugeFile():String
	{
		return getPath('locale/languages.txt', TEXT, 'preload');
	}
	static public function offsetFile(character:String):String
	{
		return getPath('offsets/' + character + '.txt', TEXT, 'preload');
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	inline static public function video(key:String, ?library:String)
	{
		return getPath('videos/$key.mp4', BINARY, library);
	}

}