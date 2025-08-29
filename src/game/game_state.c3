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

fn GameState* initPlayState() {
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

fn GameState* initTitleState() {
	io::printfn("INFO: Initializing Title State...");
	GameState* state = mem::new(GameState);

	state.entity_manager = initEntityManager();

	Entity* title = state.entity_manager.newEntity();
	title.art = ArtAsset.NONE;
	title.x = 0;
	title.y = 0;
	title.gui_text = WINDOW_TITLE;
	title.gui_text_size = 70;
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
	self.update(event_pump, delta);
	self.render(assets);
}

fn void GameState.update(GameState* self, List{GameEventConfig}* event_pump, float delta) {
	//Process entities and update them
	foreach(index, entity : self.entity_manager.entities) {
		List{EntityFlag} flags = entity.getFlags();
		foreach(flag_a_index, flag_a : flags) {
			//Has event key emitter?
			if(flag_a == EntityFlag.HAS_EVENT_KEY_EMITTER) {
				//Key pressed?
				if(rl::isKeyPressed(entity.emitter_key)) {
					event_pump.push(entity.emitter_config);
				}
			}
			//Is player?
			if(flag_a == EntityFlag.IS_PLAYER) {
				//Move left
				if(rl::isKeyDown(rl::KEY_A)) {
					entity.x -= PLAYER_SHIP_SPEED * delta;
				}
				//Move Right
				if(rl::isKeyDown(rl::KEY_D)) {
					entity.x += PLAYER_SHIP_SPEED * delta;
				}
				//Clamp Right
				if((entity.x + SHIP_SIZE) > WINDOW_WIDTH) {
					entity.x = WINDOW_WIDTH - SHIP_SIZE;
				}
				//Clamp left
				else if(entity.x < 0) {
					entity.x = 0;
				}

				//Fire?
				if(rl::isKeyDown(rl::KEY_SPACE)) {
					self.entity_manager.newPlayerLaser(entity);
				}
			}
			//Is laser?
			else if(flag_a == EntityFlag.IS_PLAYER_LASER) {
				entity.y -= 600 * delta;
				if((entity.y + LASER_HEIGHT) < 0) {
					entity.alive = false;
				}
			}
		}
	}
	//Find entities that are marked as alive and keep them, let the rest be deleted
	List{Entity*} new_entity_list;
	new_entity_list.init(mem); 
	foreach(index, entity : self.entity_manager.entities) {
		if(entity.alive) {
			new_entity_list.push(entity);
		}
		else {
			entity.unload();
		}
	}
	self.entity_manager.entities.free();
	self.entity_manager.entities = new_entity_list;
}

fn void GameState.render(GameState* self, GameAssets* assets) {
	rl::beginDrawing();

	rl::clearBackground(rl::BLACK);

	foreach(index, entity : self.entity_manager.entities) {
		List{EntityFlag} flags = entity.getFlags();
		foreach(flag_a_index, flag_a : flags) {
			//Render sprites
			if(flag_a == EntityFlag.HAS_SPRITE) {
				rl::Texture2D tex = assets.getTexture(entity.art);
				rl::drawTexture(tex, (int)entity.x, (int)entity.y, rl::WHITE);
			}
			//Render gui text
			else if(flag_a == EntityFlag.HAS_GUI_TEXT) {
				rl::Font font = assets.main_font;
				ZString text = (ZString)entity.gui_text;
				rl::drawTextEx(font, text, (Vector2){ entity.x, entity.y }, (float)entity.gui_text_size, 2, rl::WHITE);
			}
		}
	}

	rl::endDrawing();
}