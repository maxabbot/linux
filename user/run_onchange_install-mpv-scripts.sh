#!/bin/bash
# Download mpv scripts: uosc (UI), thumbfast (thumbnail scrubber), sponsorblock.
# chezmoi re-runs this when the file content changes — bump the hash to update.
# hash: 1

set -euo pipefail

SCRIPTS_DIR="$HOME/.config/mpv/scripts"
OPTS_DIR="$HOME/.config/mpv/script-opts"
mkdir -p "$SCRIPTS_DIR" "$OPTS_DIR"

echo "Installing uosc..."
curl -fsSL "https://github.com/tomasklaen/uosc/releases/latest/download/uosc.tar.gz" \
  | tar -xzf - -C "$HOME/.config/mpv/" --overwrite

echo "Installing thumbfast..."
curl -fsSL "https://raw.githubusercontent.com/po5/thumbfast/master/thumbfast.lua" \
  -o "$SCRIPTS_DIR/thumbfast.lua"

echo "Installing sponsorblock..."
curl -fsSL "https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock.lua" \
  -o "$SCRIPTS_DIR/sponsorblock.lua"
curl -fsSL "https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared.lua" \
  -o "$SCRIPTS_DIR/sponsorblock_shared.lua"

# Write uosc config (overrides the default from the tarball)
cat > "$OPTS_DIR/uosc.conf" << 'EOF'
# uosc — Gruvbox Material Dark

# Layout
timeline_style=bar
timeline_line_width=2
timeline_size=24
controls=menu,gap,subtitles,<has_many_audio_tracks>audio,<has_many_video_tracks>video,<has_chapter_list>chapters,<stream>stream-quality,gap,space,speed,space,shuffle,loop-playlist,loop-file,gap,prev,items,next,gap,fullscreen
controls_size=32
controls_margin=8
controls_spacing=2
controls_persistency=

# Autohide
autohide=no
flash_duration=1000
proximity_in=40
proximity_out=60

# Appearance
font=FiraCode Nerd Font
font_scale=1
text_border=1.2
border_radius=4

# Colors — Gruvbox Material Dark (0xAARRGGBB)
color_foreground=d4be98
color_foreground_text=282828
color_background=282828
color_background_text=d4be98
color_primary=7daea3
color_error=ea6962

# Thumbnails (thumbfast integration)
thumbnail=yes
thumbnail_max_height=200
EOF

echo "mpv scripts installed."
