from PySide6.QtCore import QObject, Slot, Signal, Property
import platformdirs, os, json
from pathlib import Path

class SettingsManager(QObject):
	_default_engine = 'https://search.brave.com/search?q=%s'

	def __init__(self):
		super().__init__()
		self.config_path = self.get_config_path()
		self.config_path.parent.mkdir(parents=True, exist_ok=True)
		self._search_engine = self.load_default_engine()

	def get_search_engine(self) -> str:
		return self._search_engine

	@Slot(str)
	def saveSearchEngine(self, engine_url):
		self._search_engine = engine_url
		data = {
			'search_engine': engine_url
		}
		self.config_path.parent.mkdir(parents=True, exist_ok=True)
		with open(self.config_path, 'w') as f:
			json.dump(data, f, indent=4)

	def load_default_engine(self) -> str:
		if os.path.exists(self.config_path):
			try:
				with open(self.config_path, 'r') as f:
					data = json.load(f)
					return data.get('search_engine', self._default_engine)
			except Exception:
				pass
		return self._default_engine

	def get_config_path(self) -> Path:
		return Path(platformdirs.user_config_dir('quiksearch')) / 'config.json'

	searchEngineChanged = Signal()
	searchEngine = Property(str, get_search_engine, notify=searchEngineChanged)