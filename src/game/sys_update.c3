module game;

import std::io;
import std::collections::list;
import raylib5::rl;

fn void sysUpdate(GameState* state, List{GameEventConfig}* event_pump, float delta) {
    //Process player and update
	updatePlayer(state, event_pump, delta);
    
	//Process entities and update them
	foreach(index, entity : state.entity_manager.entities) {
        updateMovement(entity, event_pump, delta);
		updateAnimation(entity, event_pump, delta);
	}

	//Find entities that are marked as alive and keep them, let the rest be deleted
	List{Entity*} new_entity_list;
	new_entity_list.init(mem); 
	foreach(index, entity : state.entity_manager.entities) {
		if(entity.alive) {
			new_entity_list.push(entity);
		}
		else {
			entity.unload();
		}
	}
	state.entity_manager.entities.free();
	state.entity_manager.entities = new_entity_list;
}