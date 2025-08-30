module game;

import std::io;
import std::collections::list;
import raylib5::rl;

enum EngineState {
	TITLE,
	PLAY,
	GAMEOVER,
}

struct GameState {
	EntityManager* entity_manager;
}

fn GameState* initPlayState(GameAssets* assets) {
	io::printfn("INFO: Initializing Play State...");
	GameState* state = mem::new(GameState);

	state.entity_manager = initEntityManager();
	
	Entity* bg = state.entity_manager.newEntity();
	bg.art = ArtAsset.BG_A;
	bg.x = 0;
	bg.y = 0;
	bg.addFlag(EntityFlag.HAS_SPRITE);

	Entity* player = state.entity_manager.newEntity();
	player.art = ArtAsset.SHIP_BLUE;
	player.x = (WINDOW_WIDTH / 2) - (SHIP_SIZE / 2);
	player.y = WINDOW_HEIGHT - (SHIP_SIZE + 20);
	player.addFlag(EntityFlag.HAS_SPRITE);
	player.addFlag(EntityFlag.IS_PLAYER);

	io::printfn("INFO: Play State initialized.");

	return state;
}

fn GameState* initTitleState(GameAssets* assets) {
	io::printfn("INFO: Initializing Title State...");
	GameState* state = mem::new(GameState);

	state.entity_manager = initEntityManager();

	Entity* title = state.entity_manager.newEntity();
	title.art = ArtAsset.NONE;
	title.gui_text = WINDOW_TITLE;
	title.gui_text_size = 70;

	rl::Vector2 title_size = rl::measureTextEx(assets.main_font, (ZString)title.gui_text, title.gui_text_size, 2);
	title.x = (WINDOW_WIDTH / 2) - (title_size.x / 2);
	title.y = WINDOW_HEIGHT / 2 - 100;
	
	
	title.emitter_config = newEventConfig(GameEvent.CHANGE_STATE, EngineState.PLAY);
	title.emitter_key = rl::KEY_SPACE;
	title.addFlag(EntityFlag.HAS_GUI_TEXT);
	title.addFlag(EntityFlag.HAS_EVENT_KEY_EMITTER);

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
	sysRender(self, assets);
}