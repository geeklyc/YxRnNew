/*
 * @Description: 
 * @Author: liyoucheng
 * @Date: 2022-04-13 10:23:24
 * @LastEditTime: 2022-04-19 08:55:28
 * @LastEditors: liyoucheng
 */
'use strict'
const fs = require('fs');

const pathSep = require('path').sep;
var commonModules = null;

// 是否已经在主包清单中
function isInManifest (path) {
    const manifestFile = `./dist/common_manifest_${process.env.PLATFORM}.txt`;

    if (commonModules === null && fs.existsSync(manifestFile)) {
        const lines = String(fs.readFileSync(manifestFile)).split('\n').filter(line => line.length > 0);
        commonModules = new Set(lines);
    } else if (commonModules === null) {
        commonModules = new Set();
    }

    if (commonModules.has(path)) {
        return true;
    }

    return false;
}

// 是否打入当前的包
function processModuleFilter(module) {
    if (module['path'].indexOf('__prelude__') >= 0) {
        return false;
    }
    if (isInManifest(module['path'])) {
        return false;
    }
    return true;
}

// 生成 require 语句的模块 ID
function createModuleIdFactory() {
    return path => {
        let name = '';
        if (path.startsWith(__dirname)) {
            name = path.substr(__dirname.length + 1);
        }
        let regExp = pathSep == '\\' ?
            new RegExp('\\\\',"gm") :
            new RegExp(pathSep,"gm");
        
        return name.replace(regExp,'_');
    };
}


module.exports = {
    serializer: {
        createModuleIdFactory,
        processModuleFilter,
    }
};

// const pathSep = require('path').sep;
// const { generalBusinessModuleID, isCommonModule } = require('./builds/getModuleId')


// // 模块名
// const bundleName = (() => {
//   const matchs = /\/([\w]+)\.(android|ios)\.bundle/.exec(process.argv.join(''));
//   if (!matchs) {
//     return ''
//   }

//   console.log('开始打包', matchs[1], matchs[2])
//   return matchs[1];
// })()

// // 模块索引
// const moduleIndex = (() => {
//   return parseInt(process.argv[process.argv.length - 1], 10) || 0
// })()

// // metro

// // 是否打入当前的包
// function processModuleFilter(module) {
//   const filePath = module.path

//   // if (filePath.indexOf('__prelude__') >= 0) {
//   //   return false;
//   // }
//   if (filePath.indexOf('__prelude__') >= 0 
//   || filePath.indexOf('/node_modules/react-native/Libraries/polyfills') > 0
//   || filePath.indexOf('/node_modules/metro/src/lib/polyfills/') > 0) {
//     return false;
//   }

//   // // 只判断了 node_modules 中文件，未处理自定义公共文件
//   // if (filePath.indexOf(`${pathSep}node_modules${pathSep}`) > 0) {
//   //   if (`js${pathSep}script${pathSep}virtual` === module.output[0].type) {
//   //     return true;
//   //   }

//   //   // 是否在主包中
//   //   return isCommonModule({filePath, bundleName, moduleIndex})
//   // }
//   if (isCommonModule({filePath, bundleName, moduleIndex})) {
//     return false
//   }
  
//   return true;
// }

// // 生成 require 语句的模块 ID
// function createModuleIdFactory() {
//   return (filePath) => {
//     // console.log("====================", filePath, bundleName, moduleIndex)
//     const {moduleId} = generalBusinessModuleID({ 
//       filePath,
//       bundleName,
//       moduleIndex
//     });
//     // console.log("业务模块 ID", moduleId)
//     // const { moduleId } = getModuleId({
//     //   bundleName,
//     //   filePath,
//     //   isBuz: true, ///< 是否业务包
//     //   moduleId
//     // })
//     // console.log("生成的模块ID", )
//     return moduleId;
//   }
// }

// module.exports = {
//   serializer: {
//       createModuleIdFactory,
//       processModuleFilter
//   }
// };