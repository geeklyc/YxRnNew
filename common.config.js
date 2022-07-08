/*
 * @Description: 基础包
 * @Author: liyoucheng
 * @Date: 2022-04-13 15:48:45
 * @LastEditTime: 2022-07-08 10:55:49
 * @LastEditors: liyoucheng
 */

'use strict';

const fs = require('fs');
const pathSep = require('path').sep;

// 输出主包清单
function manifest (path) {
  if (path.length) {
    const manifestFile = `./dist/common_manifest_${process.env.PLATFORM}.txt`;
    if (!fs.existsSync(manifestFile)) {
        fs.writeFileSync(manifestFile, path);
    } else {
        fs.appendFileSync(manifestFile, '\n' + path);
    }
  }
}

// 是否打入当前的包
function processModuleFilter(module) {
  manifest(module['path']);
  return true;
}

// 生成 require 语句的模块 ID
function createModuleIdFactory () {
    return path => {
        let name = '';
        if (path.startsWith(__dirname)) {
            name = path.substr(__dirname.length + 1);
        }
        let regExp = pathSep == '\\' ?
            new RegExp('\\\\', "gm") :
            new RegExp(pathSep, "gm");
        return name.replace(regExp, '_');
    }
}

module.exports = {
    serializer: {
        createModuleIdFactory,
        processModuleFilter
    }
};



// const { generalCommonModuleID } = require('./builds/getModuleId')

// const pathSep = require('path').sep;

// // // 是否打入当前的包
// function processModuleFilter(module) {
// //   // console.log("processModuleFilter path", module)
// //   const filePath = module.path

// //   // if (filePath.indexOf('__prelude__') >= 0 
// //   // || filePath.indexOf('/node_modules/react-native/Libraries/polyfills') > 0
// //   // || filePath.indexOf('/node_modules/metro/src/lib/polyfills/') > 0) {
// //   //   return false;
// //   // }

// //   if (filePath.indexOf('__prelude__') >= 0) {
// //     return false;
// //   }

// //   // // 只判断了 node_modules 中文件，未处理自定义公共文件
// //   // if (filePath.indexOf(`${pathSep}node_modules${pathSep}`) > 0) {
// //   //   if (`js${pathSep}script${pathSep}virtual` === module.output[0].type) {
// //   //     return true;
// //   //   }

// //   //   // 是否在主包中
// //   //   const { isPlatform } = getModuleId({
// //   //     bundleName,
// //   //     filePath,
// //   //     isBuz: true,
// //   //     moduleIndex
// //   //   })
// //   //   return !isPlatform
// //   // }

//   return true;
// }

// // 生成 require 语句的模块 ID
// function createModuleIdFactory () {
//   // console.log("createModuleIdFactory")
//   // return path => {
//   //   // console.log("createModuleIdFactory path", path, __dirname)
//   //     let name = '';
//   //     if (path.startsWith(__dirname)) {
//   //         name = path.substr(__dirname.length + 1);
//   //     }
//   //     let regExp = pathSep == '\\' ?
//   //         new RegExp('\\\\', "gm") :
//   //         new RegExp(pathSep, "gm");
//   //     // console.log("name.replace(regExp, '_')", name.replace(regExp, '_'))
//   //     console.log("Module ID", name.replace(regExp, '_'))
//   //     return name.replace(regExp, '_');
//   // }
//     return path => {
//       // console.log("path ====>", path)
//       const { moduleId } = generalCommonModuleID({ filePath: path })
//       return moduleId
//     }
// }

// module.exports = {
//   serializer: {
//       createModuleIdFactory,
//       processModuleFilter
//   }
// };