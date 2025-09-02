module game;

import raylib5::rl;
import raygui::rg;
import std::collections::list;

const int BUTTON_WIDTH = 220;
const int BUTTON_HEIGHT = 45;

fn void updateGUI(GameState* state, List{GameEventConfig}* event_pump, float delta) {
    if(state.state_id == EngineStateId.TITLE) {
        rl::Rectangle button_rect = {
            .x = (WINDOW_WIDTH / 2) - BUTTON_WIDTH / 2,
            .y = (WINDOW_HEIGHT / 2),
            .width = BUTTON_WIDTH,
            .height = BUTTON_HEIGHT,
        };
        // Set the default text size
        rg::guiSetStyle(rg::GuiControl.DEFAULT, rg::TEXT_SIZE, 40);
        if(rg::guiButton(button_rect, "Play")) {
            GameEventConfig to_station = newEventConfig(GameEvent.CHANGE_STATE, EngineStateId.STATION);
            event_pump.push(to_station);
        }
    }
    else if(state.state_id == EngineStateId.STATION) {
        rl::Rectangle button_rect = getButtonRect(10, 10, 200, 50);
        rg::guiSetStyle(rg::GuiControl.DEFAULT, rg::TEXT_SIZE, 25);
        if(rg::guiButton(button_rect, "Start Mission")) {
            GameEventConfig to_level = newEventConfig(GameEvent.CHANGE_STATE, EngineStateId.GAME_LEVEL);
            event_pump.push(to_level);
        }    
    }
}

fn rl::Rectangle getButtonRect(float x, float y, float width, float height) {
    rl::Rectangle rect = {
        .x = x,
        .y = y,
        .width = width,
        .height = height,
    };

    return rect;
}