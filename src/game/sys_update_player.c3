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
				if(entity.weapon.timeout) {
					entity.weapon.timer += delta;
					if(entity.weapon.timer >= PLAYER_FIRE_DELAY) {
						entity.weapon.timer = 0f;
						entity.weapon.timeout = false;
					}
				}

				//Move left
				if(rl::isKeyDown(rl::KEY_A)) {
					entity.position.x -= PLAYER_SHIP_SPEED * delta;
				}
				//Move Right
				if(rl::isKeyDown(rl::KEY_D)) {
					entity.position.x += PLAYER_SHIP_SPEED * delta;
				}
				//Clamp Right
				if((entity.position.x + SHIP_WIDTH) > WINDOW_WIDTH) {
					entity.position.x = WINDOW_WIDTH - SHIP_WIDTH;
				}
				//Clamp left
				else if(entity.position.x < 0) {
					entity.position.x = 0;
				}

				//Fire?
				if(rl::isKeyDown(rl::KEY_SPACE) && !entity.weapon.timeout) {
					state.entity_manager.newPlayerLaser(entity);
					entity.weapon.timeout = true;
				}
			}
        }
    }
}