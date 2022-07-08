/*
 * @Description: 
 * @Author: liyoucheng
 * @Date: 2022-05-09 08:46:29
 * @LastEditTime: 2022-07-05 11:09:47
 * @LastEditors: liyoucheng
 */
/**
 * @format
 */

import {AppRegistry} from 'react-native';
import APage from './src/pages/card-a'
import BPage from './src/pages/card-b'
// import APage from './src/pages/index';
// import {name as appName} from './app.json';

AppRegistry.registerComponent('aPage', () => APage);
AppRegistry.registerComponent('bPage', () => BPage);
