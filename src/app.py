#!/usr/bin/env python3

import os
import sys
import signal
from importlib.resources import files

from PySide6.QtGui import QGuiApplication
from PySide6.QtCore import QUrl
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWebEngineQuick import QtWebEngineQuick

from quiksearch.settings_manager import SettingsManager # type: ignore

def main():
    QtWebEngineQuick.initialize()

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    settings_manager = SettingsManager()
    engine.rootContext().setContextProperty('SettingsManager', settings_manager)

    """Needed to close the app with Ctrl+C"""
    signal.signal(signal.SIGINT, signal.SIG_DFL)

    """Needed to get proper KDE style outside of Plasma"""
    if not os.environ.get("QT_QUICK_CONTROLS_STYLE"):
        os.environ["QT_QUICK_CONTROLS_STYLE"] = "org.kde.desktop"

    base_path = files('quiksearch').joinpath('qml', 'Main.qml')
    url = QUrl(f"{base_path}")
    engine.load(url)

    app.exec()

if __name__ == "__main__":
    main()
