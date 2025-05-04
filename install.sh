#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Log functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log_error "This script is only for macOS"
        exit 1
    fi
}

# Check for internet connection
check_internet() {
    log_info "Checking internet connection..."
    if ! ping -c 1 google.com &> /dev/null; then
        log_error "No internet connection detected"
        exit 1
    fi
}

# Install Homebrew if not already installed
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Enable Homebrew on arm64 Macs
        if [[ "$(uname -m)" == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        log_info "Homebrew is already installed"
    fi
}

install_brewfile() {
  log_info "Installing Brewfile..."

  brew bundle --file=brewfile

  log_info "Brewfile installed"
}

install_dotfiles() {
  log_info "Installing dotfiles..."

  cp -r .zshrc ~/.zshrc

  log_info "Dotfiles installed"
}

backup_preferences() {
    local backup_dir="$HOME/.mac-setup-backup/$(date +%Y%m%d_%H%M%S)"
    log_info "Backing up current system preferences to $backup_dir"

    mkdir -p "$backup_dir"

    # Backup dock preferences
    defaults export com.apple.dock "$backup_dir/dock.plist"

    # Backup finder preferences
    defaults export com.apple.finder "$backup_dir/finder.plist"

    # Backup global preferences
    defaults export NSGlobalDomain "$backup_dir/global.plist"

    log_info "Preferences backup completed"
}

configure_dock_preferences() {
  log_info "Configuring dock preferences"

  # Enable dock auto-hide
  defaults write com.apple.dock autohide -bool true
  # Position dock on the left
  defaults write com.apple.dock orientation -string "left"
  # Don't show recent apps in dock
  defaults write com.apple.dock show-recents -bool false
  # Enable dock magnification
  defaults write com.apple.dock magnification -bool true
  # Set dock icon size
  defaults write com.apple.dock tilesize -int 48
  # Set dock icon magnified size
  defaults write com.apple.dock largesize -int 83
  # Show indicators for open apps
  defaults write com.apple.dock show-process-indicators -bool true
  # Minimize windows into dock icon
  defaults write com.apple.dock minimize-to-application -bool false
}

configure_finder_preferences() {
  log_info "Configuring finder preferences"

  # Show hidden files
  defaults write com.apple.finder AppleShowAllFiles -bool true
  # Show path bar
  defaults write com.apple.finder ShowPathbar -bool true
  # Show status bar
  defaults write com.apple.finder ShowStatusBar -bool true
  # Show full POSIX path in title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  # Show external drives on desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  # Show internal drives on desktop
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  # Show network volumes on desktop
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  # Show removable media on desktop
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
  # Set sidebar width
  defaults write com.apple.finder SidebarWidth -int 252
}

configure_global_preferences() {
  log_info "Configuring global preferences"

  # Show all file extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  # Enable automatic capitalization
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
  # Enable automatic period substitution
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true
  # Save new documents locally by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  # Use Dark mode
  defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

  # Disable screen flash on alert beep
  defaults write com.apple.sound.beep.flash -bool false
  # Enable spring loading for directories
  defaults write NSGlobalDomain com.apple.springing.enabled -bool true
  # Set spring loading delay
  defaults write NSGlobalDomain com.apple.springing.delay -float 0.5

  # Set system language to US English
  defaults write NSGlobalDomain AppleLanguages -array "en-US"
  # Set system locale to US
  defaults write NSGlobalDomain AppleLocale -string "en_US"
  # Enable automatic spelling correction
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true
}

configure_mouse_preferences() {
  log_info "Configuring mouse preferences"

  # Set bottom-right corner to secondary click
  defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
  # Unused/legacy corner primary click setting
  defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerPrimaryClick -int 2
  # Enable tap-to-click
  defaults write com.apple.mouse.tapBehavior -int 1
  # Enable Force Click
  defaults write com.apple.trackpad.forceClick -bool true
  # Set trackpad tracking speed
  defaults write com.apple.trackpad.scaling -float 1.5
}

configure_finder_preferences() {
  log_info "Configuring finder preferences"

  # Set default view style to List View
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  # Configure default Icon View settings (abbreviated)
  defaults write com.apple.finder StandardViewSettings -dict-add "IconViewSettings" '{\"arrangeBy\":\"none\",\"backgroundColorBlue\":1,\"backgroundColorGreen\":1,\"backgroundColorRed\":1,\"backgroundType\":0,\"gridOffsetX\":0,\"gridOffsetY\":0,\"gridSpacing\":54,\"iconSize\":64,\"labelOnBottom\":1,\"showIconPreview\":1,\"showItemInfo\":0,\"textSize\":12,\"viewOptionsVersion\":1}'
  # Configure default List View settings (abbreviated)
  defaults write com.apple.finder StandardViewSettings -dict-add "ListViewSettings" '{\"calculateAllSizes\":0,\"columns\":{\"comments\":{\"ascending\":1,\"index\":7,\"visible\":0,\"width\":300},\"dateCreated\":{\"ascending\":0,\"index\":2,\"visible\":0,\"width\":181},\"dateLastOpened\":{\"ascending\":0,\"index\":8,\"visible\":0,\"width\":200},\"dateModified\":{\"ascending\":0,\"index\":1,\"visible\":1,\"width\":181},\"kind\":{\"ascending\":1,\"index\":4,\"visible\":1,\"width\":115},\"label\":{\"ascending\":1,\"index\":5,\"visible\":0,\"width\":100},\"name\":{\"ascending\":1,\"index\":0,\"visible\":1,\"width\":300},\"size\":{\"ascending\":0,\"index\":3,\"visible\":1,\"width\":97},\"version\":{\"ascending\":1,\"index\":6,\"visible\":0,\"width\":75}},\"iconSize\":16,\"showIconPreview\":1,\"sortColumn\":\"name\",\"textSize\":13,\"useRelativeDates\":1,\"viewOptionsVersion\":1}'

  # Set default size/position for save/open panels (abbreviated)
  defaults write com.apple.finder "NSWindow Frame NSNavPanelAutosaveName" -string "624 643 800 363 0 0 2048 1281 "
  # Set new Finder windows to open Desktop
  defaults write com.apple.finder NewWindowTarget -string "PfDe"
  # Set new Finder window path to Desktop
  defaults write com.apple.finder NewWindowTargetPath -string "file://{$HOME}/Desktop/"
}

main() {
  log_info "Starting installation"


  check_macos
  check_internet

  install_homebrew

  backup_preferences

  install_brewfile

  install_dotfiles

  configure_dock_preferences
  configure_finder_preferences
  configure_global_preferences
  configure_mouse_preferences

  log_info "Installation completed"
}

main
