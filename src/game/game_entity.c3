module game;

import std::collections::list;
import std::io;
import raylib5::rl;

struct EntityManager {
	long next_id;
	List{Entity*} entities;
}

fn EntityManager* initEntityManager() {
	EntityManager* manager = mem::new(EntityManager);
	manager.entities.init(mem);
	return manager;
}

fn Entity* EntityManager.newEntity(EntityManager* self) {
	Entity* ent = mem::new(Entity);
	ent.id = self.next_id;
	ent.art = ArtAsset.NONE;
	ent.alive = true;
	ent.flags.init(mem);
	ent.x = 0;
	ent.y = 0;
	ent.max_h_frames = 0;
	ent.max_v_frames = 0;
	ent.current_h_frame = 0;
	ent.current_v_frame = 0;
	ent.anim_delay = 0;
	ent.anim_timer = 0f;
	ent.fire_timer = 0f;
	ent.fire_timeout = false;

	self.next_id++;

	self.entities.push(ent);

	return ent;
}

fn Entity* EntityManager.newPlayer(EntityManager* self) {
	Entity* player = self.newEntity();
	player.art = ArtAsset.PLAYER_SHIP_A;
	player.x = (WINDOW_WIDTH / 2) - (SHIP_WIDTH / 2);
	player.y = WINDOW_HEIGHT - (SHIP_HEIGHT + 20);
	player.max_h_frames = 2;
	player.max_v_frames = 1;
	player.current_h_frame = 0;
	player.current_v_frame = 0;
	player.anim_delay = SHIP_ANIM_SPEED;
	player.anim_timer = 0f;

	player.addFlag(EntityFlag.IS_SHIP);
	player.addFlag(EntityFlag.IS_ANIMATED);
	player.addFlag(EntityFlag.HAS_SPRITE);
	player.addFlag(EntityFlag.IS_PLAYER);

	return player;
}

fn Entity* EntityManager.newPlayerLaser(EntityManager* self, Entity* player_ent) {
	Entity* laser = self.newEntity();
	laser.art = ArtAsset.LASER_RED;
	laser.x = player_ent.x + (SHIP_WIDTH / 2) - (LASER_WIDTH / 2);
	laser.y = player_ent.y;
	
	laser.addFlag(EntityFlag.IS_LASER);
	laser.addFlag(EntityFlag.IS_PLAYER_LASER);
	laser.addFlag(EntityFlag.HAS_SPRITE);
	laser.addFlag(EntityFlag.IS_NOT_ANIMATED);
	return laser;
}

fn void EntityManager.unload(EntityManager* self) {
	io::printfn("INFO: Unloading entities...");
	foreach(index, entity : self.entities) {
		entity.unload();
	}
	self.entities.free();
	free(self);
	io::printfn("INFO: Entities unloaded.");
}

enum EntityFlag {
	IS_PLAYER,
	IS_SHIP,
	IS_PLAYER_LASER,
	IS_LASER,
	IS_ANIMATED,
	IS_NOT_ANIMATED,
	HAS_SPRITE,
	HAS_EVENT_KEY_EMITTER,
	HAS_GUI_TEXT,
}

struct Entity {
	long id;
	bool alive;
	ArtAsset art;
	List{EntityFlag} flags;
	float x;
	float y;
	float speed;
	GameEventConfig emitter_config;
	rl::KeyboardKey emitter_key;
	String gui_text;
	int gui_text_size;
	int max_h_frames;
	int max_v_frames;
	int current_h_frame;
	int current_v_frame;
	float anim_delay;
	float anim_timer;
	bool fire_timeout;
	float fire_timer;
}

fn void Entity.unload(Entity* self) {
	self.flags.free();
	free(self);
}

fn void Entity.addFlag(Entity* self, EntityFlag flag) {
	self.flags.push(flag);
}

fn List{EntityFlag} Entity.getFlags(Entity* self) {
	return self.flags;
}