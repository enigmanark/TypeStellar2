module game;

import std::io;
import std::collections::list;
import raylib5::rl;

fn void updateEventEmitters(Entity* entity, List{GameEventConfig}* event_pump, float delta) {
    foreach(index_flag_a, flag_a : entity.getFlags()) {
        //Has event key emitter?
        if(flag_a == EntityFlag.HAS_EVENT_KEY_EMITTER) {
            //Key pressed?
            if(rl::isKeyPressed(entity.emitter_key)) {
                event_pump.push(entity.emitter_config);
            }
        }
    }
}