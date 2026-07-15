{...}: {
  programs.beets = {
    enable = true;
    settings = {
      directory = "/srv/media/media-lib/music";
      import = {
        move = false;
        copy = false;
        write = true;
        autotag = true;
      };
      plugins = "musicbrainz lyrics";
      musicbrainz = {
        extra_tags = ["alias" "barcode" "catalognum" "country" "label" "media" "tracks" "year"];
      };
      lyrics = {
        auto = true;
        synced = true;
        keep_synced = true;
        sources = ["lrclib" "google" "genius"];
      };
    };
  };
}
