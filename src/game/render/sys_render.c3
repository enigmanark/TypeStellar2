module game;

import std::io;
import std::collections::list;
import raylib5::rl;

fn void sysRender(GameState* state, GameAssets* assets) {
	rl::beginDrawing();

	rl::clearBackground(rl::BLACK);

	foreach(index, entity : state.entity_manager.entities) {
		List{EntityFlag} flags = entity.getFlags();
		foreach(flag_a_index, flag_a : flags) {
			//Render sprites
			if(flag_a == EntityFlag.HAS_SPRITE) {
				rl::Texture2D tex = assets.getTexture(entity.sprite.art);
				foreach(flag_b_index, flag_b : flags) {
					if(flag_b == EntityFlag.IS_ANIMATED) {
						rl::Rectangle src;
						rl::Rectangle dest = {
							.x = entity.position.x,
							.y = entity.position.y,
							.width = entity.anim.frame_width,
							.height = entity.anim.frame_height,
						};

						if(entity.sprite.flip_v) {
							src = {
								.x = (float)entity.anim.current_h_frame * entity.anim.frame_width,
								.y = (float)entity.anim.current_v_frame * entity.anim.frame_height,
								.width = entity.anim.frame_width,
								.height = (float)-entity.anim.frame_height,
							};
						}
						else {
							src = {
								.x = (float)entity.anim.current_h_frame * entity.anim.frame_width,
								.y = (float)entity.anim.current_v_frame * entity.anim.frame_height,
								.width = entity.anim.frame_width,
								.height = entity.anim.frame_height,
							};							
						}
						rl::drawTexturePro(tex, src, dest, entity.sprite.origin, entity.sprite.rotation, rl::WHITE);
					}
					else if(flag_b == EntityFlag.IS_NOT_ANIMATED) {
						Vector2 pos = {
							.x = entity.position.x,
							.y = entity.position.y,
						};
						rl::drawTextureEx(tex, pos, entity.sprite.rotation, 1f, rl::WHITE);
					}
				}
			}
			//Render gui text
			else if(flag_a == EntityFlag.HAS_GUI_TEXT) {
				rl::Font font = assets.main_font;
				ZString text = (ZString)entity.gui_text.text;
				rl::drawTextEx(
					font, 
					text, 
					(Vector2){ entity.position.x, entity.position.y }, 
					(float)entity.gui_text.size, 
					2, 
					rl::WHITE
				);
			}
		}
	}

	rl::endDrawing();
}