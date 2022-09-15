import {
  SafeAreaView,
  StyleSheet,
  Text,
  TextInput,
  View,
  Switch,
} from "react-native";
import React from "react";
import { Ionicons } from "@expo/vector-icons";
import { createMaterialTopTabNavigator } from "react-navigation-tabs";
import MyTabs from "../../nav/TopTabNav";

const Wallet = () => {
  const [isEnabled, setIsEnabled] = React.useState(false);
  const toggleSwitch = () => setIsEnabled((previousState) => !previousState);
  return (
    <SafeAreaView>
      <View
        style={{
          flexDirection: "row",
          alignItems: "center",
          justifyContent: "space-between",
          paddingVertical: "20%",
          paddingHorizontal: "10%",
        }}
      >
        <View style={{ flexDirection: "row", alignItems: "center" }}>
          <Ionicons name="search" size={24} color="black" style={{}} />
          <TextInput
            style={{
              backgroundColor: "white",
              width: "80%",
              height: 50,
              color: "black",
              borderRadius: 15,
            }}
            placeholder=" Search"
          />
        </View>
        <View>
          <Switch
            trackColor={{ false: "#767577", true: "#81b0ff" }}
            thumbColor={isEnabled ? "#f5dd4b" : "#f4f3f4"}
            ios_backgroundColor="#3e3e3e"
            onValueChange={toggleSwitch}
            value={isEnabled}
          />
          <Text>Hide Balance</Text>
        </View>
      </View>
      <View>
        <Text>Wallet</Text>
      </View>
      {/* <View
        style={{
          width: "90%",
          height: 150,
          backgroundColor: "green",
          alignItems: "center",
          paddingHorizontal: "10%",
          justifyContent: "center",
        }}
      >
        <Text>Current Balance</Text>
        <Text>1.00965</Text>
        <Text>iBOOLA</Text>
        <Text>147%</Text>
        <Ionicons name="arrow-up" size={24} color="black" />
        <Text>Load</Text>
        <Text>Recharge</Text>
        <Text>Load</Text>
      </View> */}
      <MyTabs />
    </SafeAreaView>
  );
};

export default Wallet;

const styles = StyleSheet.create({});
