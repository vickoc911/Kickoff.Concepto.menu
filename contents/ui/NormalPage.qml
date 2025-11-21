/*
 * SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import org.kde.plasma.plasmoid

EmptyPage {
    id: root
    property real preferredSideBarWidth: Math.max(footer.tabBar.implicitWidth, 200)
    property bool places: Plasmoid.configuration.placesFirst

    contentItem: HorizontalStackView {
        Component {
            id: lugar0
            HorizontalStackView {
                id: stackView
                focus: true
                reverseTransitions: footer.tabBar.currentIndex === 1
                initialItem: PlacesPage {
                    id: placesPage
                    preferredSideBarWidth: root.preferredSideBarWidth + kickoff.backgroundMetrics.leftPadding
                }
                Component {
                    id: applicationsPage
                    ApplicationsPage {
                        preferredSideBarWidth: root.preferredSideBarWidth + kickoff.backgroundMetrics.leftPadding
                        preferredSideBarHeight: placesPage.implicitSideBarHeight
                    }
                }
                Connections {
                    target: footer.tabBar
                    function onCurrentIndexChanged() {
                        if (footer.tabBar.currentIndex === 0) {
                            stackView.replace(placesPage)
                        } else if (footer.tabBar.currentIndex === 1) {
                            stackView.replace(applicationsPage)
                        }
                    }
                }
            }

        }

        Component {
            id: lugar1
            HorizontalStackView {
                id: stackView
                focus: true
                reverseTransitions: footer.tabBar.currentIndex === 1
                initialItem: ApplicationsPage {
                    id: applicationsPage
                    preferredSideBarWidth: root.preferredSideBarWidth + kickoff.backgroundMetrics.leftPadding
                }
                Component {
                    id: placesPage
                    PlacesPage {
                        preferredSideBarWidth: root.preferredSideBarWidth + kickoff.backgroundMetrics.leftPadding
                        preferredSideBarHeight: applicationsPage.implicitSideBarHeight
                    }
                }
                Connections {
                    target: footer.tabBar
                    function onCurrentIndexChanged() {
                        if (footer.tabBar.currentIndex === 0) {
                            stackView.replace(applicationsPage)
                        } else if (footer.tabBar.currentIndex === 1) {
                            stackView.replace(placesPage)
                        }
                    }
                }
            }

        }

        contentItem: {
            switch( root.places ) {
                case true:   return lugar0.createObject(root);
                case false: return lugar1.createObject(root);
            }

      /*    if (root.places) {
              lugar1.createObject(root);
          }
          else {
              lugar0.createObject(root);
          } */
        }
    }

    footer: Footer {
        id: footer
        preferredTabBarWidth: root.preferredSideBarWidth
        Binding {
            target: kickoff
            property: "footer"
            value: footer
            restoreMode: Binding.RestoreBinding
        }
        // Eat down events to prevent them from reaching the contentArea or searchField
        Keys.onDownPressed: event => {}
    }
}
