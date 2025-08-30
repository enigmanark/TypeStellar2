module game;

import std::io;
import std::collections::list;
import raylib5::rl;

fn void updateAnimation(Entity* entity, List{GameEventConfig}* event_pump, float delta) {
    List{EntityFlag} flags = entity.getFlags();
    foreach(index_flag_a, flag_a : flags) {
        //Is Animated?
        if(flag_a == EntityFlag.IS_ANIMATED) {
            foreach(index_flag_b, flag_b : flags) {
                if(flag_b == EntityFlag.IS_SHIP) {
                    entity.anim_timer += delta;
                    if(entity.anim_timer >= entity.anim_delay) {
                        entity.anim_timer = 0f;
                        entity.current_h_frame++;
                        if(entity.current_h_frame >= entity.max_h_frames) {
                            entity.current_h_frame = 0;
                        }
                    }
                }
            }
        }
    }
}