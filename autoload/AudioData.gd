extends Node


enum MusicKeys {
	MainMenu,
	LevelNoPing,
	LevelAllowPing,
	LastLevel
}

enum SFXKeys {
	PlayerPing,
	PlayerGrappleHit,
	PlayerGrappleRelease,
	PlayerSlideBegin,
	PlayerJump,
	PlayerRewind,
	PlayerDeath,
	PlayerSurfaceHit,
	ArenaVictory,
	ButtonHover,
	ButtonClick,
	MainMenuLoad,
	ArenaLoad
}


const MUSIC_PATHS = {
	MusicKeys.MainMenu : "res://assets/audio/music/634790__timouse__220521-standchen.wav",
	MusicKeys.LevelNoPing : "res://assets/audio/music/178579__setuniman__gramophone.mp3",
	MusicKeys.LevelAllowPing : "res://assets/audio/music/535048__patchytherat__ambient-noise.wav",
	MusicKeys.LastLevel : "res://assets/audio/music/424928__camel7695__sweet-adeline-but-its-a-distant-opera.wav"
}


const SFX_PATHS = {
	SFXKeys.PlayerPing : "res://assets/audio/sfx/256799__deleted-user-4772965__match-ignition-8.wav",
	SFXKeys.PlayerGrappleHit : "res://assets/audio/sfx/323751__reitanna__plastic12.wav",
	SFXKeys.PlayerGrappleRelease : "res://assets/audio/sfx/592005__ueffects__climbing-express-gear.wav",
	SFXKeys.PlayerSlideBegin : "res://assets/audio/sfx/546118__el-boss__piece-slide.mp3",
	SFXKeys.PlayerJump : "res://assets/audio/sfx/607651__jayroo9__pots-and-cans-17.wav",
	SFXKeys.PlayerRewind : "res://assets/audio/sfx/264934__sassaby__vhs-startup.wav",
	SFXKeys.PlayerDeath : "res://assets/audio/sfx/500912__bertsz__squish-impact.wav",
	SFXKeys.PlayerSurfaceHit : "res://assets/audio/sfx/323763__reitanna__plastic8.wav",
	SFXKeys.ArenaVictory : "res://assets/audio/sfx/244325__philip-daniels__knock-on-door.wav",
	SFXKeys.ButtonHover : "res://assets/audio/sfx/233343__otisjames__squitch.wav",
	SFXKeys.ButtonClick : "res://assets/audio/sfx/14108__adcbicycle__21.wav",
	SFXKeys.MainMenuLoad : "res://assets/audio/sfx/625149__sysdub__vcr-02.wav",
	SFXKeys.ArenaLoad : "res://assets/audio/sfx/316556__debsound__analog-tape-noise-10.wav"
}


var db_level = 14

var last_track = MusicKeys.MainMenu
var last_playback_position = 0.0


func play_button_hover(audio_player : AudioStreamPlayer):
	audio_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.ButtonHover))
	audio_player.volume_db = AudioData.db_level
	audio_player.play(0.0)

func play_button_click(audio_player : AudioStreamPlayer):
	audio_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.ButtonClick))
	audio_player.volume_db = AudioData.db_level
	audio_player.play(0.0)
