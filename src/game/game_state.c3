module game;

import std::io;
import std::collections::list;
import raylib5::rl;

enum EngineStateId {
	TITLE,
	GAME_LEVEL,
	GAMEOVER,
}

struct GameState {
	EngineStateId state_id;
	EntityManager* entity_manager;
}

fn GameState* initGameLevelState(GameAssets* assets) {
	io::printfn("INFO: Initializing Game Level State...");
	GameState* state = mem::new(GameState);

	state.state_id = EngineStateId.GAME_LEVEL;
	state.entity_manager = initEntityManager();
	
	Entity* bg = state.entity_manager.newEntity();
	bg.art = ArtAsset.BG_A;
	bg.position.x = 0;
	bg.position.y = 0;
	bg.addFlag(EntityFlag.HAS_SPRITE);
	bg.addFlag(EntityFlag.IS_NOT_ANIMATED);

	state.entity_manager.newPlayer();

	io::printfn("INFO: Game Level State initialized.");

	return state;
}

fn GameState* initTitleState(GameAssets* assets) {
	io::printfn("INFO: Initializing Title State...");
	GameState* state = mem::new(GameState);

	state.state_id = EngineStateId.TITLE;
	state.entity_manager = initEntityManager();

	Entity* title = state.entity_manager.newEntity();
	title.art = ArtAsset.NONE;
	title.gui_text.text = WINDOW_TITLE;
	title.gui_text.size = 70;

	rl::Vector2 title_size = rl::measureTextEx(assets.main_font, (ZString)title.gui_text.text, title.gui_text.size, 2);
	title.position.x = (WINDOW_WIDTH / 2) - (title_size.x / 2);
	title.position.y = WINDOW_HEIGHT / 2 - 100;
	
	title.addFlag(EntityFlag.HAS_GUI_TEXT);

	io::printfn("INFO: Title State initialized.");
	return state;
}

fn void GameState.unload(GameState* self) {
	io::printfn("INFO: Unloading game state...");
	self.entity_manager.unload();
	free(self);
	io::printfn("INFO: Unloaded game state.");
}

fn void GameState.run(GameState* self, List{GameEventConfig}* event_pump, GameAssets* assets) {
	float delta = rl::getFrameTime();
	sysUpdate(self, event_pump, delta);
	sysUpdateGUI(self, event_pump, delta);
	sysRender(self, assets);
}