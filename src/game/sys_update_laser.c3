module game;

import std::io;
import std::collections::list;
import raylib5::rl;

fn void updateLaser(Entity* entity, List{GameEventConfig}* event_pump, float delta) {
    foreach(index_flag_a, flag_a : entity.getFlags()) {
        //Is laser?
        if(flag_a == EntityFlag.IS_PLAYER_LASER) {
            entity.position.y -= 600 * delta;
            if((entity.position.y + LASER_HEIGHT) < 0) {
                entity.alive = false;
            }
        }
    }
}