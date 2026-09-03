{...}: {
  flake.modules.darwin.desktop = {...}: {
    system.defaults = {
      dock = {
        # Hide the dock
        autohide = true;
        # No dots for running Apps
        show-process-indicators = false;
        # No recent Apps section
        show-recents = false;
        # Only running Apps
        static-only = true;
      };
      finder = {
        # Shows file extensions
        AppleShowAllExtensions = true;
        # Show path bar in the bottom of the Finder windows
        ShowPathbar = true;
        # Suppresses warning when changing a file extension.
        FXEnableExtensionChangeWarning = false;
        # Set the default view to column
        FXPreferredViewStyle = "clmv";
        # Show full path in title
        _FXShowPosixPathInTitle = true;
      };
      # Disable quarantine for Apps installed outside the AppStore
      LaunchServices.LSQuarantine = false;
      screencapture.location = "~/screenshots";
      NSGlobalDomain = {
        # Save new files to the local disk
        NSDocumentSaveNewDocumentsToCloud = false;
        # Control + Command + Click = Move window by clicking anywhere
        NSWindowShouldDragOnGesture = true;
      };
    };
  };
}
