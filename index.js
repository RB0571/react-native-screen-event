
'use strict';

var ReactNative = require('react-native');

var {
    NativeModules,
    DeviceEventEmitter
} = ReactNative;

const ScreenEvent = NativeModules.ScreenEvent;
const onScreenLockStateChangeEvent = 'com.apple.springboard.lockstate'

let listener;

module.exports = {
    start: (callback) => {
        const handler = (body) => {
            callback && callback(body)
        }
        listener = DeviceEventEmitter.addListener(
            onScreenLockStateChangeEvent,
            handler
        );
        ScreenEvent.create()
    },
    stop: () => {
        listener && DeviceEventEmitter.removeListener(listener)
        ScreenEvent.destroy()
    }
};

