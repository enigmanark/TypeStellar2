module game;

import std::io;

fn void updateSpawner(GameState* state, Entity* entity, GameAssets* assets, float delta) {
    foreach(index_flag, flag_a : entity.getFlags()) {
        if(flag_a == EntityFlag.IS_ENEMY_SPAWNER && entity.enemy_spawner.active) {
            entity.enemy_spawner.timer += delta;
            if(entity.enemy_spawner.timer >= entity.enemy_spawner.delay) {
                entity.enemy_spawner.timer = 0f;
                state.entity_manager.makeEnemy(EnemyId.ENEMY_A_RED, 0, 0, assets);
            }
        }
    }
}