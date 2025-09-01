module game;

enum EnemyId {
    ENEMY_A_RED,
}

fn Entity* EntityManager.makeEnemy(EntityManager* self, EnemyId enemy_id, float x, float y, GameAssets* assets) {
    Entity* e = self.newEntity();
    e.position.x = x;
    e.position.y = y;
    e.anim.max_h_frames = 2;
    e.anim.max_v_frames = 1;
    e.anim.current_v_frame = 0;
    e.anim.current_h_frame = 0;
    e.anim.delay = SHIP_ANIM_SPEED;
    e.anim.timer = 0f;

    e.sprite.rotation = 0;
    e.sprite.origin = {
        .x = 0f,
        .y = 0f,
    };

    e.sprite.flip_v = true;

    if(enemy_id == EnemyId.ENEMY_A_RED) {
        e.sprite.art = ArtAsset.ENEMY_SHIP_A_RED;
        
        e.move.speed = 30;
        e.anim.frame_width = assets.getTexture(e.sprite.art).width / 2;
        e.anim.frame_height = assets.getTexture(e.sprite.art).height; 
    }

    e.addFlag(EntityFlag.HAS_SPRITE);
    e.addFlag(EntityFlag.IS_SHIP);
    e.addFlag(EntityFlag.IS_SHIP_ENEMY);
    e.addFlag(EntityFlag.IS_ANIMATED);
    e.addFlag(EntityFlag.IS_ENEMY_SPAWNER);

    return e;
}