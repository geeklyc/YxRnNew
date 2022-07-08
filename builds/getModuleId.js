/*
 * @Description: 
 * @Author: liyoucheng
 * @Date: 2022-04-13 11:27:25
 * @LastEditTime: 2022-04-18 17:30:33
 * @LastEditors: liyoucheng
 */
const fs = require('fs')
const crypto = require('crypto')
const path = require('path')

const commonIdsFile = path.resolve(__dirname, './commonIds.json')
const commonIdKeysFile = path.resolve(__dirname, './commonIdKeys.json')
const businessIdsFile = path.resolve(__dirname, './businessIds.json')

// 读取主包 ids 对象
function readCommonIds() {
  let ids = {}
  if (fs.existsSync(commonIdsFile)) {
    ids = JSON.parse(fs.readFileSync(commonIdsFile))
  }
  return ids;
}

// 读取主包 ids 数组
function readCommonIdKeys() {
  let keys = []
  // ids 已经存在文件，直接读取
  if (fs.existsSync(commonIdKeysFile)) {
    keys = JSON.parse(fs.readFileSync(commonIdKeysFile))
  }
  return keys
}

// 读取业务包 ids 对象
function readBusisnessIds() {
  let ids = {}
  if (fs.existsSync(businessIdsFile)) {
    ids = JSON.parse(fs.readFileSync(businessIdsFile))
  }
  return ids;
}

// 清空业务 ids 对象
function clearBusinessIds() {
  console.log("清空")
  if (fs.existsSync(businessIdsFile)) {
    fs.writeFileSync(businessIdsFile, '')
  }
}

// businessIdsFile
// 生成主模块 ID
function generalCommonModuleID({ filePath }) {
  // console.log('-----> generalCommonModuleID')
  // 根据内容打包
  const buffer = fs.readFileSync(filePath)
  let hash = crypto.createHash('sha1')
  .update(buffer)
  .digest('hex')
  .substr(0, 8);

  let ids = readCommonIds();
  let moduleId = ids[hash]
  // ids 中不存在此 moduleId，则添加
  if (!moduleId) {
    moduleId = Object.keys(ids).length + 1;
    ids[hash] = moduleId;
    // 写入 commonIds.json 文件中
    // console.log("公共写入")
    fs.writeFileSync(commonIdsFile, JSON.stringify(ids))
  }

  let idKeys = readCommonIdKeys();
  if (idKeys.indexOf(moduleId) === -1) {
    // 更新平台 ids
    idKeys.push(moduleId)
    // 写入 commonIdKeys.json 文件中
    // 写入 commonIds.json 文件中
    // console.log("公共写入 json")
    fs.writeFileSync(commonIdKeysFile, JSON.stringify(idKeys))
  }

  return {
    moduleId
  };
}

// 生成业务包模块 ID
function generalBusinessModuleID({ bundleName, filePath, moduleIndex}) {
  // console.log("====================222", filePath, bundleName, moduleIndex)
  const relPath = path.relative(path.resolve(__dirname, '../'), filePath);
  // console.log('relPath', readBusisnessIds())

  // node_modules 根据内容打包
  const isNodeModules = relPath.startsWith('node_modules');
  let hash
  if (isNodeModules) {
    // 根据内容打包
    const buffer = fs.readFileSync(filePath)
    hash = crypto.createHash('sha1')
    .update(buffer)
    .digest('hex')
    .substr(0, 8);
  } else {
    // 根据路径打包（由于内容经常变化）
    hash = crypto.createHash('sha1')
    .update(`${bundleName}:${relPath}`)
    .digest('hex')
    .substr(0, 8);
  }

  let idKeys = readCommonIdKeys();
  if (idKeys.length === 0) {
    console.error('请先打基础包')
    process.exit(1);
  }

  let ids = readBusisnessIds()

  // // console.log('执行次数')
  // if (Object.keys(ids).length === 376) {
  //   // console.log('借宿了')
  //   return '1';
  // }
  // console.log("ids", Object.keys(ids).length)
  let moduleId = ids[hash]
  // ids 中不存在此 moduleId，则添加

  // console.log("=======>", isNodeModules, moduleId)
  if (!moduleId) {
    moduleId = Object.keys(ids).length + 1;

    if (!isNodeModules) {
      moduleId += moduleIndex;
    }
    // console.log("+++++", moduleId)
    ids[hash] = moduleId;
    // 写入 businessIds.json 文件中
    // console.log("莫名写入", Object)
    fs.writeFileSync(businessIdsFile, JSON.stringify(ids))
  }

  return {
    moduleId,
  };
}

// 是否主包中
function isCommonModule({filePath, bundleName, moduleIndex}) {
  const commonIdKeys = readCommonIdKeys();
  const { moduleId } = generalBusinessModuleID({ filePath, bundleName, moduleIndex })
  // console.log("主包判断", moduleId)
  return commonIdKeys.indexOf(moduleId) > 0
  // return true
}

module.exports = {
  generalCommonModuleID,
  generalBusinessModuleID,
  isCommonModule
}