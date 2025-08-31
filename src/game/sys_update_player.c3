module game;

import std::io;
import std::collections::list;
import raylib5::rl;

fn void updatePlayer(GameState* state, List{GameEventConfig}* event_pump, float delta) {
    foreach(index, entity : state.entity_manager.entities) {
        foreach(index_flag_a, flag_a : entity.flags) {	
            //Is player?
			if(flag_a == EntityFlag.IS_PLAYER) {
				//If laser fire is cooling down
				if(entity.fire_timeout) {
					entity.fire_timer += delta;
					if(entity.fire_timer >= PLAYER_FIRE_DELAY) {
						entity.fire_timer = 0f;
						entity.fire_timeout = false;
					}
				}

				//Move left
				if(rl::isKeyDown(rl::KEY_A)) {
					entity.x -= PLAYER_SHIP_SPEED * delta;
				}
				//Move Right
				if(rl::isKeyDown(rl::KEY_D)) {
					entity.x += PLAYER_SHIP_SPEED * delta;
				}
				//Clamp Right
				if((entity.x + SHIP_WIDTH) > WINDOW_WIDTH) {
					entity.x = WINDOW_WIDTH - SHIP_WIDTH;
				}
				//Clamp left
				else if(entity.x < 0) {
					entity.x = 0;
				}

				//Fire?
				if(rl::isKeyDown(rl::KEY_SPACE) && !entity.fire_timeout) {
					state.entity_manager.newPlayerLaser(entity);
					entity.fire_timeout = true;
				}
			}
        }
    }
}