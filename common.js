/*
 * @Description: 
 * @Author: liyoucheng
 * @Date: 2022-04-07 09:50:01
 * @LastEditTime: 2022-07-08 17:37:34
 * @LastEditors: liyoucheng
 */
import {} from 'react'
import {} from 'react-native'
import AssetSourceResolver from 'react-native/Libraries/Image/AssetSourceResolver'
import { Platform, NativeModules, NativeEventEmitter } from 'react-native'

// 第三方

// 公共代码（监控、分享等）

let bundlePath = null;

const SmartAssets = {
  init() {
    AssetSourceResolver.prototype.defaultAsset = function() {
      if (this.isLoadedFromServer()) {
        // 网络图片
        return this.assetServerURL();
      }

      if (Platform.OS === 'android') {
        // 暂未实现
        return this.isLoadedFromFileSystem()
        ? this.drawableFolderInBundle()
        : this.resourceIdentifierWithoutScale();
      } else {
        let iOSAsset = this.scaledAssetURLNearBundle();
        console.log('图片地址1', iOSAsset)
        let newUri = iOSAsset.uri.slice(iOSAsset.uri.indexOf('.app/assets') + '.app/assets'.length);
        iOSAsset.uri = `${bundlePath}${newUri}`
        console.log('图片地址2', iOSAsset)
        return iOSAsset;
      }
    }
  },
  setBunlePath(path) {
    bundlePath = path;
  }
}

SmartAssets.init();

const { ARNAssetEmitter } = NativeModules;
const bundleLoadEmitter = new NativeEventEmitter(ARNAssetEmitter)
const subscription = bundleLoadEmitter.addListener('ARNBundleLoad', bundleInfo => {
  SmartAssets.setBunlePath(bundleInfo.path)
})
console.log("subscription", subscription);

