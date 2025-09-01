module game;

import raylib5::rl;
import std::collections::enummap;
import std::io;

enum ArtAsset {
    NONE,
    PLAYER_SHIP_A,
    SHIP_BLUE,
    LASER_RED,
    BG_A,
    STARDUST,
}

struct GameAssets {
    EnumMap{ArtAsset, rl::Texture2D} textures;
    rl::Font main_font;
}

fn GameAssets gameAssetsInitAndLoad() {
    io::printfn("INFO: Loading game assets...");

    EnumMap{ArtAsset, rl::Texture2D} textures;
    textures[ArtAsset.BG_A] = rl::loadTexture("resources/img/bg_a.png");

    textures[ArtAsset.STARDUST] = rl::loadTexture("resources/img/stardust.png");

    textures[ArtAsset.SHIP_BLUE] = rl::loadTexture("resources/img/ship_blue_a.png");
    
    textures[ArtAsset.PLAYER_SHIP_A] = rl::loadTexture("resources/img/player_ship_a.png");

    textures[ArtAsset.LASER_RED] = rl::loadTexture("resources/img/laser_red.png");

    GameAssets assets = {
        .textures = textures,
        .main_font = rl::loadFont("resources/font/PressStart2P.ttf"),
    };

    io::printfn("INFO: Game assets loaded.");
    return assets;
}

fn rl::Texture2D GameAssets.getTexture(GameAssets* self, ArtAsset asset) {
    return self.textures[asset];
}

fn void GameAssets.unload(GameAssets* self) {
    io::printfn("INFO: Unloading game assets...");
    foreach(i, v : self.textures) {
        rl::unloadTexture(v);
    }
    io::printfn("INFO: Game assets unloaded.");
}