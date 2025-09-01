module game;

import std::io;
import std::collections::list;
import raylib5::rl;

fn void updateMovement(Entity* entity, List{GameEventConfig}* event_pump, float delta) {
    foreach(index_flag_a, flag_a : entity.getFlags()) {
        //Is laser?
        if(flag_a == EntityFlag.IS_PLAYER_LASER) {
            entity.position.y -= PLAYER_LASER_SPEED * delta;
            if((entity.position.y + LASER_HEIGHT) < 0) {
                entity.alive = false;
            }
        }
        //Is stardust?
        else if(flag_a == EntityFlag.IS_STARDUST) {
            entity.position.y += entity.move.speed * delta;
            if(entity.position.y > WINDOW_HEIGHT) {
                entity.position.y = 0;
            }
        }
    }
}