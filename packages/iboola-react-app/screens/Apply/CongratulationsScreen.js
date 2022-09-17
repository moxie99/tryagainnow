import {
  Image,
  StyleSheet,
  Text,
  Touchable,
  TouchableOpacity,
  View,
} from "react-native";
import React from "react";

const CongratulationsScreen = () => {
  return (
    <View>
      <View style={{ position: "relative" }}>
        <Image
          source={require("../../assets/images/bg.png")}
          style={{ width: "100%", height: "100%", resizeMode: "cover" }}
        />
      </View>
      {/* <View style={{ position: "absolute", bottom: "10%" }}> */}
      <TouchableOpacity
        style={{
          width: "90%",
          height: 50,
          alignItems: "center",
          justifyContent: "center",
          backgroundColor: "white",
          position: "absolute",
          bottom: "5%",
          left: "5%",
          borderRadius: 15,
        }}
      >
        <Text>Next</Text>
      </TouchableOpacity>
      {/* </View> */}
    </View>
  );
};

export default CongratulationsScreen;

const styles = StyleSheet.create({});
