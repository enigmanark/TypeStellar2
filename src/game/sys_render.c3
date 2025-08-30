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
				rl::drawTexture(tex, (int)entity.x, (int)entity.y, rl::WHITE);
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