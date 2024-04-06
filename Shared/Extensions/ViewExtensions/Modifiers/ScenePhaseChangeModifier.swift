//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2024 Jellyfin & Jellyfin Contributors
//

import SwiftUI

struct ScenePhaseChangeModifier: ViewModifier {

    @Environment(\.scenePhase)
    private var scenePhase

    let phase: ScenePhase
    let action: () -> Void

    func body(content: Content) -> some View {
        content.onChange(of: scenePhase) {
            if scenePhase == phase {
                action()
            }
        }
    }
}
