module game;

import std::io;
import std::collections::list;
import raylib5::rl;

fn void updatePlayer(GameState* state, List{GameEventConfig}* event_pump, float delta) {
    foreach(index, entity : state.entity_manager.entities) {
        foreach(index_flag_a, flag_a : entity.flags) {	
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
					state.entity_manager.newPlayerLaser(entity);
				}
			}
        }
    }
}