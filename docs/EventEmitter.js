export class EventEmitter {
  _eventMap = new Map();

  on(event, callback) {
    if (!this._eventMap.has(event)) {
      this._eventMap.set(event, []);
    }
    this._eventMap.get(event).push(callback);
  }

  off(event, callback) {
    if (this._eventMap.has(event)) {
      const callbacks = this._eventMap.get(event).filter(cb => cb !== callback);
      this._eventMap.set(event, callbacks);
    }
  }

  emit(event, ...data) {
    if (this._eventMap.has(event)) {
      this._eventMap.get(event).forEach(callback => {
        setTimeout(() => callback(...data), 0);
      });
    }
  }
}
