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
				rl::Texture2D tex = assets.getTexture(entity.art);
				foreach(flag_b_index, flag_b : flags) {
					if(flag_b == EntityFlag.IS_ANIMATED) {
						rl::Rectangle src = {
							.x = (float)entity.current_h_frame * SHIP_WIDTH,
							.y = (float)entity.current_v_frame * SHIP_HEIGHT,
							.width = SHIP_WIDTH,
							.height = SHIP_HEIGHT,
						};
						rl::Vector2 pos = {
							.x = entity.x,
							.y = entity.y,
						};
						rl::drawTextureRec(tex, src, pos, rl::WHITE);
					}
					else if(flag_b == EntityFlag.IS_NOT_ANIMATED) {
						rl::drawTexture(tex, (int)entity.x, (int)entity.y, rl::WHITE);
					}
				}
			}
			//Render gui text
			else if(flag_a == EntityFlag.HAS_GUI_TEXT) {
				rl::Font font = assets.main_font;
				ZString text = (ZString)entity.gui_text;
				rl::drawTextEx(font, text, (Vector2){ entity.x, entity.y }, (float)entity.gui_text_size, 2, rl::WHITE);
			}
		}
	}

	rl::endDrawing();
}