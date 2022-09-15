import {
  FlatList,
  Image,
  ImageBackground,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import React from "react";
import { AntDesign } from "@expo/vector-icons";
import { COLORS } from "../../constant";

const data = [
  {
    id: 0,
    uri: "https://images.unsplash.com/photo-1607326957431-29d25d2b386f",
    title: "Dahlia",
    location: "Garki, Abuja",
    title: "What is iBOOLA DAO?",
    subtitle: "Understanding how iBOOLA DAO works",
    _created: "5min",
  }, // https://unsplash.com/photos/Jup6QMQdLnM
  {
    id: 1,
    uri: "https://images.unsplash.com/photo-1512238701577-f182d9ef8af7",
    title: "Sunflower",
    location: "Wuse, Abuja",
    title: "Why join a community",
    subtitle: "Importance of iBOOLA community and DAO",
    _created: "5min",
  }, // https://unsplash.com/photos/oO62CP-g1EA
  {
    id: 2,
    uri: "https://images.unsplash.com/photo-1627522460108-215683bdc9f6",
    title: "Zinnia",
    location: "Nyanya, Abuja",
    title: "Frequently asked questions",
    subtitle: "Understanding how iBOOLA DAO works",
    _created: "5min",
  }, // https://unsplash.com/photos/gKMmJEvcyA8
  {
    id: 3,
    uri: "https://images.unsplash.com/photo-1587814213271-7a6625b76c33",
    title: "Tulip",
    location: "ABa, Abuja",
    title: "What is iBOOLA DAO?",
    subtitle: "Understanding how iBOOLA DAO works",
    _created: "5min",
  }, // https://unsplash.com/photos/N7zBDF1r7PM
  {
    id: 4,
    uri: "https://images.unsplash.com/photo-1588628566587-dbd176de94b4",
    title: "Chrysanthemum",
    location: "Kubwa, Abuja",
    title: "What is iBOOLA DAO?",
    subtitle: "Understanding how iBOOLA DAO works",
    _created: "5min",
  }, // https://unsplash.com/photos/GsGZJMK0bJc
  {
    id: 5,
    uri: "https://images.unsplash.com/photo-1501577316686-a5cbf6c1df7e",
    title: "Hydrangea",
    location: "Gwagwalada, Abuja",
    title: "What is iBOOLA DAO?",
    subtitle: "Understanding how iBOOLA DAO works",
    _created: "5min",
  }, // https://unsplash.com/photos/coIBOiWBPjk
];
const DAO = () => {
  return (
    <View>
      <View
        style={{
          flexDirection: "row",
          alignItems: "center",
          justifyContent: "space-between",
          paddingHorizontal: "5%",
        }}
      >
        <View>
          <Text>DAO</Text>
          <Text>Sign Up to join an IBOOLA DAO</Text>
        </View>

        <TouchableOpacity>
          <AntDesign name="questioncircle" size={24} color="#123524" />
        </TouchableOpacity>
      </View>
      <View
        style={{
          flexDirection: "row",
          justifyContent: "space-between",
          paddingHorizontal: "5%",
        }}
      >
        <Text>Available DAOs</Text>
        <Text>See All</Text>
      </View>
      <View style={{ paddingHorizontal: "5%" }}>
        <FlatList
          data={data}
          horizontal={true}
          showsHorizontalScrollIndicator={false}
          removeClippedSubviews={true}
          ItemSeparatorComponent={() => {
            return (
              <View
                style={{
                  height: "100%",
                  width: 10,
                }}
              />
            );
          }}
          scrollEnabled={true}
          keyExtractor={(_, index) => index.toString()}
          renderItem={({ item, index }) => (
            <View
              style={{
                width: 200,
                height: 200,
                backgroundColor: "lightgray",
                borderRadius: 15,
              }}
            >
              <Image
                source={{ uri: item.uri }}
                style={{ width: "100%", height: "80%", borderRadius: 15 }}
              />
              <Text>{item.title}</Text>
              <Text>{item.location}</Text>
            </View>
          )}
        />
      </View>

      <View>
        <Text>About DAO</Text>
      </View>

      <View style={{ paddingHorizontal: "5%" }}>
        <FlatList
          data={data}
          scrollEnabled={true}
          keyExtractor={(_, index) => index.toString()}
          renderItem={({ item, index }) => (
            <View
              style={{
                width: "100%",
                height: 200,
                backgroundColor: "lightgray",
                borderRadius: 15,
                flex: 1,
                marginBottom: "5%",
                borderRadius: 15,
              }}
            >
              <ImageBackground
                source={{ uri: item.uri }}
                resizeMode="cover"
                style={{
                  flex: 1,
                  justifyContent: "center",
                }}
              >
                <Text
                  style={{
                    backgroundColor: COLORS.gray,
                    position: "absolute",
                    top: 10,
                    padding: 10,
                  }}
                >
                  {item._created}
                </Text>
                <Text>{item.title}</Text>
                <Text>{item.subtitle}</Text>
              </ImageBackground>
            </View>
          )}
        />
      </View>
    </View>
  );
};

export default DAO;

const styles = StyleSheet.create({});
