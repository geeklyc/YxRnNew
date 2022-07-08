/*
 * @Description: 
 * @Author: liyoucheng
 * @Date: 2022-04-07 08:50:12
 * @LastEditTime: 2022-07-08 16:24:34
 * @LastEditors: liyoucheng
 */
import React, { Component } from "react";
import { Text, View, StyleSheet, Image } from "react-native";

class CardA extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text>卡片 A</Text>
        <Image source={require('./1.jpeg')} style={styles.image} />
      </View>
    );
  }
}

export default CardA;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  image: {
    width: 100,
    height: 100,
    backgroundColor: 'gray'
  }
})