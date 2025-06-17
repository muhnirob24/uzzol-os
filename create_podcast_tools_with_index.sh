#!/bin/bash

BASE_DIR="Podcast-Tools-For-Nirobtech"

declare -a projects=(
  "01-Podcast-SEO-Booster"
  "02-Sponsor-Matchmaker"
  "03-Episode-Transcript-Generator"
  "04-Podcast-Analytics-Dashboard"
  "05-Multi-Platform-Distribution-Manager"
  "06-Podcast-Website-Builder"
  "07-Ad-Sponsorship-Revenue-Tracker"
  "08-Listener-Engagement-Tool"
  "09-Audio-Quality-Enhancer"
  "10-Podcast-Growth-Automation"
)

declare -a descriptions=(
  "Podcast SEO Booster: Custom titles, descriptions, and keyword optimization"
  "Helps find sponsors for your podcast"
  "Quick transcript generation from audio episodes"
  "Analyze listener data and growth metrics"
  "Upload podcasts to multiple platforms from one place"
  "Build podcast websites without coding"
  "Track ad and sponsorship revenue"
  "Increase listener engagement and interaction"
  "Enhance audio quality automatically"
  "Growth hacking and marketing automation for podcasts"
)

echo "Creating Podcast Tools project structure with index.php..."

mkdir -p "$BASE_DIR/assets/css"
mkdir -p "$BASE_DIR/assets/js"

# Create main README.md
cat > "$BASE_DIR/README.md" << EOF
# Podcast Tools for Nirobtech.com

This project contains 10 tools specially designed for podcast owners and podcast website owners in USA, UK, Canada, Australia, and Germany.

## Project List

EOF

for i in "${!projects[@]}"; do
  echo "$((i+1)). ${projects[$i]} - ${descriptions[$i]}" >> "$BASE_DIR/README.md"
done

cat >> "$BASE_DIR/README.md" << EOF

## Folder Structure

Each tool has its own folder with files.  
Global CSS and JS files are in the 'assets' folder.

## Usage

Requires PHP server to run on localhost.

## Contact

📧 nirobtch@gmail.com  
🌐 https://nirobtech.com
EOF

# Loop through projects to create folders and files
for i in "${!projects[@]}"; do
  proj_dir="$BASE_DIR/${projects[$i]}"
  mkdir -p "$proj_dir/assets/css"
  mkdir -p "$proj_dir/assets/js"
  mkdir -p "$proj_dir/docs"

  # Create README.md for each project
  cat > "$proj_dir/README.md" << EOF
# ${projects[$i]}

${descriptions[$i]}

## Files

- index.php - Entry point file including main script  
- ${projects[$i]}.php - Main script file  
- assets/css/ - CSS files  
- assets/js/ - JavaScript files  
- docs/ - Documentation files  

## Instructions

Access this tool via index.php on a PHP server locally.

EOF

  # Create main PHP file
  main_php_file="$proj_dir/${projects[$i]}.php"
  cat > "$main_php_file" << EOF
<?php
/*
 * ${projects[$i]}
 * Description: ${descriptions[$i]}
 * Author: Nirobtech
 * Website: https://nirobtech.com
 */

echo "<h1>${projects[$i]}</h1>";
echo "<p>${descriptions[$i]}</p>";
?>
EOF

  # Create index.php file which includes the main PHP file
  cat > "$proj_dir/index.php" << EOF
<?php
/*
 * Entry point for ${projects[$i]}
 * Includes main script file
 */
include __DIR__ . '/${projects[$i]}.php';
?>
EOF

done

# Create global css and js placeholder files
echo "/* Global CSS for Podcast Tools */" > "$BASE_DIR/assets/css/global.css"
echo "// Global JS for Podcast Tools" > "$BASE_DIR/assets/js/global.js"

echo "Project structure with index.php created successfully in ./$BASE_DIR"
