/*
 * @Description: 
 * @Author: liyoucheng
 * @Date: 2022-04-07 08:50:12
 * @LastEditTime: 2022-07-07 10:41:17
 * @LastEditors: liyoucheng
 */
import React, { Component } from "react";
import { Text, View, StyleSheet, Image } from "react-native";

class CardB extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text>卡片 B</Text>
        <Image source={require('./1.jpeg')} style={styles.image} />
      </View>
    );
  }
}

export default CardB;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  image: {
    width: 100,
    height: 100,
  }
})
// 'https://reactnative.dev/img/tiny_logo.png'