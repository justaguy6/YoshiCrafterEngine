package;

import flixel.util.FlxColor;
using StringTools;

import flixel.FlxG;

typedef SaveDataRating = {
	var name:String;
	var accuracyVal:Float;
	var color:FlxColor;
	var amount:Int;
}
typedef AdvancedSaveData = {
	var accuracy:Float;
	var rating:String; // CUSTOM RATINGS !!!???!!!!!???!!?!!
	var averageDelay:Float;
	var misses:Int;
	var hits:Array<SaveDataRating>;
}
class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end

	public static function saveAdvancedScore(mod:String, song:String, data:AdvancedSaveData, ?diff:String = "Normal") {
		var daSong:String = formatSong('$mod:$song', diff);
		diff = diff.toLowerCase();

		if (Reflect.hasField(FlxG.save.data, 'advanced/$daSong'))
		{
			var score:AdvancedSaveData = Reflect.field(FlxG.save.data, 'advanced/$daSong');
			if (score.accuracy < data.accuracy) {
				Reflect.setField(FlxG.save.data, 'advanced/$daSong', data);
			}
		}
		else
			Reflect.setField(FlxG.save.data, 'advanced/$daSong', data);
	}

	public static function saveScore(mod:String, song:String, score:Int = 0, ?diff:String = "Normal"):Void
	{
		var daSong:String = formatSong('$mod:$song', diff);


		#if !switch
		// // NGio .postScore(score, song);
		#end


		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:String = "Normal"):Void
	{

		#if !switch
		// // NGio .postScore(score, "Week " + week);
		#end


		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	public static function saveModWeekScore(mod:String, week:String, score:Int = 0, ?diff:String = "Normal"):Void
	{

		#if !switch
		// // NGio .postScore(score, "Week " + week);
		#end


		var daWeek:String = formatSong('$mod:$week', diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:String):String
	{
		var daSong:String = song;

		if (diff.toLowerCase() != "normal") {
			daSong += "-" + diff.toLowerCase().replace(" ", "-");
		}

		return daSong;
	}

	public static function getScore(song:String, diff:String):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getWeekScore(week:Int, diff:String):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function getModWeekScore(mod:String, week:String, diff:String):Int
	{
		if (!songScores.exists(formatSong('$mod:$week', diff)))
			setScore(formatSong('$mod:$week', diff), 0);

		return songScores.get(formatSong('$mod:$week', diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
	}
}
