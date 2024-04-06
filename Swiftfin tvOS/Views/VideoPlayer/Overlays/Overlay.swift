//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2024 Jellyfin & Jellyfin Contributors
//

import SwiftUI
import VLCUI

extension VideoPlayer {

    struct Overlay: View {

        @Environment(\.isPresentingOverlay)
        @Binding
        private var isPresentingOverlay

        @EnvironmentObject
        private var proxy: VLCVideoPlayer.Proxy
        @EnvironmentObject
        private var router: VideoPlayerCoordinator.Router

        @State
        private var currentOverlayType: VideoPlayer.OverlayType = .main
        @State
        private var isPlaying: Bool = true
        @StateObject
        private var overlayTimer: TimerProxy = .init()

        var body: some View {
            ZStack {

                MainOverlay()
                    .environmentObject(overlayTimer)
                    .visible(currentOverlayType == .main)

                ChapterOverlay()
                    .environmentObject(overlayTimer)
                    .visible(currentOverlayType == .chapters)
            }
            .animation(.linear(duration: 0.1), value: currentOverlayType)
            .environment(\.currentOverlayType, $currentOverlayType)
            .onChange(of: isPresentingOverlay) { newValue in
                guard newValue else { return }
                currentOverlayType = .main
            }
            .onPlayPauseCommand(perform: {
                if isPlaying {
                    proxy.pause()
                    isPlaying = false
                    currentOverlayType = .main
                    isPresentingOverlay = true
                } else {
                    proxy.play()
                    isPlaying = true
                }
            })
            .onLongPressGesture(perform: {
                // bring up subtitle menu and playback statistics, media/codec information
                // this triggers on the siri 4k remote when holding the touch selector for 0.5 seconds and releasing
            })
            .onMoveCommand(perform: { _ in
                // when user presses the arrow keys on remote this comes up
                currentOverlayType = .main
                isPresentingOverlay = true
                overlayTimer.start(5)
            })
            .onExitCommand {
                proxy.stop()
                router.dismissCoordinator()
            }
        }
    }
}
